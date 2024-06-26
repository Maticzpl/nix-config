const hyprland = await Service.import("hyprland")
const notifications = await Service.import("notifications")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")

function addBar(monitor = 0, alwaysVisible = false) {
    // Sysetm tray
    const trayItems = systemtray.bind("items")
    .as(items => items.map(item => Widget.Button({
        child: Widget.Icon({ icon: item.bind("icon"), size: 22 }),
        on_primary_click: (_, event) => item.activate(event),
        on_secondary_click: (_, event) => item.openMenu(event),
        tooltip_markup: item.bind("tooltip_markup"),
    })))

    const tray = Widget.Box({
        class_name: "tray",
        children: trayItems
    })
    // v Workspaces | System Tray ^
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
        return buttons;
    });

    const workspaceBox = Widget.Box({
        class_name: "workspaces",
        spacing: 3,
        children: workspaces,
    });

    // ^ Workspaces | Time v

    const timeLabel = Widget.Label({
        label: 'tell me the time man',
        class_name: "time"
    })
    const dateLabel = Widget.Label({
        label: 'tell me the date man',
        class_name: "date"
    })
    // const calendar = Widget.Calendar({
    //     showDayNames: true,
    //     showDetails: true,
    //     showHeading: true,
    //     showWeekNumbers: true,
    //     // detail: (self, y, m, d) => {
    //     //     return `<span color="white">${y}. ${m}. ${d}.</span>`
    //     // },
    // })
    const timeDateBox = Widget.Box({
        // vertical: true,
        spacing: 5,
        children: [timeLabel, dateLabel],
        class_name: "timedate",
    });

    Utils.interval(1000, () => {
        dateLabel.label = Utils.exec('date +"%Y-%m-%d"');
        timeLabel.label = Utils.exec('date +"%H:%M:%S"');
    })

    // Time ^

    const left = Widget.Box({
        vertical: false,
        spacing: 8,
        children: [
            workspaceBox
        ]
    });
    const center = Widget.Box({
        vertical: false,
        spacing: 8,
        children: [
            timeDateBox
        ]
    });
    const right = Widget.Box({
        vertical: false,
        hpack: "end",
        spacing: 8,
        children: [
            tray
        ]
    });

    return Widget.Window({
        monitor,
        name: `Bar ${monitor}`,
        className: "bar-window",
        anchor: ['top', 'left', 'right'],
        exclusivity: "exclusive",
        visible: hyprland.active.monitor.bind("id").as(id => id == monitor || alwaysVisible),
        child: Widget.CenterBox({
            className: "bar",
            start_widget: left,
            center_widget: center,
            end_widget: right
        }),
    })
}


App.config({ 
    style: './style.css',
    windows: [
        addBar(0),
        addBar(1, true),
        addBar(2),
    ]
});
