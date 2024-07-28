import tray/lowlevel

var tray: tray
tray.icon = "./idea.png"
var root = tray_menu(text: "Menu 1")
var menu = cast[ptr UncheckedArray[tray_menu]](alloc(sizeof(tray_menu) * 4))

menu[][0] = tray_menu(
  text: "Menu 2"
)
menu[][1] = tray_menu(
  text: "Menu 3"
)
menu[][2] = tray_menu(
  text: "Menu 4"
)
menu[][3] = tray_menu(
  text: "Menu 5"
)
root.submenu = menu

tray.menu = menu

proc main {.inline.} =
  if tray_init(addr tray) < 0:
    quit "failed to create tray"

  while tray_loop(1) == 0:
    echo "iteration"

when isMainModule: main()
