import tray

proc main =
  var tray = newTrayIcon("idea.png")
  tray &=
    trayMenu(
      "Performance (AC)",
      proc(_: TrayMenu) = echo "performance mode"
    )

  tray &= separator()

  tray &=
    trayMenu(
      "Power Saving (BAT)",
      proc(_: TrayMenu) = echo "power saving mode"
    )

  tray.run()
  
  while tray.update():
    discard

  echo "Quitting"

when isMainModule:
  main()
