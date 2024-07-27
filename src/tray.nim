## High level wrapper over zserge/tray
##
## Author: Trayambak Rai (xtrayambak at disroot dot org)
import tray/lowlevel

type
  TrayIcon* = object
    tray*: tray

  TrayMenu* = object
    menu*: tray_menu

proc runTrayIcon*(icon: TrayIcon) =
  init_tray(icon.tray.addr)

proc newTrayIcon*(icon: string): TrayIcon =
  TrayIcon(
    tray: tray(icon: cstring icon)
  )
