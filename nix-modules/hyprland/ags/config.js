const hyprland = await Service.import("hyprland")
const notifications = await Service.import("notifications")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")

function addBar(monitor = 0, alwaysVisible = false) {
    
    function BatteryLabel() {
        const value = battery.bind("percent").as(p => p > 0 ? p / 100 : 0)
        const icon = battery.bind("percent").as(p =>
            `battery-level-${Math.floor(p / 10) * 10}-symbolic`)

        const tooltip = Utils.merge(
            [
                battery.bind("percent"),
                battery.bind("time-remaining"),
                battery.bind("charging"),
                battery.bind("energy-rate")
            ], (a, b, c, d) => {
            let unit = "s";
            let time = b;
            if (time > 60) {
                time /= 60;
                unit = "m";
            }
            if (time > 60) {
                time /= 60;
                unit = "h";
            }
            
            b = `${time}${unit}`;

            console.log(a,b,c,d)
            const charging = c ? `Charging, ` : "";
            return `${a}%\n${charging}${b} remaining\n${d}W`;
        })

        return Widget.Box({
            class_name: "battery",
            visible: battery.bind("available"),
            tooltip_text: tooltip,
            children: [
                Widget.Icon({ icon }),
                Widget.LevelBar({
                    widthRequest: 100,
                    vpack: "center",
                    value,
                }),
            ],
        })
    }

    function SystemTray() {
        const trayItems = systemtray.bind("items")
        .as(items => items.map(item => Widget.Button({
            child: Widget.Icon({ icon: item.bind("icon"), size: 22 }),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            tooltip_markup: item.bind("tooltip_markup"),
        })))

        return Widget.Box({
            class_name: "tray",
            children: trayItems,
            visible: systemtray.bind("items").as(items => items.length != 0)
        })
    }

    function Workspaces() {
        // let workspaceCount = Variable(0);

        const activeId = hyprland.active.workspace.bind("id")
        const workspaces = hyprland.bind("workspaces").as(ws => {
            let buttons = [];

            let id = 1;
            for (const workspace of ws.sort((a, b) => a.id - b.id)) {
                if (workspace.monitorID == monitor && (!workspace.name.startsWith("special"))) {
                    buttons.push(Widget.Button({
                        on_clicked: () => hyprland.messageAsync(`dispatch workspace ${workspace.id}`),
                        child: Widget.Label(`${id++}`),
                        class_name: activeId.as(i => `${i === workspace.id ? "focused" : ""}`),
                    }));
                }
            }
            // workspaceCount.value = buttons.length;
            return buttons;
        });

        return Widget.Box({
            class_name: "workspaces",
            spacing: 3,
            children: workspaces,
            // visible: workspaceCount.bind().as(c => c > 1)
        });
    }


    const showCalendar = Variable(false);

    const calendar = Widget.Calendar({
        class_name: "popup-calendar",
        showDayNames: true,
        showDetails: true,
        showHeading: true,
        showWeekNumbers: true
        // detail: (self, y, m, d) => {
        //     return `<span color="white">${y}. ${m}. ${d}.</span>`
        // },
    });

    function TimeAndDate() {
        const timeLabel = Widget.Label({
            label: 'tell me the time man',
            class_name: "time"
        })
        const dateLabel = Widget.Label({
            label: 'tell me the date man',
            class_name: "date"
        })
        Utils.interval(1000, () => {
            dateLabel.label = Utils.exec('date +"%Y-%m-%d"');
            timeLabel.label = Utils.exec('date +"%H:%M:%S"');
        })

        return Widget.Button({
            on_clicked: () => { showCalendar.value = !showCalendar.value; },
            child: Widget.Box({
                spacing: 5,
                children: [timeLabel, dateLabel],
                class_name: "timedate",
            }),
            class_name: "timedate-button",
        });
    }


    function Volume() {
        const icons = {
            101: "overamplified",
            67: "high",
            34: "medium",
            1: "low",
            0: "muted",
        }

        function getIcon() {
            const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
                threshold => threshold <= audio.speaker.volume * 100)

            return `audio-volume-${icons[icon]}-symbolic`
        }

        const icon = Widget.Icon({
            icon: Utils.watch(getIcon(), audio.speaker, getIcon),
        })

        const slider = Widget.Slider({
            hexpand: true,
            draw_value: false,
            on_change: ({ value }) => audio.speaker.volume = value * 1.4,
            setup: self => self.hook(audio.speaker, () => {
                self.value = (audio.speaker.volume / 1.4) || 0
            }),
        })

        return Widget.Box({
            class_name: "volume",
            css: "min-width: 100px",
            children: [icon, slider],
        })
    }

    const left = Widget.Box({
        vertical: false,
        spacing: 8,
        children: [
            Workspaces(),
            BatteryLabel()
        ]
    });
    const center = Widget.Box({
        vertical: false,
        spacing: 8,
        children: [
            TimeAndDate()
        ]
    });
    const right = Widget.Box({
        vertical: false,
        hpack: "end",
        spacing: 8,
        children: [
            Volume(),
            SystemTray()
        ]
    });

    return [
        Widget.Window({
            monitor,
            name: `Bar ${monitor}`,
            className: "bar-window",
            anchor: ['top', 'left', 'right'],
            exclusivity: "exclusive",
            layer: "bottom",
            visible: hyprland.active.monitor.bind("id").as(id => id == monitor || alwaysVisible),
            child: Widget.CenterBox({
                className: "bar",
                start_widget: left,
                center_widget: center,
                end_widget: right
            }),
        }),

        Widget.Window({
            monitor,
            name: `Bar Popups Calendar ${monitor}`,
            className: "bar-popup-calendar",
            anchor: ['top', 'left', 'right'],
            margins: [10, 0, 0, 0],
            layer: "overlay",
            visible: showCalendar.bind(),
            child: Widget.Box({
                hpack: "center",
                children: [calendar]
            }),
        })
    ]
}


App.config({ 
    style: './style.css',
    windows: [
        ...addBar(0, true),
        // ...addBar(1, true),
        // ...addBar(2),
    ]
});
