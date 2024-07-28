## Low-level bindings over zserge/tray
##
## Author: Trayambak Rai (xtrayambak at disroot dot org)
when defined(windows):
  {.passC: "-DTRAY_WINAPI".}
elif defined(linux):
  import std/strutils

  # link against GTK 3
  {.passL: strip(gorge("pkg-config --libs gtk+-3.0")).}
  {.passC: strip(gorge("pkg-config --cflags gtk+-3.0")).}
  
  # link against libappindicator
  {.passL: strip(gorge("pkg-config --libs appindicator3-0.1")).}
  {.passC: strip(gorge("pkg-config --cflags appindicator3-0.1")).}

  {.passC: "-DTRAY_APPINDICATOR".}
elif defined(macos):
  {.passC: "-DTRAY_APPKIT".}
else:
  {.error: "Unsupported platform! This library only supports Windows, MacOS and Linux!".}

{.compile: "tray.c".}

type
  tray_menu* {.bycopy.} = object
    text*: cstring
    disabled*, checked*: cint

    cb*: proc(menu: ptr tray_menu) {.cdecl.}
    context*: pointer

    submenu*: ptr UncheckedArray[tray_menu]

  tray* {.bycopy.} = object
    icon*: cstring
    menu*: ptr UncheckedArray[tray_menu]

{.push cdecl.}
proc tray_update*(tray: ptr tray) {.importc: "tray_update".}
proc tray_init*(tray: ptr tray): cint {.importc: "tray_init".}
proc tray_loop*(blocking: cint): cint {.importc: "tray_loop".}
proc tray_exit*(tray: ptr tray) {.importc: "tray_exit".}
{.pop.}
