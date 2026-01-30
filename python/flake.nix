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
        pythonPackages = pkgs.python313Packages;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonPackages.python
            pythonPackages.venvShellHook
          ];
          packages = with pkgs; [
            uv
          ];
          venvDir = "./.venv";
          env = {
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
          };
        };
      }
    );
}
