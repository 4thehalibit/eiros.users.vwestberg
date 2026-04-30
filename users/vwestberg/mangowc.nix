{ config, lib, ... }:
{
  config.eiros.users.vwestberg.mangowc.settings = {
    enable_hotarea = 0;
    ov_tab_mode = 1;
    idleinhibit_ignore_visible = 1;
    edge_scroller_pointer_focus = 0;

    tagrule = [
      "id:1,layout_name:scroller"
    ];

    env = [
      "GTK_THEME,Adwaita:dark"
    ];
  };

  config.eiros.users.vwestberg.mangowc.keybinds = {
    # Override defaults to match Hyprland/Omarchy muscle memory
    close_window              = { modifier_keys = [ "SUPER" ];        flag_modifiers = [ "s" ]; key_symbol = "w";      mangowc_command = "killclient";           command_arguments = null; };
    launch_terminal           = { modifier_keys = [ "SUPER" ];        flag_modifiers = [ "s" ]; key_symbol = "Return"; mangowc_command = "spawn";                command_arguments = "ghostty"; };
    launch_file_browser       = { modifier_keys = [ "SUPER" "SHIFT" ];flag_modifiers = [ "s" ]; key_symbol = "f";      mangowc_command = "spawn";                command_arguments = "ghostty -e yazi"; };
    launch_browser            = { modifier_keys = [ "SUPER" "SHIFT" ];flag_modifiers = [ "s" ]; key_symbol = "Return"; mangowc_command = "spawn";                command_arguments = "vivaldi"; };
    quit_mangowc              = { modifier_keys = [ "SUPER" "CTRL" ]; flag_modifiers = [ "s" ]; key_symbol = "q";      mangowc_command = "quit";                 command_arguments = null; };
    screenshot                = { modifier_keys = [ ];                 flag_modifiers = [ "s" ]; key_symbol = "Print";  mangowc_command = "spawn_shell";          command_arguments = "dms screenshot --no-file"; };
    night_mode                = { modifier_keys = [ "SUPER" "CTRL" ]; flag_modifiers = [ "s" ]; key_symbol = "n";      mangowc_command = "spawn_shell";          command_arguments = "dms ipc call night toggle"; };
    wallpaper_carousel_toggle = { modifier_keys = [ "SUPER" ];        flag_modifiers = [ "s" ]; key_symbol = "b";      mangowc_command = "spawn_shell";          command_arguments = "dms ipc wallpaperCarousel toggle"; };

    # Match Omarchy app shortcuts
    window_fullscreen  = { modifier_keys = [ "SUPER" ];        flag_modifiers = [ "s" ]; key_symbol = "f";    mangowc_command = "togglemaximizescreen"; command_arguments = null; };
    launch_vivaldi     = { modifier_keys = [ "SUPER" "SHIFT" ];flag_modifiers = [ "s" ]; key_symbol = "v";    mangowc_command = "spawn";                command_arguments = "vivaldi"; };
    launch_teams       = { modifier_keys = [ "SUPER" "SHIFT" ];flag_modifiers = [ "s" ]; key_symbol = "t";    mangowc_command = "spawn";                command_arguments = "teams-for-linux"; };
    launch_editor      = { modifier_keys = [ "SUPER" "SHIFT" ];flag_modifiers = [ "s" ]; key_symbol = "n";    mangowc_command = "spawn";                command_arguments = "code"; };
    launch_spotify     = { modifier_keys = [ "SUPER" "SHIFT" ];flag_modifiers = [ "s" ]; key_symbol = "m";    mangowc_command = "spawn";                command_arguments = "spotify"; };
    suspend_system     = { modifier_keys = [ "SUPER" "SHIFT" ];flag_modifiers = [ "s" ]; key_symbol = "s";    mangowc_command = "spawn_shell";          command_arguments = "systemctl suspend"; };
    webapp_chatgpt     = { modifier_keys = [ "SUPER" "SHIFT" ];flag_modifiers = [ "s" ]; key_symbol = "a";    mangowc_command = "spawn";                command_arguments = "vivaldi --app=https://chatgpt.com"; };
    webapp_email       = { modifier_keys = [ "SUPER" "SHIFT" ];flag_modifiers = [ "s" ]; key_symbol = "e";    mangowc_command = "spawn";                command_arguments = "vivaldi --app=https://outlook.office.com"; };
    webapp_youtube     = { modifier_keys = [ "SUPER" "SHIFT" ];flag_modifiers = [ "s" ]; key_symbol = "y";    mangowc_command = "spawn";                command_arguments = "vivaldi --app=https://youtube.com"; };
  };
}
