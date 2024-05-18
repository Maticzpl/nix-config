{ lib, config, pkgs, ... }:

let
    cfg = config.userMods.audio;
in

{
    options.userMods.audio = {
        enable = lib.mkEnableOption "enable user module";
        calfConfig = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "Path to file with calf config";
        };
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = [
            pkgs.calf
            pkgs.qpwgraph
        ];

        # services.pipewire.configPackages = [
        #     (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-precalf-sink.conf" ''
        #      context.modules = [
        #      {   
        #          name = libpipewire-module-loopback
        #          args = {
        #              audio.position = [ FL FR ]
        #              capture.props = {
        #                 media.class = Audio/Sink
        #                 node.name = calf_sink
        #                 node.description = "Precalf sink"
        #              }
        #              playback.props = {
        #                 node.name = "calf_sink.output"
        #                 node.passive = true
        #              }
        #          }
        #      }
        #      ]
        #       '')
        # ];

        services.pipewire.extraConfig.pipewire-pulse = {
            "precalf" = {
                "pulse.cmd" = [
                    {
                        cmd = "load-module";
                        args = "module-null-sink media.class=Audio/Sink sink_name=precalf channel_map=stereo";
                        flags = [];
                    }
                ];
            };
        };

        systemd.user.services.calfjackhost = {
            enable = true;
            description = "Calf Studio Gear - JACK Audio Host";
            after = ["jack.service"];
            wantedBy = ["default.target"];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.calf}/bin/calfjackhost --load \"${cfg.calfConfig}\"";
                Restart = "always"; 
                RestartSec = "5"; 
            };
        };

        systemd.user.services.qpwgraph = {
            enable = true;
            description = "Patchbay - qpwgraph";
            after = ["calfjackhost.service"];
            wantedBy = ["default.target"];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.qpwgraph}/bin/qpwgraph";
                Restart = "always"; 
                RestartSec = "5"; 
            };
        };
    };
}
