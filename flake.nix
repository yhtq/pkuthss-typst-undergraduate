{
  description = "PKU undergraduate thesis Typst workspace";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Notes flake source.
    notes.url = "github:yhtq/Notes";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    notes,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      generateShell = {inheritEnv}: pkgs.mkShell {

        # inputsFrom = [ notes.devShells.${system}.default ];
        inputsFrom = if inheritEnv then [ notes.devShells.${system}.default ] else [];

        shellHook = ''
          export NOTES="${notes}"
          ln -sfn "${notes}" notes-lib
        '';
      };

    in {
      devShells.default = generateShell {inheritEnv = true;};
      devShells.noEnv = generateShell {inheritEnv = false;};
    });
}
