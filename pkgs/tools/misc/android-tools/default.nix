{ lib, stdenv, fetchurl, fetchpatch
, cmake, perl, go
, protobuf, zlib, gtest, brotli, lz4, zstd, libusb1, pcre2, fmt_7
}:

stdenv.mkDerivation rec {
  pname = "android-tools";
  version = "31.0.2";

  src = fetchurl {
    url = "https://github.com/nmeum/android-tools/releases/download/${version}/android-tools-${version}.tar.xz";
    sha256 = "sha256-YbO/bCQMsLTQzP72lsVZhuBmV4Q2J9+VD9z2iBrw+NQ=";
  };

  patches = [
    # fmt 8 breaks the build but we can use fmt 7 from Nixpkgs:
    (fetchpatch {
      # Vendor google's version of fmtlib
      url = "https://github.com/nmeum/android-tools/commit/21061c1dfb006c22304053c1f6f9e48ae4cbe25a.patch";
      sha256 = "17mcsgfc3i8xq4hck0ppnzafh15aljxy7j2q4djcmwnvrkv9kx3s";
      revert = true;
      excludes = [ "vendor/fmtlib" ];
    })
  ];

  nativeBuildInputs = [ cmake perl go ];
  buildInputs = [ protobuf zlib gtest brotli lz4 zstd libusb1 pcre2 fmt_7 ];

  # Don't try to fetch any Go modules via the network:
  GOFLAGS = [ "-mod=vendor" ];

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
  '';

  meta = with lib; {
    description = "Android SDK platform tools";
    longDescription = ''
      Android SDK Platform-Tools is a component for the Android SDK. It
      includes tools that interface with the Android platform, such as adb and
      fastboot. These tools are required for Android app development. They're
      also needed if you want to unlock your device bootloader and flash it
      with a new system image.
      Currently the following tools are supported:
      - adb
      - fastboot
      - mke2fs.android (required by fastboot)
      - simg2img, img2simg, append2simg
    '';
    # https://developer.android.com/studio/command-line#tools-platform
    # https://developer.android.com/studio/releases/platform-tools
    homepage = "https://github.com/nmeum/android-tools";
    license = with licenses; [ asl20 unicode-dfs-2015 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
