{
  window-rules = [
    {
      matches = {
        app-id = "firefox$";
        title = "^Picture-in-Picture$";
      };
      open-floating = true;
    }
    {
      matches = {
        app-id = "chrome$";
        title = "^Picture-in-picture$";
      };
      open-floating = true;
    }
  ];
}
