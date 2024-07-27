with import <nixpkgs> { };

mkShell {
  nativeBuildInputs = [
    gtk3
    libappindicator
    pkg-config
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    gtk3
    libappindicator
  ];
}
