{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let 
inherit stdenv fetchurl fetchpatch cmake pcre pkgconfig python3 libX11 libXpm libXft libXext libGLU_combined zlib libxml2 lz4 lzma gsl xxHash Cocoa OpenGL;
in
{
  root = stdenv.mkDerivation rec {
    name = "root-fftw-${version}";
    version = "6.12.06";
    noSplash = false;

    src = fetchurl {
      url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
      sha256 = "1557b9sdragsx9i15qh6lq7fn056bgi87d31kxdl4vl0awigvp5f";
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ cmake pcre python3 zlib libxml2 lz4 lzma gsl xxHash ]
      ++ stdenv.lib.optionals (!stdenv.isDarwin) [ xlibs.libX11 xlibs.libXpm xlibs.libXft xlibs.libXext libGLU_combined ]
      ++ stdenv.lib.optionals (stdenv.isDarwin) [ Cocoa OpenGL ]
      ;

    patches = [
      ./sw_vers_unix.patch
    ];

    preConfigure = ''
      patchShebangs build/unix/
    '' + stdenv.lib.optionalString noSplash ''
      substituteInPlace rootx/src/rootx.cxx --replace "gNoLogo = false" "gNoLogo = true"
    '';

    cmakeFlags = [
      "-Drpath=ON"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
      "-Dalien=OFF"
      "-Dbonjour=OFF"
      "-Dbuiltin_fftw3=ON"
      "-Dcastor=OFF"
      "-Dchirp=OFF"
      "-Ddavix=OFF"
      "-Ddcache=OFF"
      "-Dfftw3=ON"
      "-Dfitsio=OFF"
      "-Dfortran=OFF"
      "-Dimt=OFF"
      "-Dgfal=OFF"
      "-Dgviz=OFF"
      "-Dhdfs=OFF"
      "-Dkrb5=OFF"
      "-Dldap=OFF"
      "-Dmonalisa=OFF"
      "-Dmysql=OFF"
      "-Dodbc=OFF"
      "-Dopengl=ON"
      "-Doracle=OFF"
      "-Dpgsql=OFF"
      "-Dpythia6=OFF"
      "-Dpythia8=OFF"
      "-Drfio=ON"
      "-Dsqlite=OFF"
      "-Dssl=OFF"
      "-Dxml=ON"
      "-Dxrootd=OFF"
    ]
    ++ stdenv.lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${stdenv.lib.getDev stdenv.cc.libc}/include"
    ++ stdenv.lib.optional stdenv.isDarwin "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks";

    enableParallelBuilding = true;

    setupHook = ./setup-hook.sh;

    meta = {
      homepage = https://root.cern.ch/;
      description = "A data analysis framework";
      platforms = stdenv.lib.platforms.unix;
      maintainers = with stdenv.lib.maintainers; [ veprbl ];
    };
  };
}
