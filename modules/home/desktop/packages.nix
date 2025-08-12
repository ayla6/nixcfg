{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.myHome.desktop.enable {
    home.packages = with pkgs; [
      wl-clipboard
      libnotify

      # --- Development ---
      gcc
      nodejs
      pnpm
      typescript
      ffmpeg-full
      luajit
      love

      # --- Applications ---
      keepassxc
      libsecret
      qbittorrent
      flare-signal
      kdePackages.kdenlive
      krita
      gimp3
      yt-dlp
      aseprite
      inkscape
      jellyfin-media-player
      calibre
      picard
      freac
      audacious
      audacious-plugins
      lmms

      # --- Gaming ---
      wine
      steam-run
      lutris
      mgba
      melonDS
      openttd
      prismlauncher
      mindustry
    ];
  };
}
