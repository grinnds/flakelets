{
  description = "A basic flake with a shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python313;
        pythonWithLd = pkgs.writeShellScriptBin "python" ''
          export LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH"
          exec -a "$0" ${pkgs.lib.getExe python} "$@"
        '';
        venvShellHookWithLd = python.pkgs.venvShellHook.overrideAttrs (_: {
          pythonInterpreter = pkgs.lib.getExe pythonWithLd;
        });
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [ venvShellHookWithLd ];
          packages = with pkgs; [
            uv
          ];
          venvDir = "./.venv";
          env = {
            NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
            NIX_LD = pkgs.stdenv.cc.bintools.dynamicLinker;
          };
        };
      }
    );
}
