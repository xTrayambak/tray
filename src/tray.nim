## High level wrapper over zserge/tray
##
## Author: Trayambak Rai (xtrayambak at disroot dot org)
import tray/lowlevel
import pretty

type
  TrayInitializationError* = object of Defect

  TrayIcon* = object
    icon*: string
    lltray*: tray
    menus*: seq[TrayMenu]

  TrayMenu* = object
    text*: string

    llmenu*: tray_menu
    submenus*: seq[TrayMenu]
    callback*: proc(menu: TrayMenu) 

var gMenu: TrayMenu

proc createMenu(icon: var TrayIcon, menu: TrayMenu): tray_menu =
  var menu = menu
  gMenu = menu
  
  menu.llmenu.cb = proc(_: ptr tray_menu) {.inline, cdecl.} =
    gMenu.callback(gMenu)

  menu.llmenu = tray_menu(text: menu.text.cstring) # allocate low level `tray_menu` struct
  menu.llmenu.submenu = cast[ptr UncheckedArray[tray_menu]](
    alloc(
      sizeof(tray_menu) * menu.submenus.len
    )
  )
    
  for i, _ in menu.submenus:
    var child = menu.submenus[i]
    child.llmenu.cb = proc(_: ptr tray_menu) {.inline, cdecl.} =
      gMenu.callback(gMenu)

    menu.llmenu.submenu[][i] = icon.createMenu(child)
  
  menu.llmenu

proc run*(icon: var TrayIcon) =
  icon.lltray.icon = cstring(icon.icon)
  icon.lltray.menu = cast[ptr UncheckedArray[tray_menu]](
    alloc(
      sizeof(tray_menu) * icon.menus.len
    )
  )

  for i, _ in icon.menus:
    var menu = icon.menus[i]
    icon.lltray.menu[][i] = icon.createMenu(menu)
    
  if tray_init(icon.lltray.addr) < 0:
    raise newException(TrayInitializationError, "Could not initialize system tray icon!")

{.push checks: off, inline.}
proc update*(icon: TrayIcon): bool =
  not bool tray_loop(1)

proc `&=`*(icon: var TrayIcon, menu: TrayMenu) =
  icon.menus &=
    menu

proc `&=`*(menu: var TrayMenu, submenu: TrayMenu) =
  menu.submenus &=
    submenu

proc trayMenu*(text: string, callback: proc(menu: TrayMenu)): TrayMenu =
  TrayMenu(
    text: text,
    callback: callback
  )

proc separator*: TrayMenu =
  TrayMenu(text: "-")

proc newTrayIcon*(icon: string): TrayIcon =
  TrayIcon(
    lltray: tray(icon: icon),
    icon: icon
  )

{.pop.}
