{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        p = nixpkgs.legacyPackages.${system};
        makeDerivation = flags:
          p.stdenv.mkDerivation {
            name = "mohex";
            src = self;
            cmakeFlags = flags;
            nativeBuildInputs = [ p.cmake ];
            buildInputs = [ p.boost p.db ];
            installPhase =
            ''
              mkdir -p $out/bin
              find src -executable -type f | xargs cp -t $out/bin
              cp -r $src/share/. $out/bin
            '';
          };
      in {
        packages = {
          default = makeDerivation [];
          mohex19 = makeDerivation [ "-DMAX_BOARD_SIZE=19x19" ];
          mohex23 = makeDerivation [ "-DMAX_BOARD_SIZE=23x23" ];
        };
      }
    );
}
