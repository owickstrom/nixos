# Copied verbatim from nixpkgs unstable (pkgs/by-name/vo/voxtype/package.nix)
# because nixos-26.05 only ships voxtype 0.7.2. The two files differ only in
# version, hashes, the cargoDeps workaround and the ggml SIMD flags. Drop this file and use pkgs.voxtype once 26.05 catches up.
{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,

  clang,
  cmake,
  gitMinimal,
  installShellFiles,
  libclang,
  makeBinaryWrapper,
  pkg-config,

  alsa-lib,
  dotool,
  libnotify,
  openssl,
  pciutils,
  wl-clipboard,
  wtype,
  which,
  xclip,
  xdotool,

  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,

  vulkanSupport ? false,
  shaderc,
  vulkan-headers,
  vulkan-loader,

  onnxSupport ? false,
  onnxruntime,

  waylandSupport ? stdenv.hostPlatform.isLinux,
  waylandRuntimePackages ? [
    dotool
    wl-clipboard
    wtype
  ],

  x11Support ? stdenv.hostPlatform.isLinux,
  x11RuntimePackages ? [
    xclip
    xdotool
  ],

  # x86 CPU level for both the Rust code and the bundled whisper.cpp/ggml.
  # x86-64-v3 is AVX2 and runs on everything from Haswell onwards; x86-64-v4
  # adds AVX-512 and roughly halves whisper inference time, but the binary
  # then only runs on CPUs that have it (Zen 4+, Intel non-hybrid parts).
  cpuTarget ? "x86-64-v3",
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "voxtype";
  version = "1.3.2-rc3";

  src = fetchFromGitHub {
    owner = "peteonrails";
    repo = "voxtype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kBrq70TgtkDuOvmnCpMoTBePsOXHNPjsJta+AP5mm18=";
  };

  # Equivalent to cargoHash = "sha256-hUyz...", except that the vendor step
  # is patched: the openvino-genai git dependency (only built with the
  # openvino-whisper feature, which is off) bundles ittapi, whose
  # rust/ittapi-sys/c-library -> ../../ symlink is a cycle. fetchCargoVendor's
  # copytree follows it until ELOOP and the vendor derivation fails, so the
  # link is dropped from a writable copy of the staging tree first. The staging
  # tree itself is the fixed-output derivation; its hash is unchanged.
  cargoDeps =
    (rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname version src;
      hash = "sha256-hUyzZt1K0IwqBF/UL7k80rOkwjbl8S6P6EQtMlL2o5Y=";
    }).overrideAttrs
      (old: {
        buildCommand = ''
          staging=$(mktemp -d)
          cp -r --no-preserve=mode "$vendorStaging"/. "$staging"/
          rm "$staging"/git/*/crates/openvino-sys/upstream/thirdparty/ittapi/ittapi/rust/ittapi-sys/c-library
          fetch-cargo-vendor-util create-vendor "$staging" "$out"
        '';
      });

  buildFeatures =
    [ ]
    ++ lib.optionals vulkanSupport [ "gpu-vulkan" ]
    ++ lib.optionals onnxSupport [
      "parakeet-load-dynamic"
      "moonshine"
      "sensevoice"
      "paraformer"
      "dolphin"
      "omnilingual"
    ];

  nativeBuildInputs = [
    cmake
    clang
    gitMinimal # Required by whisper.cpp cmake
    installShellFiles
    makeBinaryWrapper
    pkg-config
  ]
  ++ lib.optionals vulkanSupport [
    shaderc
    vulkan-headers
    vulkan-loader
  ];

  buildInputs = [
    alsa-lib
    openssl
  ]
  ++ lib.optionals vulkanSupport [
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals onnxSupport [
    onnxruntime
  ];

  env = {
    # NOTE: set LIBCLANG_PATH so bindgen can locate libclang
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";

    # NOTE: Ensure reproducible builds targeting AVX2-capable CPUs (x86-64-v3)
    # This matches the portable AVX2 binaries we ship for other distros
    RUSTFLAGS = lib.optionalString (
      stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64
    ) "-C target-cpu=${cpuTarget}";

    # RUSTFLAGS above only covers Rust code. The bundled whisper.cpp/ggml is
    # built by cmake from whisper-rs-sys, and ggml turns GGML_NATIVE off when
    # SOURCE_DATE_EPOCH is set (which nix always does), which also disables
    # every GGML_AVX* option: the result is scalar inference, ~5s per pass
    # for base.en on a Zen 5. ggml's kernels key off the compiler's __AVX2__ /
    # __FMA__ / __F16C__ / __AVX512F__ macros, so giving the C/C++ compiles
    # the same target as the Rust code is enough to get the SIMD paths.
    NIX_CFLAGS_COMPILE = lib.optionalString (
      stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64
    ) "-march=${cpuTarget}";
  };

  preBuild = ''
    # NOTE: whisper.cpp cmake needs some help in sandbox
    export CMAKE_BUILD_PARALLEL_LEVEL=$NIX_BUILD_CORES
  ''
  + lib.optionalString vulkanSupport ''
    export VULKAN_SDK="${shaderc.bin}"
  ''
  + lib.optionalString onnxSupport ''
    export ORT_LIB_LOCATION="${lib.getLib onnxruntime}/lib"
  '';

  postInstall = ''
    install -Dm644 config/default.toml \
      $out/share/voxtype/default-config.toml

    wrapProgram $out/bin/voxtype \
      --prefix PATH : ${
        (lib.makeBinPath (
          [
            libnotify
            which
          ]
          ++ lib.optionals vulkanSupport [
            pciutils
          ]
          ++ lib.optionals waylandSupport waylandRuntimePackages
          ++ lib.optionals x11Support x11RuntimePackages
        ))
        + lib.optionalString onnxSupport " \\"
      }
      ${lib.optionalString onnxSupport ''
        --set ORT_DYLIB_PATH "${lib.getLib onnxruntime}/lib/libonnxruntime.so" \
        --prefix LD_LIBRARY_PATH : "${lib.getLib onnxruntime}/lib"
      ''}
  ''
  + lib.optionalString installManPages ''
    installManPage target/debug/build/voxtype-*/out/man/*
  ''
  + lib.optionalString installShellCompletions ''
    installShellCompletion packaging/completions/voxtype.{bash,zsh,fish}
  '';

  # The test suite spawns sh/ffmpeg/clipboard/dbus-run-session helpers that
  # don't exist in the nix sandbox (nine such failures in 1.3.2-rc3, the other
  # ~2900 pass), and it doubles the compile time. Skip it; the install check
  # below still verifies the binary runs.
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.update-script = nix-update-script { };

  meta = {
    description = "Voice-to-text with push-to-talk for Wayland compositors";
    longDescription = ''
      Voxtype is a push-to-talk voice-to-text daemon for Linux.
      Hold a hotkey while speaking, release to transcribe and output
      text at your cursor position. Supports Whisper, Parakeet,
      SenseVoice, Moonshine, Paraformer, Dolphin, and Omnilingual engines.
    '';
    homepage = "https://voxtype.io";
    downloadPage = "https://voxtype.io/download/";
    changelog = "https://github.com/peteonrails/voxtype/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DuskyElf ];
    platforms = lib.platforms.linux;
    mainProgram = "voxtype";
  };
})
