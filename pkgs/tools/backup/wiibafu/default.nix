{ stdenv, lib, qmake, qt5, wrapQtAppsHook, fetchFromGitHub }: 

stdenv.mkDerivation {
  pname = "wiibafu";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "evertonstz";
    repo = "wiibafu";
    rev = "c783b355c06609ab37fb0ad3fe5bb9f62b1f74a3";
    sha256 = "kZQhd1YL5NvKqkZ0DQQ1fNqOr1vhnL7iLrFZQZOhZ4w=";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];
  buildInputs = [
    qt5.full
  ];
}

