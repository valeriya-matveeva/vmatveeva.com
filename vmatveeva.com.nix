{
  pkgs,
  stdenv
}:
stdenv.mkDerivation rec {
  pname = "vmatveeva.com";
  version = "0.1.0";

  dontPatch = true;

  installFlags = "PREFIX=${placeholder "out"} VERSION=${version}";

  preBuild = ''
    patchShebangs bin/*.sh
  '';

  buildInputs = with pkgs; [
    gawk
    gnused
    rsync
  ];

  src = ./.;

}
