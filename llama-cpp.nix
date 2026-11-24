# Local LLM serving: llama-server on 127.0.0.1:8080, OpenAI-compatible, for
# opencode (see opencode.nix) and anything else that speaks /v1/chat/completions.
#
# The server runs in router mode: nothing is loaded until a client asks for a
# model by name, so the service costs no RAM while idle. Models listed in
# modelsPreset are fetched from Hugging Face into /var/cache/llama-cpp on
# first use.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  isDesktop = config.networking.hostName == "antithesis-desktop";

  # Same split as voxtype.nix: the desktop's 9900X has AVX-512 (x86-64-v4),
  # the laptop only AVX2 (x86-64-v3), so the two hosts build different
  # binaries. nixpkgs builds llama-cpp with GGML_NATIVE=OFF for
  # reproducibility, which leaves the AVX-512 kernels out unless asked for.
  # ggml keys its kernels off the compiler's __AVX512F__ etc. macros, so
  # -march does most of the work; the explicit GGML_AVX512* flags make sure
  # the cmake side agrees.
  cpuTarget = if isDesktop then "x86-64-v4" else "x86-64-v3";

  llama-cpp =
    (pkgs.llama-cpp.override {
      # The desktop's T1000 (8 GB) can't hold a model, but with a MoE model
      # attention + KV cache fit on it while the experts stay on the CPU,
      # which mostly speeds up prompt processing. Vulkan rather than CUDA:
      # free, cached, builds in minutes.
      vulkanSupport = isDesktop;
    }).overrideAttrs
      (old: {
        NIX_CFLAGS_COMPILE = "-march=${cpuTarget}";
        cmakeFlags =
          old.cmakeFlags
          ++ lib.optionals (cpuTarget == "x86-64-v4") [
            "-DGGML_AVX512=ON"
            "-DGGML_AVX512_VNNI=ON"
            "-DGGML_AVX512_BF16=ON"
          ];
      });
in
{
  services.llama-cpp = {
    enable = true;
    package = llama-cpp;
    host = "127.0.0.1";
    port = 8080;

    # Preset names are the model ids clients ask for. Sampling values are
    # Qwen's recommendations for Qwen3-Coder. 32k of context is ~6.4 GB of
    # KV cache for this model on top of the ~18 GB of weights.
    modelsPreset."qwen3-coder" = {
      hf-repo = "unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF";
      hf-file = "Qwen3-Coder-30B-A3B-Instruct-UD-Q4_K_XL.gguf";
      alias = "qwen3-coder";
      jinja = "on";
      ctx-size = "32768";
      temp = "0.7";
      top-p = "0.8";
      top-k = "20";
      repeat-penalty = "1.05";
    }
    // lib.optionalAttrs isDesktop {
      # Put as many layers on the GPU as fit, experts stay on the CPU.
      fit = "on";
    };
  };

  # The service runs as a DynamicUser with no HOME, and the Vulkan driver
  # then tries to put its shader cache under "//.cache" and complains. Give
  # it the service's cache dir instead.
  systemd.services.llama-cpp.environment = {
    HOME = "/var/cache/llama-cpp";
    XDG_CACHE_HOME = "/var/cache/llama-cpp";
  };

  environment.systemPackages = [ llama-cpp ];
}
