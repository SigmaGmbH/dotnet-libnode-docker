{ callPackage, fetchpatch2, fetchFromGitHub, python311 }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python311;
  };
in
buildNodejs {
  version = "20.9.0";

  src = fetchFromGitHub {
    owner = "jasongin";
    repo = "nodejs";
    rev = "napi-libnode-v20.9.0";
    hash = "sha256-5FbfRRXP4v4mrL7UiTSDF3ao6/h3v23QBCZudUixurs=";
  };
}

