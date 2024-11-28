{ lib, appimageTools, fetchurl }:
appimageTools.wrapType2 rec {
  pname = "chatbox";
  version = "0.10.2";

  src = fetchurl {
    url = "https://github.com/Bin-Huang/chatbox/releases/download/v${version}/Chatbox.CE-${version}-x86_64.AppImage";
    hash = "sha512-fIrRVN6gcvya8KZLVYi94Gi4kYayaet0sobx5wTvsrn2XXMC03JBM7JL/4dC4kCXdvqQNCBu9NDuIBk98MXRsg==";
  };

  meta = with lib; {
    description = "User-friendly Desktop Client App for AI Models/LLMs (GPT, Claude, Gemini, Ollama...) ";
    homepage = "https://chatboxai.app";
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = [ c31io ];
    mainProgram = "chatbox";
    platforms = [ "x86_64-linux" ];
  };
}
