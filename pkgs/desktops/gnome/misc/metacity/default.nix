{ lib, stdenv
, fetchurl
, gettext
, glib
, gnome
, gsettings-desktop-schemas
, gtk3
, xorg
, libcanberra-gtk3
, libgtop
, libstartup_notification
, libxml2
, pkg-config
, substituteAll
, wrapGAppsHook
, zenity
}:

stdenv.mkDerivation rec {
  pname = "metacity";
  version = "3.49.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "s0lvsLILVTPdKwktx5GRaVuaDe6Rg6WFysyF/aQcHbs=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit zenity;
    })
  ];

  nativeBuildInputs = [
    gettext
    libxml2
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    xorg.libXres
    xorg.libXpresent
    xorg.libXdamage
    glib
    gsettings-desktop-schemas
    gtk3
    libcanberra-gtk3
    libgtop
    libstartup_notification
    zenity
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
      versionPolicy = "odd-unstable";
    };
  };

  doCheck = true;

  meta = with lib; {
    description = "Window manager used in Gnome Flashback";
    homepage = "https://wiki.gnome.org/Projects/Metacity";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
