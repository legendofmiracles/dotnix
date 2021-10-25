{ pkgs, inputs, lib, ... }:

rec {
  auto_clicker = pkgs.writeShellScriptBin "auto_clicker" ''
    ## Syntax: bash
    while :
    do
      ${pkgs.xdotool}/bin/xdotool mousedown $1
      ${pkgs.xdotool}/bin/xdotool mouseup $1
      sleep $2
    done
  '';
  text_from_image = pkgs.writeShellScriptBin "ocr" ''
    TEXT_FILE="/tmp/ocr.txt"
    IMAGE_FILE="/tmp/ocr.png"
    ${pkgs.maim}/bin/maim -s "$IMAGE_FILE"
    STATUS=$?
    [ $STATUS -ne 0 ] && exit 1
    ${pkgs.tesseract}/bin/tesseract "$IMAGE_FILE" "''${TEXT_FILE//\.txt/}"
    LINES=$(wc -l < $TEXT_FILE)
    if [ "$LINES" -eq 0 ]; then
        ${pkgs.libnotify}/bin/notify-send "ocr" "no text was detected"
        exit 1
    fi
    xclip -selection clip < "$TEXT_FILE"
    ${pkgs.libnotify}/bin/notify-send "ocr" "$(cat $TEXT_FILE)"
    rm "$TEXT_FILE"
    rm "$IMAGE_FILE"
  '';
  zerox0 = pkgs.writeShellScriptBin "0x0" ''
    #!/bin/sh
    type=
    ! [ -t 0 ] || file -ibL "$1" | grep -q '^text/' && type=';type=text/plain'

    curl -F file="@''${1:--}$type" 'http://0x0.st' \
        | tee /dev/stderr \
        | xclip -r -sel clip
  '';
  giphsh = pkgs.writeShellScriptBin "giph.sh" ''
    if pgrep "ffmpeg" > /dev/null 2>&1; then
        ${pkgs.giph}/bin/giph --stop
    else
        ${pkgs.giph}/bin/giph -s /tmp/recording.gif && curl -F file=@"/tmp/recording.gif" https://0x0.st | ${pkgs.xclip}/bin/xclip -selection c && ${pkgs.libnotify}/bin/notify-send "Copied to clipboard!"
    fi
  '';
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
  discord-id = pkgs.writeShellScriptBin "discord-id" ''
    [[ "$1" -gt 1111111 ]] || exit 1

    ## age
    # convert to binary, trim useless stuff, and go back to decimal
    j=$(echo "obase=2; $1" | bc | head -c-23)
    j=$(echo "ibase=2; $j" | bc)
    s=''${j%???} ms=''${j#$s}

    # ID + "discord epoch" (2015) -> human readable
    date=$(date -d @$((s+1420070400)) +"%Y-%m-%d %H:%M:%S").$ms

    ## name/pfp/printing
    curl -s \
        -H "Authorization: $DISCORD_TOKEN" \
        -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:86.0) Gecko/20100101 Firefox/86.0" \
        -X GET \
    https://discord.com/api/v9/users/"$1" | jq | tr -d '":,' | while read -r fe va; do
      [[ "$fe" =~ username ]] && user=$va
      [[ "$fe" =~ discrimi ]] && numb=\#$va
      [[ "$fe" =~  avatar  ]] && {
          [[ "$va" = null ]] && continue
          [[ "$va" =~ ^a_ ]] && ext=.gif || ext=.png
          pfp=https://cdn.discordapp.com/avatars/$1/$va$ext\?size=1024
      }
      [[ "$fe" == '}' ]] && printf '%s\n%s\n%s\n' "$user$numb" "$1 / $date" "$pfp"
    done
  '';
  rclip = pkgs.writeShellScriptBin "rclip" ''
    export NO_COLOR=1
    if [[ $(id -u) -eq 0 ]]; then
      prompt="#";
    else
      prompt="$";
    fi

    printf "%s %s\n%s\n" $prompt "$*" "$(bash -c "$*" 2>&1)" | tee /dev/stderr | xclip -selection c
  '';
  command-not-found = pkgs.writeShellScriptBin "command-not-found" ''
    # do not run when inside Midnight Commander or within a Pipe
    if [ -n "''${MC_SID-}" ] || ! [ -t 1 ]; then
    	echo >&2 "$1: command not found"
    	return 127
    fi

    toplevel=nixpkgs # nixpkgs should always be available even in NixOS
    cmd=$1
    attrs=$(nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$cmd")
    len=$(echo -n "$attrs" | grep -c "^")

    case $len in
    0)
    	echo >&2 "$cmd: command not found"
    	;;
    1)
    	if [[ $NIX_AUTO_RUN == 1 ]]; then
            set -x
    		exec nix shell "$toplevel#$(printf ''${attrs} | cut -d "." -f -1)" -c $@
    	fi

    	cat >&2 <<EOF
    The program '$cmd' is currently not installed. The package providing it is:
    $toplevel.$attrs
    EOF
    	;;
    *)
    	cat >&2 <<EOF
    The program '$cmd' is currently not installed. The packages providing it are:
    EOF
    	while read attr; do
    		echo >&2 "  $toplevel.$attr"
    	done <<<"$attrs"
    	;;
    esac

    exit 127 # command not found should always exit with 127

  '';
  store-path = pkgs.writeShellScriptBin "store-path" ''
    echo \"\''${$1}/\" | ${pkgs.fup-repl}/bin/repl | tail -n2 | sed s/\"//g
  '';
  mute = pkgs.writeShellScriptBin "mute" ''
    sources=$(${pkgs.pamixer}/bin/pamixer --list-sources | grep -v monitor | grep -v Sources | cut -d " " -f 1 )

    while IFS= read -r line; do
        case $(${pkgs.pamixer}/bin/pamixer --get-volume-human --source $line) in
            muted)
                ${pkgs.libnotify}/bin/notify-send -t 300 "unmuted"
                ;;
            *)
                ${pkgs.libnotify}/bin/notify-send -t 300 "muted"
                ;;
        esac
    done <<< "$sources"

    echo $sources | xargs -I {} ${pkgs.pamixer}/bin/pamixer --source {} -t
  '';
  lock = pkgs.writeShellScriptBin "lock" ''
    # uses i3lock-color
    C='#ffffff22'
    D='#ff00ffcc'
    T='#ee00eeee'
    B='#00000000'
    V='#bb00bbbb'
    W='#880000bb'

    ${
      lib.getBin pkgs.i3lock-color
    }/bin/i3lock-color --insidevercolor=$C --ringvercolor=$V --insidewrongcolor=$C --ringwrongcolor=$W --insidecolor=$B --ringcolor=$D --linecolor=$B --separatorcolor=$D --verifcolor=$T --wrongcolor=$T --timecolor=$T --datecolor=$T --layoutcolor=$T --keyhlcolor=$W  --bshlcolor=$W  --screen 1  --blur 5  --clock --indicator --timestr="%H:%M:%S" --datestr="%A, %m %Y" --keylayout 2 --veriftext="Why should i even be checking this password? its wrong anyways." --wrongtext="Nice try ;)" --greetertext="u wanna use the computer? good luck finding the password..." --greetercolor=$V
  '';
  yt = pkgs.writeShellScriptBin "yt" ''${pkgs.yt-dlp}/bin/yt-dlp "$@"'';
}
