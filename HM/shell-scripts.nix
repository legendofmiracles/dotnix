{ pkgs, ...}:
rec {
  auto_clicker = pkgs.writeShellScriptBin "auto_clicker" ''
    while :
    do
      xdotool mousedown $1
      xdotool mouseup $1
      sleep $2
    done
  '';
  text_from_image = pkgs.writeShellScriptBin "text_from_image" ''
    TEXT_FILE="/tmp/ocr.txt"
    IMAGE_FILE="/tmp/ocr.png"
    maim -s "$IMAGE_FILE"
    STATUS=$?
    [ $STATUS -ne 0 ] && exit 1
    tesseract "$IMAGE_FILE" "''${TEXT_FILE//\.txt/}"
    LINES=$(wc -l < $TEXT_FILE)
    if [ "$LINES" -eq 0 ]; then
        notify-send "ocr" "no text was detected"
        exit 1
    fi
    xclip -selection clip < "$TEXT_FILE"
    notify-send "ocr" "$(cat $TEXT_FILE)"
    rm "$TEXT_FILE"
    rm "$IMAGE_FILE"
  '';
  zerox0 = pkgs.writeShellScriptBin "0x0" ''
    #!/bin/sh
    type=
    ! [ -t 0 ] || file -ibL "$1" | grep -q '^text/' && type=';type=text/plain'

    curl -sF file="@''${1:--}$type" 'http://0x0.st' \
        | tee /dev/stderr \
        | xclip -r -sel clip
  '';
  rnix = pkgs.writeShellScriptBin "rnix" ''
    bash -c "env RUST_LOG=trace rnix-lsp 2> /tmp/rnix-lsp.log"
  '';
  giphsh = pkgs.writeShellScriptBin "giph.sh" ''
    if pgrep "ffmpeg" > /dev/null 2>&1; then
        giph --stop
    else
        giph -s /tmp/recording.webm && curl -F file=@"/tmp/recording.webm" https://0x0.st | xclip -selection c && notify-send "Copied to clipboard!"
    fi
  '';

  }
