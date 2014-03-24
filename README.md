jupiter
=======

A linux applet which helps with powersaving, device- and display-management and comes with an AppIndicator.

Special features:

- Uses xrandr C-Library to change monitor/display settings. No bash-parsing of xrandr output used anymore, more efficient.

- Saves monitor settings based on monitors connected. NO saves just by connection (HDMI, VGA, LVDS etc.) BUT monitor edid data (monitor identifier), allowing huge flexibility for laptops especially.

- Clone modus sets both monitors to maximum shared resolution, avoiding cut off of one of these monitors.

- For xfce users: Easily set panel to the monitor you want it to be selecting the primary monitor with jupiter (not supported by xfce when doing xrandr --primary).
