{
  description = "Nix flake for vmatveeva.com";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
      {
        packages = forAllSystems( {pkgs }:
          {
            "vmatveeva.com" = (pkgs.callPackage ./vmatveeva.com.nix {});
            default = (pkgs.callPackage ./vmatveeva.com.nix {});
          }
        );
        overlays.default = final: prev: {
          vmatveevacom = (prev.callPackage ./vmatveeva.com.nix {});
        };
      };
}
