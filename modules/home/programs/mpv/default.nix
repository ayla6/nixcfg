{
  pkgs,
  lib,
  config,
  ...
}: {
  options.myHome.programs.mpv.enable = lib.mkEnableOption "mpv";

  config = lib.mkIf config.myHome.programs.mpv.enable {
    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        uosc
        sponsorblock-minimal
        thumbfast
        eisa01.simplehistory
        eisa01.smart-copy-paste-2
        autoload
      ];
      config = {
        # Video output and rendering
        vo = "gpu-next";
        dither-depth = "auto";

        # Window and display
        osd-bar = false;
        border = false;
        geometry = "50%:50%";
        autofit-larger = "1280x720";
        keep-open = true;
        reset-on-next-file = "video-rotate,video-zoom,panscan";

        # Debanding
        deband = false;
        deband-iterations = 2;
        deband-threshold = 64;
        deband-range = 17;
        deband-grain = 12;

        # Audio and subtitle languages
        alang = "ja,jp,jpn,en,eng";
        slang = "en,eng,pt-br,br,pt";

        # Subtitle settings
        demuxer-mkv-subtitle-preroll = true;
        sub-fix-timing = false;
        sub-auto = "fuzzy";
        sub-scale = 0.5;

        # Screenshot settings
        screenshot-format = "png";
        screenshot-high-bit-depth = false;
        screenshot-png-compression = 3;
        screenshot-directory = "~/Pictures/mpv-screenshots";
        screenshot-template = "%wH.%wM.%wS.%wT-#%#00n";

        # YouTube-dl format
        ytdl-format = "(bv*+ba/b)[vcodec!*=av01][vcodec!*=vp9][height<=?1440]";
      };
      profiles = {
        video = {
          profile-cond = "not get('current-tracks/video/image') and not get('current-tracks/video/albumart')";
          correct-downscaling = true;
          linear-downscaling = false;
          sigmoid-upscaling = true;
        };
        "protocol.http" = {
          hls-bitrate = "max";
          cache = true;
          no-cache-pause = true;
        };
        "protocol.https" = {
          hls-bitrate = "max";
          cache = true;
          no-cache-pause = true;
        };
        "image-hq" = {
          profile-cond = "get('current-tracks/video/image') and width < 10000";
          profile-restore = "copy";
          scale = "spline36";
          cscale = "spline36";
          dscale = "mitchell";
          dither-depth = "auto";
          correct-downscaling = true;
          sigmoid-upscaling = true;
        };
      };

      bindings = {
        # VIDEO
        d = "cycle deband";
        D = "cycle deinterlace";
        n = "cycle video-unscaled";
        C = "cycle-values video-aspect-override \"16:9\" \"4:3\" \"2.35:1\" \"-1\""; # cycle the video aspect ratio ("-1" is the container aspect)

        # increase subtitle font size
        "ALT+e" = "add sub-scale +0.1";

        # decrease subtitle font size
        "ALT+n" = "add sub-scale -0.1";

        m = "cycle ao-mute";

        "Ctrl+q" = "script-binding pickshader";

        # IMAGES
        "SPACE" = "{image} repeatable playlist-next force";
        "]" = "{image} no-osd add playlist-pos 10";
        "[" = "{image} no-osd add playlist-pos -10";

        # pan-image is a wrapper around altering video-align that pans
        # relatively to the window's dimensions instead of the image's.
        # +1 scrolls one screen width/height.
        h = "{image} repeatable script-message pan-image x -.33";
        j = "{image} repeatable script-message pan-image y +.33";
        k = "{image} repeatable script-message pan-image y -.33";
        l = "{image} repeatable script-message pan-image x +.33";
        LEFT = "{image} repeatable script-message pan-image x -.33";
        DOWN = "{image} repeatable script-message pan-image y +.33";
        UP = "{image} repeatable script-message pan-image y -.33";
        RIGHT = "{image} repeatable script-message pan-image x +.33";
        H = "{image} repeatable script-message pan-image x -.033";
        J = "{image} repeatable script-message pan-image y +.033";
        K = "{image} repeatable script-message pan-image y -.033";
        L = "{image} repeatable script-message pan-image x +.033";
        "Shift+LEFT" = "{image} repeatable script-message pan-image x -.033";
        "Shift+DOWN" = "{image} repeatable script-message pan-image y +.033";
        "Shift+UP" = "{image} repeatable script-message pan-image y -.033";
        "Shift+RIGHT" = "{image} repeatable script-message pan-image x +.033";
        "Ctrl+h" = "{image} no-osd set video-align-x -1";
        "Ctrl+j" = "{image} no-osd set video-align-y 1";
        "Ctrl+k" = "{image} no-osd set video-align-y -1";
        "Ctrl+l" = "{image} no-osd set video-align-x 1";
        "Ctrl+LEFT" = "{image} no-osd set video-align-x -1";
        "Ctrl+DOWN" = "{image} no-osd set video-align-y 1";
        "Ctrl+UP" = "{image} no-osd set video-align-y -1";
        "Ctrl+RIGHT" = "{image} no-osd set video-align-x 1";

        "9" = "{image} add video-zoom +.25"; # easier to reach than =
        "-" = "{image} add video-zoom -.25";
        "(" = "{image} add video-zoom +.05";
        "_" = "{image} add video-zoom -.05";
        "0" = "{image} no-osd set video-zoom 0; no-osd set panscan 0";

        # Toggle scaling the image to the window.
        u = "{image} no-osd cycle-values video-unscaled yes no; no-osd set video-zoom 0; no-osd set panscan 0";
        # cycle video-unscaled will also cycle through downscale-big.
        # autofit=100%x100% makes the window bigger than necessary with downscale-big
        # though so you may want to replace it with autofit-larger=100%x100%

        # panscan crops scaled videos with different aspect ratio than the window.
        # At 1 it fills black bars completely.
        o = "{image} no-osd set panscan 1; no-osd set video-unscaled no; no-osd set video-zoom 0";

        # Toggle slideshow mode.
        s = "{image} cycle-values image-display-duration 5 inf; no-osd set video-zoom 0; no-osd set panscan 0; no-osd set video-unscaled no";

        # Compare the image quality with and without profile=gpu-hq.
        "Ctrl+a" = "{image} apply-profile image-hq restore";
        a = "{image} apply-profile image-hq";

        # This mouse gesture executes one of 5 commands configured in
        # script-opts/image_bindings.conf depending on the direction you drag the
        # mouse. To use it without an input section you need window-dragging=no in
        # mpv.conf.
        MBTN_LEFT = "{image} script-binding gesture";
        MBTN_LEFT_DBL = "{image} ignore";
        MBTN_MID = "{image} script-binding align-to-cursor";
        MBTN_RIGHT = "{image} script-binding drag-to-pan";
        WHEEL_UP = "{image} script-message cursor-centric-zoom .1";
        WHEEL_DOWN = "{image} script-message cursor-centric-zoom -.1";

        GAMEPAD_DPAD_RIGHT = "seek +5";
        GAMEPAD_DPAD_LEFT = "seek -5";

        GAMEPAD_RIGHT_TRIGGER = "add chapter 1";
        GAMEPAD_LEFT_TRIGGER = "add chapter -1";

        GAMEPAD_ACTION_DOWN = "cycle pause";

        GAMEPAD_LEFT_SHOULDER = "cycle sub";
        GAMEPAD_RIGHT_SHOULDER = "cycle audio";
      };
      scriptOpts = {
        "SimpleHistory" = {
          open_list_keybind = "[[h,all],[H,all],[r,recents],[R,recents],[GAMEPAD_BACK,all]]";
          same_entry_limit = 0;
          list_move_up_keybind = "[UP,WHEEL_UP,GAMEPAD_DPAD_UP]";
          list_move_down_keybind = "[DOWN,WHEEL_DOWN,GAMEPAD_DPAD_DOWN]";
          list_page_up_keybind = "[PGUP,GAMEPAD_LEFT_TRIGGER]";
          list_page_down_keybind = "[PGDWN,GAMEPAD_RIGHT_TRIGGER]";
          list_select_keybind = "[ENTER,MBTN_MID,GAMEPAD_ACTION_DOWN]";
          list_add_playlist_keybind = "[CTRL+ENTER,GAMEPAD_ACTION_RIGHT]";
          list_close_keybind = "[ESC,MBTN_RIGHT,GAMEPAD_BACK]";
        };
        "thumbfast" = {
          max_height = 250;
          max_width = 250;
          spawn_first = "yes";
          network = "yes";
          hwdec = "yes";
        };
        "uosc" = {
        };
      };
    };
  };
}
