{config}: let
  inherit (config.myHome.profiles) colours;
in {
  layout = {
    gaps = 8;
    preset-column-widths = [
      {proportion = 1.0 / 3.0;}
      {proportion = 1.0 / 2.0;}
      {proportion = 2.0 / 3.0;}
    ];
    default-column-width = {proportion = 0.5;};
    focus-ring = {
      width = 2;
      active = {color = colours.accent;};
      inactive = {color = colours.grey;};
    };
  };
}
