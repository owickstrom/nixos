{ writeShellScriptBin, vscode-extensions }:

writeShellScriptBin "codelldb" ''
  exec ${vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb "$@"
''
