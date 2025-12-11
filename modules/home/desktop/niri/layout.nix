{config}: let
  colours = config.myHome.profiles.colours;
in {
  layout = {
    gaps = 8;
    preset-column-widths = [
      {proportion = 1. / 3.;}
      {proportion = 1. / 2.;}
      {proportion = 2. / 3.;}
    ];
    default-column-width = {proportion = 0.5;};
    focus-ring = {
      width = 2;
      active = {color = colours.accent;};
      inactive = {color = colours.grey;};
    };
  };
}
