import tray/lowlevel

var tray: tray
tray.icon = "./idea.png"
var menu = tray_menu(
  text: "Menu 1"
)
tray.menu = addr menu

proc main {.inline.} =
  if tray_init(addr tray) < 0:
    quit "failed to create tray"

  while tray_loop(1) == 0:
    echo "iteration"

when isMainModule: main()
