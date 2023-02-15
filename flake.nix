{
  description = "A Toaq translation of Minecraft";

  inputs.toaq-fonts.url = github:toaq/fonts;
  inputs.nixpkgs.follows = "toaq-fonts/nixpkgs";
  inputs.flake-utils.follows = "toaq-fonts/flake-utils";

  outputs = { self, nixpkgs, flake-utils, toaq-fonts }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        derani-fonts = toaq-fonts.packages.${system}.derani;
      in {
        defaultPackage = pkgs.stdenvNoCC.mkDerivation {
          name = "huaibai";
          src = self;
          buildInputs = with pkgs; [ zip python3 ];
          buildPhase = ''
            python to_latin.py
            cp ${derani-fonts}/share/fonts/opentype/Guezueq.otf \
              src/assets/minecraft/textures/font/guezueq.otf
            cd src
            zip -r ../Huaıbaı.zip *
            cd ..
          '';
          installPhase = ''
            mkdir $out
            mv Huaıbaı.zip $out/
          '';
        };
      }
    );
}
