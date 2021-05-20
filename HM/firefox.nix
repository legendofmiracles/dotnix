{ pkgs, config, ... }:

let font = "Cascadia Mono PL";
in {
  programs.firefox = {
    enable = true;
    profiles = {
      legend = {
        isDefault = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # doesn't work anymore
          # "browser.search.defaultenginename" = "DuckDuckGo";
          "font.name.monospace.x-western" = font;
          "font.name.sans-serif.x-western" = font;
          "font.name.serif.x-western" = font;
        };
        userChrome = ''
              // pdf reader
              #viewerContainer > #viewer > .page > .canvasWrapper > canvas {
                 filter: grayscale(100%);
                 filter: invert(100%);
              }


              /*================== Simplify Darkish Purple for Firefox ==================
              Author: dpcdpc11.gumroad.com
              ENJOY!
              */

              /*================ GLOBAL COLORS ================*/
              :root {
                --accent-color: 54, 54, 54;
                --secondary-accent-color: 255, 33, 124;
                --third-accent-color: 255, 33, 142;
                --light-color: 255, 255, 255;
                --dark-color: 24, 26, 27;
                --caption-min-color: 255, 133, 94;
                --caption-max-color: 255, 100, 159;
                --caption-close-color: 153, 132, 255;
              }

              /*================ DARK THEME ================*/
              :root:-moz-lwtheme-brighttext,
              .sidebar-panel[lwt-sidebar-brighttext],
              body[lwt-sidebar-brighttext] {
                --main-bgcolor: var(--dark-color);
                --transparent-bgcolor: var(--accent-color);
              }


              /*================== MAIN HEADER ==================*/
              toolbox#navigator-toolbox  {
                border: 0 !important;
              }

              /*================== TABS BAR ==================*/
              #titlebar #TabsToolbar {
                padding: 6px 0px 2px 6px !important;
                background: rgba(var(--dark-color), 1) !important;
              }
              .titlebar-spacer[type="pre-tabs"] {
                /* border: 0 !important; */
                display: none;
              }

              #tabbrowser-tabs:not([movingtab]) > .tabbrowser-tab[beforeselected-visible]::after, #tabbrowser-tabs[movingtab] > .tabbrowser-tab[visuallyselected]::before, .tabbrowser-tab[visuallyselected]::after {
                  opacity: 0 !important;
              }
              .tab-line {
                  height: 0px !important;
              }

              .tabbrowser-tab {
                  margin-right: 5px !important;
              }
              .tabbrowser-tab:not([visuallyselected="true"]), .tabbrowser-tab:-moz-lwtheme {
                  color: rgba(var(--secondary-accent-color), 1) !important;
              }

              tab[selected="true"] .tab-content {
                color: rgba(var(--secondary-accent-color), 1) !important;
              }
              tab[selected="true"] .tab-background {
                background: rgba(var(--accent-color), 1) !important;
              }

              .tabbrowser-tab::after, .tabbrowser-tab::before {
                  border-left: 0 !important;
                  opacity: 0 !important;
              }

              .tab-close-button {
                transition: all 0.3s ease !important;
                  border-radius: 4px !important;
              }
              .tab-close-button:hover {
                  fill-opacity: 0.2 !important;
              }

              .tabbrowser-tab > .tab-stack > .tab-background {
                border-radius: 4px !important;
              }
              .tabbrowser-tab > .tab-stack > .tab-background:not([selected="true"]) {
                transition: all 0.3s ease !important;
              }
              .tabbrowser-tab:hover > .tab-stack > .tab-background:not([selected="true"]) {
                  background-color: rgba(var(--transparent-bgcolor), 0.7) !important;
              }


              /*================== BOOKMARKS TOOLBAR ==================*/
              #PersonalToolbar {
                background: rgba(var(--dark-color), 1) !important;
                color: rgba(var(--secondary-accent-color), 1) !important;
                padding-bottom: 6px !important;
                padding-top: 1px !important;
              }
              toolbarbutton.bookmark-item {
                transition: all 0.3s ease !important;
                  padding: 3px 5px !important;
                border-radius:4px !important;
              }
              toolbarbutton.bookmark-item .toolbarbutton-icon {
                fill: rgba(var(--secondary-accent-color), 1) !important;
              }
              #PlacesToolbar toolbarseparator {
                -moz-appearance: none !important;
                width: 1px;
                margin: 0 8px !important;
                background-color: rgba(var(--secondary-accent-color), 0.5) !important;
              }


              /*================== CAPTION BUTTONS ==================*/
              .titlebar-buttonbox {
                  position: relative;
                  margin-right: 0px;
                margin-top: -10px !important;
              }
              .titlebar-button {
                transition: all 0.3s ease !important;
                padding: 8px 10px !important;
                  background: rgba(var(--dark-color), 1) !important;
              }
              .titlebar-button.titlebar-close {
                padding-right: 26px !important;
              }
              .titlebar-button > .toolbarbutton-icon {
                transition: all 0.3s ease !important;
                list-style-image: none;
                border-radius: 10px;
              }

              .titlebar-button.titlebar-min > .toolbarbutton-icon {
                background: rgba(var(--caption-min-color), 1); !important;
              }
              .titlebar-button.titlebar-max > .toolbarbutton-icon,
              .titlebar-button.titlebar-restore > .toolbarbutton-icon {
                background: rgba(var(--caption-max-color), 1); !important;
              }
              .titlebar-button.titlebar-close > .toolbarbutton-icon {
                  background: rgba(var(--caption-close-color), 1); !important;
              }

              .titlebar-button:hover > .toolbarbutton-icon {
                background: rgba(var(--third-accent-color), 1); !important;
              }
              .titlebar-button.titlebar-min:hover > .toolbarbutton-icon,
              .titlebar-button.titlebar-max:hover > .toolbarbutton-icon,
              .titlebar-button.titlebar-restore:hover > .toolbarbutton-icon,
              .titlebar-button.titlebar-close:hover > .toolbarbutton-icon {

              }


              /*================== NEW TAB BUTTON ==================*/
              toolbar #tabs-newtab-button:not([disabled="true"]):not([checked]):not([open]):not(:active) > .toolbarbutton-icon,
              toolbar #tabs-newtab-button:not([disabled="true"]):-moz-any([open], [checked], :hover:active) > .toolbarbutton-icon,
              toolbar #tabs-newtab-button:not([disabled="true"]):-moz-any([open], [checked], :active) > .toolbarbutton-icon {
                transition: all 0.3s ease !important;
                fill: rgba(var(--secondary-accent-color), 1) !important;
                border-radius: 4px !important;
                background-color: rgba(var(--transparent-bgcolor), 0.7) !important;
              }
              toolbar #tabs-newtab-button:not([disabled="true"]):not([checked]):not([open]):not(:active):hover > .toolbarbutton-icon {
                background-color: rgba(var(--transparent-bgcolor), 1) !important;
              }


              /*================== NAV BAR ==================*/
              toolbar#nav-bar {
                background: rgba(var(--dark-color), 1) !important;
                box-shadow: none !important;
                padding-bottom: 4px !important;
              }
              toolbar#nav-bar toolbarbutton .toolbarbutton-icon,
              toolbar#nav-bar toolbarbutton #fxa-avatar-image {
                transition: all 0.3s ease !important;
                fill: rgba(var(--secondary-accent-color), 1) !important;
              }
              #urlbar > #urlbar-background {
                border-radius: 4px !important;
                border: 0 !important;
                background-color: rgba(var(--accent-color), 1) !important;
              }
              #urlbar:not([focused="true"]) > #urlbar-background,
              #urlbar > #urlbar-input-container {
                border-radius: 4px !important;
              }
              #PersonalToolbar .toolbarbutton-1:not([disabled="true"]):not([checked]):not([open]):not(:active):hover, .tabbrowser-arrowscrollbox:not([scrolledtostart="true"])::part(scrollbutton-up):hover, .tabbrowser-arrowscrollbox:not([scrolledtoend="true"])::part(scrollbutton-down):hover, .findbar-button:not(:-moz-any([checked="true"], [disabled="true"])):hover, toolbarbutton.bookmark-item:not(.subviewbutton):hover:not([disabled="true"]):not([open]), toolbar .toolbarbutton-1:not([disabled="true"]):not([checked]):not([open]):not(:active):hover > .toolbarbutton-icon, toolbar .toolbarbutton-1:not([disabled="true"]):not([checked]):not([open]):not(:active):hover > .toolbarbutton-text, toolbar .toolbarbutton-1:not([disabled="true"]):not([checked]):not([open]):not(:active):hover > .toolbarbutton-badge-stack {
                background-color: rgba(var(--transparent-bgcolor), 0.7) !important;
              }

              #PersonalToolbar .toolbarbutton-1:not([disabled="true"]):-moz-any([open], [checked], :hover:active), .findbar-button:not([disabled="true"]):-moz-any([checked="true"], :hover:active), toolbarbutton.bookmark-item:not(.subviewbutton):hover:active:not([disabled="true"]), toolbarbutton.bookmark-item[open="true"], toolbar .toolbarbutton-1:not([disabled="true"]):-moz-any([open], [checked], :hover:active) > .toolbarbutton-icon, toolbar .toolbarbutton-1:not([disabled="true"]):-moz-any([open], [checked], :hover:active) > .toolbarbutton-text, toolbar .toolbarbutton-1:not([disabled="true"]):-moz-any([open], [checked], :hover:active) > .toolbarbutton-badge-stack {
                background-color: rgba(var(--transparent-bgcolor), 0.2) !important;
              }

              :root:not([uidensity="compact"]) #back-button > .toolbarbutton-icon {
                background-color: transparent !important;
              }

              .urlbar-input-box {
                  color: rgba(var(--third-accent-color), 1) !important;
              }

              /*Fixes the funky Reload/Stop button*/
              box.toolbarbutton-animatable-box {
                margin-top: -2px !important;
              }


              /*================== SEARCH BAR ==================*/
              searchbar#searchbar {
                margin-top: 4px !important;
                border-radius: 4px !important;
                border: 0 !important;
                fill: rgba(var(--secondary-accent-color), 1) !important;
                background-color: rgba(var(--accent-color), 1) !important;
                color: rgba(var(--third-accent-color), 1) !important;
                box-shadow: none !important;
              }
              #urlbar-input-container {
                background-color: rgba(var(--dark-color)) !important;
              }
              .urlbarView, .urlbarView-body-outer {
                background-color: rgba(var(--dark-color)) !important;
              }
              }

              /*================== SIDEBAR ==================*/
              #sidebar-box,
              .sidebar-panel[lwt-sidebar-brighttext] {
                background-color: rgba(var(--main-bgcolor), 1) !important;
              }
              #sidebar-header {
                border-color: rgba(var(--accent-color), 1) !important;
              }
              .sidebar-splitter {
                border-color: rgba(var(--accent-color), 1) !important;
              }
              #sidebar-switcher-target:hover,
              #sidebar-switcher-target:hover:active, #sidebar-switcher-target.active,
              #viewButton:hover,
              #viewButton[open] {
                background-color: rgba(var(--accent-color), 1) !important;
              }
              .sidebar-placesTreechildren {
                color: unset !important;
              }
              #search-box,
              .search-box {
                -moz-appearance: none !important;
                background-color: rgba(var(--accent-color), 1) !important;
                border-radius: 4px !important;
                color: unset !important;
              }
              .content-container {
                background-color: rgba(var(--main-bgcolor), 1) !important;
                color: unset !important;
              }
              #viewButton {
                color: unset !important;
              }


              /*================== CONTEXT MENU ==================*/

              #backForwardMenu,
              #contentAreaContextMenu,
              #customizationPaletteItemContextMenu,
              #customizationPanelItemContextMenu,
              #customization-toolbar-menu,
              #downloadsContextMenu,
              #new-tab-button-popup,
              #pageActionContextMenu,
              #PlacesChevronPopup,
              #placesContext,
              .search-one-offs-context-menu,
              #SyncedTabsSidebarContext,
              #SyncedTabsSidebarTabsFilterContext,
              #tabContextMenu,
              #tabs-newtab-button-popup,
              #textbox-contextmenu,
              .textbox-contextmenu,
              #toolbar-context-menu,
              #toolbox-menu,
              #widget-overflow > #customizationPanelItemContextMenu,
              #back-button > menupopup,
              #backForwardMenu menupopup,
              #contentAreaContextMenu menupopup,
              #customizationPaletteItemContextMenu menupopup,
              #customizationPanelItemContextMenu menupopup,
              #customization-toolbar-menu menupopup,
              #downloadsContextMenu menupopup,
              #forward-button > menupopup,
              #main-menubar menupopup,
              #new-tab-button-popup menupopup,
              #pageActionContextMenu menupopup,
              #PlacesChevronPopup menupopup,
              #placesContext menupopup,
              #PlacesToolbarItems .bookmark-item menupopup,
              .search-one-offs-context-menu menupopup,
              #SyncedTabsSidebarContext menupopup,
              #tabContextMenu menupopup,
              #textbox-contextmenu menupopup,
              .textbox-contextmenu menupopup,
              #toolbar-context-menu menupopup,
              #toolbox-menu menupopup,
              #viewButton > menupopup,
              #widget-overflow > #customizationPanelItemContextMenu menupopup,
              #back-button > menupopup menupopup,
              #forward-button > menupopup menupopup,
              #viewButton > menupopup menupopup
              {
                -moz-appearance: none !important;
                background-color: rgba(var(--accent-color), 1) !important;
                border: 1px solid rgba(var(--secondary-accent-color), 0.5) !important;
              }

              #back-button > menupopup :-moz-any(menuitem, menu),
              #backForwardMenu :-moz-any(menuitem, menu),
              #contentAreaContextMenu :-moz-any(menuitem, menu),
              #customizationPaletteItemContextMenu :-moz-any(menuitem, menu),
              #customizationPanelItemContextMenu :-moz-any(menuitem, menu),
              #customization-toolbar-menu :-moz-any(menuitem, menu),
              #downloadsContextMenu :-moz-any(menuitem, menu),
              #forward-button > menupopup :-moz-any(menuitem, menu),
              #main-menubar menupopup :-moz-any(menuitem, menu),
              #new-tab-button-popup :-moz-any(menuitem, menu),
              #pageActionContextMenu :-moz-any(menuitem, menu),
              #PlacesChevronPopup :-moz-any(menuitem, menu),
              #placesContext :-moz-any(menuitem, menu),
              #PlacesToolbarItems .bookmark-item menupopup :-moz-any(menuitem, menu),
              .search-one-offs-context-menu :-moz-any(menuitem, menu),
              #SyncedTabsSidebarContext :-moz-any(menuitem, menu),
              #tabContextMenu :-moz-any(menuitem, menu),
              #tabs-newtab-button-popup :-moz-any(menuitem, menu),
              .textbox-contextmenu :-moz-any(menuitem, menu),
              #toolbar-context-menu :-moz-any(menuitem, menu),
              #toolbox-menu :-moz-any(menuitem, menu),
              .urlbar-input-box .textbox-contextmenu :-moz-any(menuitem, menu),
              #viewButton > menupopup :-moz-any(menuitem, menu),
              #widget-overflow #customizationPanelItemContextMenu :-moz-any(menuitem, menu)
              {
                -moz-appearance: none !important;
                color: rgba(var(--third-accent-color), 0.8) !important;
                padding: 0px 0px 2px 0px !important;
                min-height: 22px !important;
              }

              #back-button > menupopup menugroup,
              #backForwardMenu menugroup,
              #contentAreaContextMenu menugroup,
              #customizationPaletteItemContextMenu menugroup,
              #customizationPanelItemContextMenu menugroup,
              #customization-toolbar-menu menugroup,
              #downloadsContextMenu menugroup,
              #forward-button > menupopup menugroup,
              #main-menubar menupopup menugroup,
              #new-tab-button-popup menugroup,
              #pageActionContextMenu menugroup,
              #PlacesChevronPopup menugroup,
              #placesContext menugroup,
              #PlacesToolbarItems .bookmark-item menupopup menugroup,
              .search-one-offs-context-menu menugroup,
              #SyncedTabsSidebarContext menugroup,
              #tabContextMenu menugroup,
              #tabs-newtab-button-popup menugroup,
              .textbox-contextmenu menugroup,
              #toolbar-context-menu menugroup,
              #toolbox-menu menugroup,
              .urlbar-input-box .textbox-contextmenu menugroup,
              #viewButton > menupopup menugroup,
              #widget-overflow #customizationPanelItemContextMenu menugroup
              {
                padding: 0px !important;
                background-color: transparent !important;
              }


              /* Separator */

              #back-button > menupopup menuseparator,
              #backForwardMenu menuseparator,
              #contentAreaContextMenu menuseparator,
              #customizationPaletteItemContextMenu menuseparator,
              #customizationPanelItemContextMenu menuseparator,
              #customization-toolbar-menu menuseparator,
              #downloadsContextMenu menuseparator,
              #forward-button > menupopup menuseparator,
              #main-menubar menupopup menuseparator,
              #new-tab-button-popup menuseparator,
              #pageActionContextMenu menuseparator,
              #PlacesChevronPopup menuseparator,
              #placesContext menuseparator,
              #PlacesToolbarItems .bookmark-item menupopup menuseparator,
              .search-one-offs-context-menu menuseparator,
              #SyncedTabsSidebarContext menuseparator,
              #tabContextMenu menuseparator,
              #tabs-newtab-button-popup menuseparator,
              .textbox-contextmenu menuseparator,
              #toolbar-context-menu menuseparator,
              #toolbox-menu menuseparator,
              .urlbar-input-box .textbox-contextmenu menuseparator,
              #viewButton > menupopup menuseparator,
              #widget-overflow > #customizationPanelItemContextMenu menuseparator
              {
                -moz-appearance: none !important;
                margin: 3px 8px 3px 8px !important;
                padding: 0 !important;
                border-top: 1px solid rgba(var(--third-accent-color), 0.1) !important;
                border-bottom: none !important;
              }


              /* Disabled */

              #back-button > menupopup :-moz-any(menuitem, menu)[disabled="true"],
              #backForwardMenu :-moz-any(menuitem, menu)[disabled="true"],
              #contentAreaContextMenu :-moz-any(menuitem, menu)[disabled="true"],
              #customizationPaletteItemContextMenu :-moz-any(menuitem, menu)[disabled="true"],
              #customizationPanelItemContextMenu :-moz-any(menuitem, menu)[disabled="true"],
              #customization-toolbar-menu :-moz-any(menuitem, menu)[disabled="true"],
              #downloadsContextMenu :-moz-any(menuitem, menu)[disabled="true"],
              #forward-button > menupopup :-moz-any(menuitem, menu)[disabled="true"],
              #main-menubar menupopup :-moz-any(menuitem, menu)[disabled="true"],
              #new-tab-button-popup :-moz-any(menuitem, menu)[disabled="true"],
              #pageActionContextMenu :-moz-any(menuitem, menu)[disabled="true"],
              #PlacesChevronPopup :-moz-any(menuitem, menu)[disabled="true"],
              #placesContext :-moz-any(menuitem, menu)[disabled="true"],
              #PlacesToolbarItems .bookmark-item menupopup :-moz-any(menuitem, menu)[disabled="true"],
              .search-one-offs-context-menu :-moz-any(menuitem, menu)[disabled="true"],
              #SyncedTabsSidebarContext :-moz-any(menuitem, menu)[disabled="true"],
              #tabContextMenu :-moz-any(menuitem, menu)[disabled="true"],
              #tabs-newtab-button-popup :-moz-any(menuitem, menu)[disabled="true"],
              .textbox-contextmenu :-moz-any(menuitem, menu)[disabled="true"],
              #toolbar-context-menu :-moz-any(menuitem, menu)[disabled="true"],
              #toolbox-menu :-moz-any(menuitem, menu)[disabled="true"],
              .urlbar-input-box .textbox-contextmenu :-moz-any(menuitem, menu)[disabled="true"],
              #viewButton > menupopup :-moz-any(menuitem, menu)[disabled="true"],
              #widget-overflow #customizationPanelItemContextMenu :-moz-any(menuitem, menu)[disabled="true"]
              {
                -moz-appearance: none !important;
                background-color: transparent !important;
                color: rgba(var(--third-accent-color), 0.3) !important;
              }

              #back-button > menupopup :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #backForwardMenu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #contentAreaContextMenu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #customizationPaletteItemContextMenu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #customizationPanelItemContextMenu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #customization-toolbar-menu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #downloadsContextMenu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #forward-button > menupopup :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #main-menubar menupopup :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #new-tab-button-popup :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #pageActionContextMenu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #PlacesChevronPopup :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #placesContext :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #PlacesToolbarItems .bookmark-item menupopup :-moz-any(menuitem, menu)[disabled="true"]:hover,
              .search-one-offs-context-menu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #SyncedTabsSidebarContext :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #tabContextMenu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #tabs-newtab-button-popup :-moz-any(menuitem, menu)[disabled="true"]:hover,
              .textbox-contextmenu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #toolbar-context-menu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #toolbox-menu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              .urlbar-input-box .textbox-contextmenu :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #viewButton > menupopup :-moz-any(menuitem, menu)[disabled="true"]:hover,
              #widget-overflow #customizationPanelItemContextMenu :-moz-any(menuitem, menu)[disabled="true"]:hover
              {
                -moz-appearance: none !important;
                background-color: transparent !important;
              }


              /* Hover */

              #back-button > menupopup :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #backForwardMenu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #customizationPaletteItemContextMenu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #customizationPanelItemContextMenu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #customization-toolbar-menu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #downloadsContextMenu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #forward-button > menupopup :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #main-menubar menupopup :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #new-tab-button-popup :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #contentAreaContextMenu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #pageActionContextMenu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #PlacesChevronPopup :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #placesContext :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #PlacesToolbarItems .bookmark-item menupopup :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              .search-one-offs-context-menu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #SyncedTabsSidebarContext :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #tabContextMenu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #tabs-newtab-button-popup :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              .textbox-contextmenu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #toolbar-context-menu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #toolbox-menu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              .urlbar-input-box .textbox-contextmenu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #viewButton > menupopup :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"]),
              #widget-overflow #customizationPanelItemContextMenu :-moz-any(menu, menuitem):-moz-any(:hover, [_moz-menuactive="true"]):not([disabled="true"])
              {
                -moz-appearance: none !important;
                background-color: rgba(var(--secondary-accent-color), 0.4) !important;
                color: rgba(var(--light-color), 1) !important;
              }


              /* Icons */

              #back-button > menupopup .menu-right,
              #backForwardMenu .menu-right,
              #contentAreaContextMenu .menu-right,
              #customizationPaletteItemContextMenu .menu-right,
              #customizationPanelItemContextMenu .menu-right,
              #customization-toolbar-menu .menu-right,
              #downloadsContextMenu .menu-right,
              #forward-button > menupopup .menu-right,
              #main-menubar menupopup .menu-right,
              #new-tab-button-popup .menu-right,
              #pageActionContextMenu .menu-right,
              #PlacesChevronPopup .menu-right,
              #placesContext .menu-right,
              #PlacesToolbarItems .bookmark-item menupopup .menu-right,
              .search-one-offs-context-menu .menu-right,
              #SyncedTabsSidebarContext .menu-right,
              #tabContextMenu .menu-right,
              #tabs-newtab-button-popup .menu-right,
              .textbox-contextmenu .menu-right,
              #toolbar-context-menu .menu-right,
              #toolbox-menu .menu-right,
              .urlbar-input-box .textbox-contextmenu .menu-right,
              #viewButton > menupopup .menu-right,
              #widget-overflow #customizationPanelItemContextMenu .menu-right
              {
                -moz-appearance: none !important;
                margin-right: 6px !important;
                padding: 7.5px !important;
                color: rgba(var(--third-accent-color), 1) !important;
                border: solid rgba(var(--third-accent-color), 1) !important;
                border-width: 0px 2px 2px 0px !important;
                transform: rotate(-45deg) scale(.55);
              }

              #back-button > menupopup menu[disabled="true"] .menu-right,
              #backForwardMenu menu[disabled="true"] .menu-right,
              #contentAreaContextMenu menu[disabled="true"] .menu-right,
              #customizationPaletteItemContextMenu menu[disabled="true"] .menu-right,
              #customizationPanelItemContextMenu menu[disabled="true"] .menu-right,
              #customization-toolbar-menu menu[disabled="true"] .menu-right,
              #downloadsContextMenu menu[disabled="true"] .menu-right,
              #forward-button > menupopup menu[disabled="true"] .menu-right,
              #main-menubar menupopup menu[disabled="true"] .menu-right,
              #new-tab-button-popup menu[disabled="true"] .menu-right,
              #pageActionContextMenu menu[disabled="true"] .menu-right,
              #PlacesChevronPopup menu[disabled="true"] .menu-right,
              #placesContext menu[disabled="true"] .menu-right,
              #PlacesToolbarItems .bookmark-item menupopup menu[disabled="true"] .menu-right,
              .search-one-offs-context-menu menu[disabled="true"] .menu-right,
              #SyncedTabsSidebarContext menu[disabled="true"] .menu-right,
              #tabContextMenu menu[disabled="true"] .menu-right,
              #tabs-newtab-button-popup menu[disabled="true"] .menu-right,
              .textbox-contextmenu menu[disabled="true"] .menu-right,
              #toolbar-context-menu menu[disabled="true"] .menu-right,
              #toolbox-menu menu[disabled="true"] .menu-right,
              .urlbar-input-box .textbox-contextmenu menu[disabled="true"] .menu-right,
              #viewButton > menupopup menu[disabled="true"] .menu-right,
              #widget-overflow #customizationPanelItemContextMenu menu[disabled="true"] .menu-right
              {
                color: rgba(var(--third-accent-color), 0.3) !important;
                border-color: rgba(var(--third-accent-color), 0.3) !important;
              }


              /* Checkbox and Radio Items */

              #back-button menuitem[type="checkbox"],
              #back-button > menupopup menuitem[type="checkbox"],
              #backForwardMenu menuitem[type="checkbox"],
              #contentAreaContextMenu menuitem[type="checkbox"],
              #customizationPaletteItemContextMenu menuitem[type="checkbox"],
              #customizationPanelItemContextMenu menuitem[type="checkbox"],
              #customization-toolbar-menu menuitem[type="checkbox"],
              #downloadsContextMenu menuitem[type="checkbox"],
              #forward-button menuitem[type="checkbox"],
              #forward-button > menupopup menuitem[type="checkbox"],
              #main-menubar menupopup menuitem[type="checkbox"],
              #new-tab-button-popup menuitem[type="checkbox"],
              #pageActionContextMenu menuitem[type="checkbox"],
              #PlacesChevronPopup menuitem[type="checkbox"],
              #placesContext menuitem[type="checkbox"],
              #PlacesToolbarItems .bookmark-item menupopup menuitem[type="checkbox"],
              .search-one-offs-context-menu menuitem[type="checkbox"],
              #SyncedTabsSidebarContext menuitem[type="checkbox"],
              #tabContextMenu menuitem[type="checkbox"],
              #tabs-newtab-button-popup menuitem[type="checkbox"],
              .textbox-contextmenu menuitem[type="checkbox"],
              #toolbar-context-menu menuitem[type="checkbox"],
              #toolbox-menu menuitem[type="checkbox"],
              .urlbar-input-box .textbox-contextmenu menuitem[type="checkbox"],
              #viewButton > menupopup menuitem[type="checkbox"],
              #widget-overflow > #customizationPanelItemContextMenu menuitem[type="checkbox"]
              {
                -moz-appearance: none !important;
              }

              #back-button menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #back-button > menupopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #backForwardMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #contentAreaContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #customizationPaletteItemContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #customizationPanelItemContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #customization-toolbar-menu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #downloadsContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #forward-button menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #forward-button > menupopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #main-menubar menupopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #new-tab-button-popup menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #pageActionContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #PlacesChevronPopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #placesContext menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #PlacesToolbarItems .bookmark-item menupopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              .search-one-offs-context-menu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #SyncedTabsSidebarContext menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #tabContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #tabs-newtab-button-popup menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              .textbox-contextmenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #toolbar-context-menu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #toolbox-menu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              .urlbar-input-box .textbox-contextmenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #viewButton > menupopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-left,
              #widget-overflow > #customizationPanelItemContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-left
              {
                -moz-appearance: none !important;
                padding: 7px 0px 0px 0px !important;
                margin-left: 7px !important;
                margin-right: -7px !important;
                border: solid rgba(var(--third-accent-color), 1) !important;
                border-width: 0px 0px 2px 2px !important;
                transform: rotate(-45deg) scale(.75);
              }

              #back-button menuitem[type="radio"],
              #back-button > menupopup menuitem[type="radio"],
              #backForwardMenu menuitem[type="radio"],
              #contentAreaContextMenu menuitem[type="radio"],
              #customizationPaletteItemContextMenu menuitem[type="radio"],
              #customizationPanelItemContextMenu menuitem[type="radio"],
              #customization-toolbar-menu menuitem[type="radio"],
              #downloadsContextMenu menuitem[type="radio"],
              #forward-button menuitem[type="radio"],
              #forward-button > menupopup menuitem[type="radio"],
              #main-menubar menupopup menuitem[type="radio"],
              #new-tab-button-popup menuitem[type="radio"],
              #pageActionContextMenu menuitem[type="radio"],
              #PlacesChevronPopup menuitem[type="radio"],
              #placesContext menuitem[type="radio"],
              #PlacesToolbarItems .bookmark-item menupopup menuitem[type="radio"],
              .search-one-offs-context-menu menuitem[type="radio"],
              #SyncedTabsSidebarContext menuitem[type="radio"],
          A journaling file system is a file system that keeps track of changes not yet committed to the file system's main part by recording the intentions of such changes in a data structure known as a "journal", which is usually a circular log. In the event of a system crash or power failure, such file systems can be brought back online more quickly with a lower likelihood of becoming corrupted.    #tabContextMenu menuitem[type="radio"],
              #tabs-newtab-button-popup menuitem[type="radio"],
              .textbox-contextmenu menuitem[type="radio"],
              #toolbar-context-menu menuitem[type="radio"],
              #toolbox-menu menuitem[type="radio"],
              .urlbar-input-box .textbox-contextmenu menuitem[type="radio"],
              #viewButton > menupopup menuitem[type="radio"],
              #widget-overflow > #customizationPanelItemContextMenu menuitem[type="radio"]
              {
                -moz-appearance: none !important;
              }

              #back-button menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #back-button > menupopup menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #backForwardMenu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #contentAreaContextMenu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #customizationPaletteItemContextMenu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #customizationPanelItemContextMenu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #customization-toolbar-menu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #downloadsContextMenu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #forward-button menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #forward-button > menupopup menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #main-menubar menupopup menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #new-tab-button-popup menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #pageActionContextMenu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #PlacesChevronPopup menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #placesContext menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #PlacesToolbarItems .bookmark-item menupopup menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              .search-one-offs-context-menu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #SyncedTabsSidebarContext menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #tabContextMenu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #tabs-newtab-button-popup menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              .textbox-contextmenu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #toolbar-context-menu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #toolbox-menu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              .urlbar-input-box .textbox-contextmenu menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #viewButton > menupopup menuitem[checked="true"][type="radio"] > .menu-iconic-left,
              #widget-overflow > #customizationPanelItemContextMenu menuitem[checked="true"][type="radio"] > .menu-iconic-left
              {
                -moz-appearance: none !important;
                border: solid rgba(var(--third-accent-color), 1) !important;
                height: 17px !important;
                border-radius: 100% !important;
                background: rgba(var(--third-accent-color), 1) !important;
                margin-left: 7px !important;
                margin-right: -7px !important;
                margin-top: 1px !important;
                padding: 1px !important;
                transform: scale(0.5);
              }

              #back-button menuitem[type="checkbox"] > .menu-iconic-text,
              #back-button > menupopup menuitem[type="checkbox"] > .menu-iconic-text,
              #backForwardMenu menuitem[type="checkbox"] > .menu-iconic-text,
              #contentAreaContextMenu menuitem[type="checkbox"] > .menu-iconic-text,
              #customizationPaletteItemContextMenu menuitem[type="checkbox"] > .menu-iconic-text,
              #customizationPanelItemContextMenu menuitem[type="checkbox"] > .menu-iconic-text,
              #customization-toolbar-menu menuitem[type="checkbox"] > .menu-iconic-text,
              #downloadsContextMenu menuitem[type="checkbox"] > .menu-iconic-text,
              #forward-button menuitem[type="checkbox"] > .menu-iconic-text,
              #forward-button > menupopup menuitem[type="checkbox"] > .menu-iconic-text,
              #main-menubar menupopup menuitem[type="checkbox"] > .menu-iconic-text,
              #new-tab-button-popup menuitem[type="checkbox"] > .menu-iconic-text,
              #pageActionContextMenu menuitem[type="checkbox"] > .menu-iconic-text,
              #PlacesChevronPopup menuitem[type="checkbox"] > .menu-iconic-text,
              #placesContext menuitem[type="checkbox"] > .menu-iconic-text,
              #PlacesToolbarItems .bookmark-item menupopup menuitem[type="checkbox"] > .menu-iconic-text,
              .search-one-offs-context-menu menuitem[type="checkbox"] > .menu-iconic-text,
              #SyncedTabsSidebarContext menuitem[type="checkbox"] > .menu-iconic-text,
              #tabContextMenu menuitem[type="checkbox"] > .menu-iconic-text,
              #tabs-newtab-button-popup menuitem[type="checkbox"] > .menu-iconic-text,
              .textbox-contextmenu menuitem[type="checkbox"] > .menu-iconic-text,
              #toolbar-context-menu menuitem[type="checkbox"] > .menu-iconic-text,
              #toolbox-menu menuitem[type="checkbox"] > .menu-iconic-text,
              .urlbar-input-box .textbox-contextmenu menuitem[type="checkbox"] > .menu-iconic-text,
              #viewButton > menupopup menuitem[type="checkbox"] > .menu-iconic-text,
              #widget-overflow > #customizationPanelItemContextMenu menuitem[type="checkbox"] > .menu-iconic-text
              {
                -moz-appearance: none !important;
              }
              #back-button menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #back-button > menupopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #backForwardMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #contentAreaContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #customizationPaletteItemContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #customizationPanelItemContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #customization-toolbar-menu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #downloadsContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #forward-button menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #forward-button > menupopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #main-menubar menupopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #new-tab-button-popup menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #pageActionContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #PlacesChevronPopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #placesContext menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #PlacesToolbarItems .bookmark-item menupopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              .search-one-offs-context-menu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #SyncedTabsSidebarContext menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #tabContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #tabs-newtab-button-popup menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              .textbox-contextmenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #toolbar-context-menu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #toolbox-menu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              .urlbar-input-box .textbox-contextmenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #viewButton > menupopup menuitem[checked="true"][type="checkbox"] > .menu-iconic-text,
              #widget-overflow > #customizationPanelItemContextMenu menuitem[checked="true"][type="checkbox"] > .menu-iconic-text
              {
                padding-left: 13px !important;
              }

              #back-button menuitem[type="radio"] > .menu-iconic-text,
              #back-button > menupopup menuitem[type="radio"] > .menu-iconic-text,
              #backForwardMenu menuitem[type="radio"] > .menu-iconic-text,
              #contentAreaContextMenu menuitem[type="radio"] > .menu-iconic-text,
              #customizationPaletteItemContextMenu menuitem[type="radio"] > .menu-iconic-text,
              #customizationPanelItemContextMenu menuitem[type="radio"] > .menu-iconic-text,
              #customization-toolbar-menu menuitem[type="radio"] > .menu-iconic-text,
              #downloadsContextMenu menuitem[type="radio"] > .menu-iconic-text,
              #forward-button menuitem[type="radio"] > .menu-iconic-text,
              #forward-button > menupopup menuitem[type="radio"] > .menu-iconic-text,
              #main-menubar menupopup menuitem[type="radio"] > .menu-iconic-text,
              #new-tab-button-popup menuitem[type="radio"] > .menu-iconic-text,
              #pageActionContextMenu menuitem[type="radio"] > .menu-iconic-text,
              #PlacesChevronPopup menuitem[type="radio"] > .menu-iconic-text,
              #placesContext menuitem[type="radio"] > .menu-iconic-text,
              #PlacesToolbarItems .bookmark-item menupopup menuitem[type="radio"] > .menu-iconic-text,
              .search-one-offs-context-menu menuitem[type="radio"] > .menu-iconic-text,
              #SyncedTabsSidebarContext menuitem[type="radio"] > .menu-iconic-text,
              #tabContextMenu menuitem[type="radio"] > .menu-iconic-text,
              #tabs-newtab-button-popup menuitem[type="radio"] > .menu-iconic-text,
              .textbox-contextmenu menuitem[type="radio"] > .menu-iconic-text,
              #toolbar-context-menu menuitem[type="radio"] > .menu-iconic-text,
              #toolbox-menu menuitem[type="radio"] > .menu-iconic-text,
              .urlbar-input-box .textbox-contextmenu menuitem[type="radio"] > .menu-iconic-text,
              #viewButton > menupopup menuitem[type="radio"] > .menu-iconic-text,
              #widget-overflow > #customizationPanelItemContextMenu menuitem[type="radio"] > .menu-iconic-text
              {
                padding-left: 13px !important;
                -moz-appearance: none !important;
              }



              #pocket-button {
                display: none
              }

              /* Tabs Sidebar stuff *//*{{{*/

              :root {
                --sidebar-min-width: 33px;
                --sidebar-visible-width: 300px;
              }

              #sidebar-header {
                overflow: hidden !important;
              }

              #sidebar-box #sidebar-header {
                display: none !important;
              }

              #sidebar,
              #sidebar-header {
                position: relative !important;
                min-width: var(--sidebar-min-width) !important;
                max-width: var(--sidebar-min-width) !important;
              transition: .2s ease .25s;
                z-index:1;
              }

              #sidebar-box:hover :-moz-any(#sidebar,#sidebar-header) {
                background-color: var(--toolbar-bgcolor) !important;
                min-width: var(--sidebar-visible-width) !important;
                max-width: var(--sidebar-visible-width) !important;
                margin-right: calc((var(--sidebar-visible-width) - var(--sidebar-min-width)) * -1) !important;A journaling file system is a file system that keeps track of changes not yet committed to the file system's main part by recording the intentions of such changes in a data structure known as a "journal", which is usually a circular log. In the event of a system crash or power failure, such file systems can be brought back online more quickly with a lower likelihood of becoming corrupted.
                z-index:1;
                position: relative !important;
              transition: .2s ease .1s;
              }

              #TabsToolbar {
                visibility: collapse;
              }

              /* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_toolbox.css made available under Mozilla Public License v. 2.0
              See the above repository for updates as well as full license text. */

              /* Hide the whole toolbar area unless urlbar is focused or cursor is over the toolbar */
              /* Dimensions on non-Win10 OS probably needs to be adjusted */

              /* Compatibility options for hide_tabs_toolbar.css and tabs_on_bottom.css at the end of this file */

              :root{
                --uc-autohide-toolbox-delay: 1000ms; /* Wait 0.1s before hiding toolbars */
                --uc-toolbox-rotation: 75deg;  /* This may need to be lower on mac - like 75 or so */
              }

              :root[sizemode="maximized"]{
                --uc-toolbox-rotation: 89deg;
              }

              @media (-moz-os-version: windows-win10){

                :root[tabsintitlebar][sizemode="maximized"]:not([inDOMFullscreen]) > body > box{ margin-top: 9px !important; }
                :root[tabsintitlebar][sizemode="maximized"] #navigator-toolbox{ margin-top: -1px }

                @media screen and (min-resolution: 1.25dppx){
                  :root[tabsintitlebar][sizemode="maximized"]:not([inDOMFullscreen]) > body > box{ margin-top: 8px !important; }
                }
                @media screen and (min-resolution: 1.5dppx){
                  :root[tabsintitlebar][sizemode="maximized"]:not([inDOMFullscreen]) > body > box{ margin-top: 8px !important; }
                }
                @media screen and (min-resolution: 2dppx){
                  :root[tabsintitlebar][sizemode="maximized"]:not([inDOMFullscreen]) > body > box{ margin-top: 7px !important; }
                }
                #navigator-toolbox:not(:-moz-lwtheme){ background-color: rgb(32, 35, 64) !important; }
              }

              :root[sizemode="fullscreen"]{ margin-top: 0px !important; }

              #navigator-toolbox{
                position: fixed !important;
                display: block;
                background-color: var(--lwt-accent-color,black) !important;
                transition: transform 82ms linear, opacity 82ms linear !important;
                transition-delay: var(--uc-autohide-toolbox-delay) !important;
                transform-origin: top;
                transform: rotateX(var(--uc-toolbox-rotation));
                opacity: 0;
                line-height: 0;
                z-index: 2;
                pointer-events: none;
              }

              /* #mainPopupSet:hover ~ box > toolbox, */
              /* Uncomment the above line to make toolbar visible if some popup is hovered */
              #navigator-toolbox:hover,
              #navigator-toolbox:focus-within{
                transition-delay: 0ms !important;
                transform: rotateX(0);
                opacity: 1;
              }

              #navigator-toolbox > *{ line-height: normal; pointer-events: auto }

              #navigator-toolbox,
              #navigator-toolbox > *{
                -moz-appearance: none !important;
              }

              /* These two exist for oneliner compatibility */
              #nav-bar{ width: var(--uc-navigationbar-width,100vw); }
              #TabsToolbar{ width: calc(100vw - var(--uc-navigationbar-width,0px)) }

              /* Don't apply transform before window has been fully created */
              :root:not([sessionrestored]) #navigator-toolbox{ transform:none !important }

              :root[customizing] #navigator-toolbox{
                position: relative !important;
                transform: none !important;
                opacity: 1 !important;
              }

              #navigator-toolbox[inFullscreen] > #PersonalToolbar,
              #PersonalToolbar[collapsed="true"]{ display: none }

              /* Uncomment this if tabs toolbar is hidden with hide_tabs_toolbar.css */

              /* Uncomment the following for compatibility with tabs_on_bottom.css - this isn't well tested though */
              /*
              :root{ --uc-titlebar-padding: 0px !important; }
              #navigator-toolbox{ flex-direction: column; display: flex; }
              #titlebar{ order: 2 }
              */

              #webrtcIndicator {
                display: none;
              }
        '';
        userContent = ''
          /*================ GLOBAL COLORS ================*/
          :root {
            --accent-color: 54, 54, 54;
            --secondary-accent-color: 140, 140, 140;
            --third-accent-color: 190, 190, 190;
            --light-color: 255, 255, 255;
            --dark-color: 36, 36, 36;
            --caption-min-color: 255, 133, 94;
            --caption-max-color: 255, 100, 159;
            --caption-close-color: 153, 132, 255;
          }

          /*================ DARK THEME ================*/
          :root:-moz-lwtheme-brighttext,
          .sidebar-panel[lwt-sidebar-brighttext],
          body[lwt-sidebar-brighttext] {
            --main-bgcolor: var(--dark-color);
            --transparent-bgcolor: var(--accent-color);
          }


          /*================== NEW TAB BG COLOR ==================*/
          @media (prefers-color-scheme: dark) {
          @-moz-document url("about:newtab"), url("about:home"), url("about:blank") {
           body.activity-stream { background-color: rgba(var(--dark-color), 1) !important;}
          }
          }

          @media (prefers-color-scheme: light) {
          @-moz-document url("about:newtab"), url("about:home"), url("about:blank") {
           body.activity-stream { background-color: rgba(var(--light-color), 1) !important;}
          }
          }

          /*================== SEARCH BAR ==================*/
          #root .search-wrapper input {
            transition: all 0.3s ease !important;
              background: rgba(var(--accent-color), 0.2) var(--newtab-search-icon) 12px center no-repeat !important;
            background-size: 20px !important;
            border: 2px solid !important;
            border-color: rgba(var(--accent-color), 0.3) !important;
            box-shadow: none !important;
          }
          #root .search-wrapper .search-inner-wrapper:hover input,
          #root .search-wrapper .search-inner-wrapper:active input,
          #root .search-wrapper input:focus {
            border-color: rgba(var(--accent-color), 0.6) !important;
          }

          #root .search-wrapper .search-button,
          #root .search-wrapper .search-button {
            transition: all 0.3s ease !important;
          }
          #root .search-wrapper .search-button:focus,
          #root .search-wrapper .search-button:hover {
              background-color: rgba(var(--accent-color), 1) !important;
          }

          /*================== SEARCH BAR RESULTS ==================*/
          .contentSearchSuggestionTable .contentSearchSuggestionsContainer,
          .contentSearchSuggestionTable .contentSearchHeader {
              background-color: rgba(var(--accent-color), 1) !important;
          }
          .contentSearchSuggestionTable .contentSearchSuggestionRow.selected,
          .contentSearchSuggestionTable .contentSearchOneOffItem.selected {
            background-color: rgba(var(--secondary-accent-color), 0.2) !important;
          }

          .contentSearchSuggestionTable .contentSearchHeader,
          .contentSearchSuggestionTable .contentSearchSettingsButton,
          .contentSearchSuggestionTable .contentSearchOneOffsTable {
            border-color: rgba(var(--secondary-accent-color), 0.2) !important;
          }

          .contentSearchSuggestionTable {
            box-shadow: none !important;
            border: 2px solid rgba(var(--secondary-accent-color), 0.2) !important;
            border-radius: 3px !important;
          }

        '';
        extraConfig = ''
          //          // PREF: Disable leaking network/browser connection information via Javascript // Network Information API provides general information about the system's connection type (WiFi, cellular, etc.) // https://developer.mozilla.org/en-US/docs/Web/API/Network_Information_API
          //          // https://wicg.github.io/netinfo/#privacy-considerations
          //          // https://bugzilla.mozilla.org/show_bug.cgi?id=960426
          //          user_pref("dom.netinfo.enabled",        false);
          //
          //          // PREF: Don't reveal your internal IP when WebRTC is enabled (Firefox >= 42)
          //          // https://wiki.mozilla.org/Media/WebRTC/Privacy
          //          // https://github.com/beefproject/beef/wiki/Module%3A-Get-Internal-IP-WebRTC
          //          user_pref("media.peerconnection.ice.default_address_only",  true); // Firefox 42-51
          //          user_pref("media.peerconnection.ice.no_host",      true); // Firefox >= 52
          //
          //
          //          // PREF: Disable pinging URIs specified in HTML <a> ping= attributes
          //          // http://kb.mozillazine.org/Browser.send_pings
                    user_pref("browser.send_pings",          false);
          //
          //          // PREF: Disable Extension recommendations (Firefox >= 65)
          //          // https://support.mozilla.org/en-US/kb/extension-recommendations
                    user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr",  false);
          //
          //          // PREF: Disable Mozilla telemetry/experiments
          //          // https://wiki.mozilla.org/Platform/Features/Telemetry
          //          // https://wiki.mozilla.org/Privacy/Reviews/Telemetry
          //          // https://wiki.mozilla.org/Telemetry
          //          // https://www.mozilla.org/en-US/legal/privacy/firefox.html#telemetry
          //          // https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
          //          // https://wiki.mozilla.org/Security/Reviews/Firefox6/ReviewNotes/telemetry
          //          // https://gecko.readthedocs.io/en/latest/browser/experiments/experiments/manifest.html
          //          // https://wiki.mozilla.org/Telemetry/Experiments
          //          // https://support.mozilla.org/en-US/questions/1197144
          //          // https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html#id1
                    user_pref("toolkit.telemetry.enabled",        false);
                    user_pref("toolkit.telemetry.unified",        false);
                    user_pref("toolkit.telemetry.archive.enabled",      false);
                    user_pref("experiments.supported",        false);
                    user_pref("experiments.enabled",        false);
                    user_pref("experiments.manifest.uri",        "");
          //
          //          // PREF: Disallow Necko to do A/B testing
          //          // https://trac.torproject.org/projects/tor/ticket/13170
          //          user_pref("network.allow-experiments",        false);
          //
          //          // PREF: Disable sending Firefox crash reports to Mozilla servers
          //          // https://wiki.mozilla.org/Breakpad
          //          // http://kb.mozillazine.org/Breakpad
          //          // https://dxr.mozilla.org/mozilla-central/source/toolkit/crashreporter
          //          // https://bugzilla.mozilla.org/show_bug.cgi?id=411490
          //          // A list of submitted crash reports can be found at about:crashes
                    user_pref("breakpad.reportURL",          "");
          //
          //          // PREF: Disable sending reports of tab crashes to Mozilla (about:tabcrashed), don't nag user about unsent crash reports
          //          // https://hg.mozilla.org/mozilla-central/file/tip/browser/app/profile/firefox.js
          //          user_pref("browser.tabs.crashReporting.sendReport",    false);
          //          user_pref("browser.crashReports.unsubmittedCheck.enabled",  false);
          //
          //          // PREF: Disable FlyWeb (discovery of LAN/proximity IoT devices that expose a Web interface)
          //          // https://wiki.mozilla.org/FlyWeb
          //          // https://wiki.mozilla.org/FlyWeb/Security_scenarios
          //          // https://docs.google.com/document/d/1eqLb6cGjDL9XooSYEEo7mE-zKQ-o-AuDTcEyNhfBMBM/edit
          //          // http://www.ghacks.net/2016/07/26/firefox-flyweb
          //          // changed
          //          user_pref("dom.flyweb.enabled",          true);
          //
          //          // PREF: Disable the UITour backend
          //          // https://trac.torproject.org/projects/tor/ticket/19047#comment:3
          //          // changed
          //          user_pref("browser.uitour.enabled",        true);
          //
          //          // PREF: Enable Firefox Tracking Protection
          //          // https://wiki.mozilla.org/Security/Tracking_protection
          //          // https://support.mozilla.org/en-US/kb/tracking-protection-firefox
          //          // https://support.mozilla.org/en-US/kb/tracking-protection-pbm
          //          // https://kontaxis.github.io/trackingprotectionfirefox/
          //          // https://feeding.cloud.geek.nz/posts/how-tracking-protection-works-in-firefox/
                    user_pref("privacy.trackingprotection.enabled",      true);
                    user_pref("privacy.trackingprotection.pbmode.enabled",    true);
          //
          //          // PREF: Disable collection/sending of the health report (healthreport.sqlite*)
          //          // https://support.mozilla.org/en-US/kb/firefox-health-report-understand-your-browser-perf
          //          // https://gecko.readthedocs.org/en/latest/toolkit/components/telemetry/telemetry/preferences.html
                    user_pref("datareporting.healthreport.uploadEnabled",    false);
                    user_pref("datareporting.healthreport.service.enabled",    false);
                    user_pref("datareporting.policy.dataSubmissionEnabled",    false);
          //          // "Allow Firefox to make personalized extension recommendations"
                    user_pref("browser.discovery.enabled",        false);
          //
          //          // PREF: Disable Shield/Heartbeat/Normandy (Mozilla user rating telemetry)
          //          // https://wiki.mozilla.org/Advocacy/heartbeat
          //          // https://trac.torproject.org/projects/tor/ticket/19047
          //          // https://trac.torproject.org/projects/tor/ticket/18738
          //          // https://wiki.mozilla.org/Firefox/Shield
          //          // https://github.com/mozilla/normandy
          //          // https://support.mozilla.org/en-US/kb/shield
          //          // https://bugzilla.mozilla.org/show_bug.cgi?id=1370801
                    //user_pref("app.normandy.enabled", false);
                    //user_pref("app.normandy.api_url", "");
                    user_pref("extensions.shield-recipe-client.enabled",    false);
                    user_pref("app.shield.optoutstudies.enabled",      false);
          //
          //          // PREF: Disable Firefox Hello metrics collection
          //          // https://groups.google.com/d/topic/mozilla.dev.platform/nyVkCx-_sFw/discussion
                    user_pref("loop.logDomains",          false);
          //
          //          // PREF: Disable querying Google Application Reputation database for downloaded binary files
          //          // https://www.mozilla.org/en-US/firefox/39.0/releasenotes/
          //          // https://wiki.mozilla.org/Security/Application_Reputation
          //          user_pref("browser.safebrowsing.downloads.remote.enabled",  false);
          //
          //          // PREF: Disable Pocket
          //          // https://support.mozilla.org/en-US/kb/save-web-pages-later-pocket-firefox
          //          // https://github.com/pyllyukko/user.js/issues/143
          //          user_pref("browser.pocket.enabled",        false);
          //          user_pref("extensions.pocket.enabled",        false);
          //
          //          // PREF: Disable "Recommended by Pocket" in Firefox Quantum
                    user_pref("browser.newtabpage.activity-stream.feeds.section.topstories",  false);
          //
          //          // PREF: Accept Only 1st Party Cookies
          //          // http://kb.mozillazine.org/Network.cookie.cookieBehavior#1
          //          // NOTICE: Blocking 3rd-party cookies breaks a number of payment gateways
          //          // CIS 2.5.1
                    user_pref("network.cookie.cookieBehavior",      1);
          //
          //          // PREF: Spoof User-agent (disabled)
          //          user_pref("general.useragent.override",        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.114 Safari/537.36");
          //          user_pref("general.appname.override",        "Chrome");
          //          //user_pref("general.appversion.override",      "5.0 (Windows)");
          //          //user_pref("general.platform.override",        "Win32");
          //          //user_pref("general.oscpu.override",        "Windows NT 6.1");

                    // PREF: Do not check if Firefox is the default browser
                    user_pref("browser.shell.checkDefaultBrowser",      false);
        '';
      };
    };

    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      browserpass
      buster-captcha-solver
      cookie-autodelete
      darkreader
      gesturefy
      greasemonkey
      i-dont-care-about-cookies
      languagetool
      privacy-badger
      sidebery
      stylus
      ublock-origin
      unpaywall
      no-pdf-download
      to-deepl
      sponsorblock
      noscript
    ];
  };
}
