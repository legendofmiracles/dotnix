{ fetchFromGitHub, lib, python3, appstream-glib, gobject-introspection, pkg-config, wrapGAppsHook, gst_all_1, glib, gtk3, gdk-pixbuf, glib-networking, pango, cairo }:

python3.pkgs.buildPythonApplication rec {
  pname = "discover";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "trigg";
    repo = pname;
    rev = "v${version}";
    sha256 = "09h9cfa6ra5iyslcj5gpd9wmbmz5w3m3raddqbyvncwk6vq6vp0a";
  };

  nativeBuildInputs = [
    appstream-glib
    pkg-config
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = with gst_all_1; [
    gdk-pixbuf
    glib
    glib-networking
    pango
    cairo
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk3
  ];

  propagatedBuildInputs = with python3.pkgs; [ pygobject3 websocket-client requests pillow python-pidfile pyxdg pycairo ];

  strictDeps = false;

  doCheck = false;

  meta = with lib; {
    description = "Yet another discord overlay for linux";
    homepage = "https://github.com/trigg/Discover";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}
