#ifndef TRAY_H
#define TRAY_H

struct tray_menu;

struct tray {
  char *icon;
  struct tray_menu *menu;
};

struct tray_menu {
  char *text;
  int disabled;
  int checked;

  void (*cb)(struct tray_menu *);
  void *context;

  struct tray_menu *submenu;
};

extern void tray_update(struct tray *tray);
extern int tray_init(struct tray *tray);
extern int tray_loop(int blocking);
extern void tray_update(struct tray *tray);
extern void tray_exit();

#endif /* TRAY_H */
