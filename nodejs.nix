{ lib, gcc11Stdenv, python, util-linux, bash
, pkg-config, which, buildPackages
# for `.pkgs` attribute
, callPackage
}:

{ version, src, patches ? [] } @args:

let
  majorVersion = lib.versions.major version;
  minorVersion = lib.versions.minor version;

  pname = "libnode";

  sharedConfigureFlags = [
    "--shared"
  ];

  extraConfigFlags = [ "--without-npm" "--without-corepack" ];
  self = gcc11Stdenv.mkDerivation {
    inherit pname version src;


    strictDeps = true;

    #CC_host = "cc";
    #CXX_host = "c++";
    # depsBuildBuild = [ buildPackages.stdenv.cc ];

    # NB: technically, we do not need bash in build inputs since all scripts are
    # wrappers over the corresponding JS scripts. There are some packages though
    # that use bash wrappers, e.g. polaris-web.
    buildInputs = [ bash ];

    nativeBuildInputs = [ python which ];

    outputs = [ "out"  ];
    setOutputFlags = false;
    moveToDev = false;

    configureFlags = sharedConfigureFlags ++ extraConfigFlags;

    configurePlatforms = [];

    dontDisableStatic = true;

    enableParallelBuilding = true;

    # Don't allow enabling content addressed conversion as `nodejs`
    # checksums it's image before conversion happens and image loading
    # breaks:
    #   $ nix build -f. nodejs --arg config '{ contentAddressedByDefault = true; }'
    #   $ ./result/bin/node
    #   Check failed: VerifyChecksum(blob).
    __contentAddressed = false;

    pos = builtins.unsafeGetAttrPos "version" args;

    inherit patches;

    doCheck = false;

    passthru.python = python; # to ensure nodeEnv uses the same version
  };
in self
