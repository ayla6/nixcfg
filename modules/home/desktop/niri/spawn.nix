{
  lib,
  config,
}: {
  spawn-at-startup =
    [
      {argv = ["waybar"];}
      {argv = ["swaybg" "--image" "~/.config/background"];}
    ]
    ++ (
      if config.programs.foot.enable
      then [
        {
          argv = [(lib.getExe config.programs.foot.package) "--server"];
        }
      ]
      else []
    );
}
