{ lib, config, pkgs, inputs, ... }:

let
    cfg = config.userMods.hyprland;
in

{
    options.userMods.hyprland = {
        enable = lib.mkEnableOption "enable user module";
        username = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "User for which to set the config.fish file";
        };
    };

    config = lib.mkIf cfg.enable {
        programs.hyprland.enable = true;

        security.polkit.enable = true;

        environment.variables = {
            GTK_THEME = "Breeze-Dark";
            QT_STYLE_OVERRIDE = "breeze";
            GTK_ICON_THEME = "Papirus-Dark";
        };

        services.xremap = {
            withWlroots = true;
        };

        services.xremap.yamlConfig = ''
        keymap:
          - name: Hyprland nav
            remap:
              SUPER-SPACE: { set_mode: super }
            mode: default

          - name: Hyprland super nav
            remap:
              Esc: { set_mode: default }
              SUPER-SPACE: { set_mode: default }

              H: SUPER-H 
              J: SUPER-J 
              K: SUPER-K 
              L: SUPER-L 

              P: SUPER-CONTROL-H
              N: SUPER-CONTROL-L

              F: SUPER-F
              T: SUPER-T
              E: SUPER-E
              R: SUPER-R

              KEY_W:
                remap:
                  H: SUPER-SHIFT-H 
                  J: SUPER-SHIFT-J 
                  K: SUPER-SHIFT-K 
                  L: SUPER-SHIFT-L 

                  F: SUPER-SHIFT-F
                  C: SUPER-SHIFT-C
                  G: SUPER-SHIFT-G
                  S: SUPER-SHIFT-S


            mode: super

        default_mode: default

        '';

        home-manager.users."${cfg.username}" = {
            imports = [
                inputs.hyprland.homeManagerModules.default
            ];

            home.packages = with pkgs; [
                waybar
                wofi
                pavucontrol

                dunst
                # swayosd
                anyrun
                swww
                # hyprlock
                hyprpaper
                waypaper
                hyprland-workspaces
                xdg-desktop-portal-hyprland
                nwg-look
                playerctl
            ];

            wayland.windowManager.hyprland = {
              enable = true;
              # xwayland.enable = true;
              systemd.enable = true;

              settings = {
                 "$mod" = "SUPER";
                 "$terminal" = "konsole";
                 "$fileManager" = "dolphin";
                 "$menu" = "anyrun";#"wofi --show drun";

                 monitor = [ 
                    "DP-2,1920x1080,0x0,1"
                    "DP-1,1280x800,400x1080,1"
                 ];

                 exec-once = [ 
                    "waybar&"
                    "dunst&"
                    "swayosd&"
                    "swww&"
                 ];

                 env = [
                    "XCURSOR_SIZE,24"
                    "HYPRCURSOR_SIZE,24"
                 ];

                 general = {
                    gaps_in = 5;
                    gaps_out = 20;

                    border_size = 2;

                    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                    "col.inactive_border" = "rgba(595959aa)";

                    resize_on_border = false;

                    allow_tearing = false;

                    layout = "dwindle";
                 };

                 decoration = {
                    rounding = 10;

                    active_opacity = 1.0;
                    inactive_opacity = 1.0;

                    drop_shadow = true;
                    shadow_range = 4;
                    shadow_render_power = 3;
                    "col.shadow" = "rgba(1a1a1aee)";

                    blur = {
                      enabled = true;
                      size = 3;
                      passes = 1;

                      vibrancy = 0.1696;
                    };
                 };

                 animations = {

                 };

                 dwindle = {
                    pseudotile = true;
                    preserve_split = true;
                 };

                 master = {
                    new_is_master = true;
                 };

                 input = {
                    kb_layout = "pl";

                    follow_mouse = 1;

                    sensitivity = 0;
                 };

                 bind = [
                   "$mod, F, exec, firefox"
				   "$mod, T, exec, $terminal"
				   "$mod, E, exec, $fileManager"

				   "$mod, R, exec, $menu"
				   "$mod, P, pseudo, # dwindle"
				   "$mod, Escape, exit"

				   "$mod, H, movefocus, l"
				   "$mod, L, movefocus, r"
				   "$mod, K, movefocus, u"
				   "$mod, J, movefocus, d"

				   "$mod SHIFT, F, togglefloating,"
				   "$mod SHIFT, C, killactive,"
				   "$mod SHIFT, G, togglegroup,"
				   "$mod SHIFT, S, togglesplit,"

				   "$mod SHIFT, H, movewindow, l"
				   "$mod SHIFT, L, movewindow, r"
				   "$mod SHIFT, K, movewindow, u"
				   "$mod SHIFT, J, movewindow, d"

				   "$mod Control_L, H, changegroupactive, b"
				   "$mod Control_L, L, changegroupactive, f"

                    # Switch workspaces with mainMod + [0-9]
				   "$mod, 1, workspace, 1"
				   "$mod, 2, workspace, 2"
				   "$mod, 3, workspace, 3"
				   "$mod, 4, workspace, 4"
				   "$mod, 5, workspace, 5"
				   "$mod, 6, workspace, 6"
				   "$mod, 7, workspace, 7"
				   "$mod, 8, workspace, 8"
				   "$mod, 9, workspace, 9"
				   "$mod, 0, workspace, 10"

                    # Move active window to a workspace with mainMod + SHIFT + [0-9]
				   "$mod SHIFT, 1, movetoworkspace, 1"
				   "$mod SHIFT, 2, movetoworkspace, 2"
				   "$mod SHIFT, 3, movetoworkspace, 3"
				   "$mod SHIFT, 4, movetoworkspace, 4"
				   "$mod SHIFT, 5, movetoworkspace, 5"
				   "$mod SHIFT, 6, movetoworkspace, 6"
				   "$mod SHIFT, 7, movetoworkspace, 7"
				   "$mod SHIFT, 8, movetoworkspace, 8"
				   "$mod SHIFT, 9, movetoworkspace, 9"
				   "$mod SHIFT, 0, movetoworkspace, 10"


                    # Example special workspace (scratchpad)
				   # "$mod, S, togglespecialworkspace, magic"
				   # "$mod SHIFT, S, movetoworkspace, special:magic"

                    # Scroll through existing workspaces with mainMod + scroll
				   "$mod, mouse_down, workspace, e+1"
				   "$mod, mouse_up, workspace, e-1"
                 ];
                 bindm = [
                    "$mod, mouse:272, movewindow"
                    "$mod, mouse:273, resizewindow"
                 ];
                 bindel = [
                    ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                 ];
                 bindl = [
                    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                    ",XF86AudioPlay, exec, playerctl -a play-pause" # uh firefox with nothning playing takes priority before spotify
                    ",XF86AudioNext, exec, playerctl next"
                    ",XF86AudioPrev, exec, playerctl previous"
                 ];

                 windowrulev2 = "suppressevent maximize, class:.*";
               };
              plugins = [
                  #inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
              ];
            };

            # home.file."~/.config/anyrun/config.ron".text = ''
            #   Config(
            #   x: Fraction(0.5),
            #   y: Absolute(0),
            #   width: Absolute(800),
            #   height: Absolute(0),
            #   hide_icons: false, 
            #   ignore_exclusive_zones: false, 
            #   layer: Overlay, 
            #   hide_plugin_info: false, 
            #   close_on_click: true,
            #   show_results_immediately: false,
            #   max_entries: None,
            #   plugins: [
            #     "libapplications.so",
            #     "libsymbols.so",
            #     "libshell.so",
            #     "libtranslate.so",
            #   ],
            # )
            # '';
        };

    };
}
