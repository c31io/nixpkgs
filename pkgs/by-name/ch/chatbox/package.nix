{ appimageTools, fetchurl }:
let
  pname = "chatbox";
  version = "0.10.2";
  src = fetchurl {
    url = "https://github.com/Bin-Huang/chatbox/releases/download/v${version}/Chatbox.CE-${version}-x86_64.AppImage";
    hash = "sha512-fIrRVN6gcvya8KZLVYi94Gi4kYayaet0sobx5wTvsrn2XXMC03JBM7JL/4dC4kCXdvqQNCBu9NDuIBk98MXRsg==";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
}
