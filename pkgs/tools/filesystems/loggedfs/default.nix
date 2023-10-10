{ callPackage
, lib
, stdenv
, fetchFromGitHub
, nixos
, testers
, pcre2
, libxml2
, fuse
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loggedfs";
  version = "0.9+git20221229.1.82aba9a";

  src = fetchFromGitHub {
    owner = "rflament";
    repo = "loggedfs";
    rev = "82aba9a93489797026ad1a37b637823ece4a7093";
    sha256 = "sha256-88aLwAgI3HvSCoy3KpMy+Yj4WNQ5P7yIY9fTBW/ck6c=";
  };

  buildInputs = [ pcre2 libxml2 fuse ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "LoggedFS is a FUSE-based filesystem which can log every operations that happens in it.";
    homepage = "https://github.com/rflament/loggedfs";
    license = licenses.asl20;
    maintainers = [ maintainers.chordtoll ];
    platforms = platforms.all;
  };
})
