{
  description = "PKU undergraduate thesis Typst workspace";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Notes flake source.
    notes.url = "github:yhtq/Notes";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    notes,
    typix
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

      inherit (pkgs) lib;

      typixLib = typix.lib.${system};

      src = typixLib.cleanTypstSource ./.;
      commonArgs = {
        typstSource = "thesis.typ";

        fontPaths = [
          # Add paths to fonts here
          # "${pkgs.roboto}/share/fonts/truetype"
          "${./fonts}"
        ];

        virtualPaths = [
          # Add paths that must be locally accessible to typst here
          # {
          #   dest = "icons";
          #   src = "${inputs.font-awesome}/svgs/regular";
          # }
          {
            dest = "notes-lib";
            src = "${notes}";
          }
          {
            dest = "asset";
            src = "${./asset}";
          }
          {
            dest = "images";
            src = "${./images}";
          }
        ];
        unstable_typstPackages = [
          {
            name = "curryst";
            version = "0.6.0";
            hash = "sha256-5t606BzJbL/yj14CwRtvnG8/V+XyFEpWTZ6KGHuJM5I=";
          }
          {
            name = "commute";
            version = "0.3.0";
            hash = "sha256-AcGl5iU1kNa3tGwIYfAFihM36V43N5XEMuNAheCP3qo=";
          }
          {
            name = "lemmify";
            version = "0.1.8";
            hash = "sha256-VGWHwtejLgtKgKeFBY9jjqz7A9hz17p3w2uXOCaBwiA=";
          }
          {
            name = "showybox";
            version = "2.0.3";
            hash = "sha256-VQacq1Xi2bnY5Fh4hm0PVBZVXpuxYcn/76Fg/rOprY0=";
          }
          {
            name = "ctheorems";
            version = "1.1.3";
            hash = "sha256-hzWgHWt88VLofnhaq4DB5JAGaWgt1rCDP4O9nknZzVY=";
          }
        ];
      };
      # Compile a Typst project, *without* copying the result
      # to the current directory
      build-drv = typixLib.buildTypstProject (commonArgs
        // {
          inherit src;
        });

      # # Compile a Typst project, and then copy the result
      # # to the current directory
      # build-script = typixLib.buildTypstProjectLocal (commonArgs
      #   // {
      #     inherit src;
      #   });

      # # Watch a project and recompile on changes
      # watch-script = typixLib.watchTypstProject commonArgs;

    in {
      devShells.default = generateShell {inheritEnv = true;};
      devShells.noEnv = generateShell {inheritEnv = false;};
      packages.thesis = build-drv;
      defaultPackage = build-drv;
    });
}
