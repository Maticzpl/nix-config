function addBar(monitor = 0) {
    const myLabel = Widget.Label({
        label: 'some example content',
    })

    Utils.interval(1000, () => {
        myLabel.label = Utils.exec('date')
    })

    return Widget.Window({
        monitor,
        name: `Bar ${monitor}`,
        anchor: ['top', 'left', 'right'],
        exclusivity: "exclusive",
        child: myLabel,
    })
}


App.config({ 
    style: './style.css',
    windows: [
        addBar(0),
        addBar(1),
        addBar(2),
    ]
});
