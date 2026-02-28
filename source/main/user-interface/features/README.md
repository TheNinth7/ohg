# Folder `features`

Contains the primary user-facing functionality of the application.

This folder implements the main UI features exposed to the user. Each feature represents a concrete capability of the app and is structured as an independent UI module.

Currently, three feature categories are implemented:

- **Glance** – A compact view shown in the device’s glance carousel.  
- **Settings** – A menu providing app status information and maintenance actions.  
- **Sitemap** – The core feature of the app, displaying and interacting with openHAB sitemap elements.

---

## Key Concepts

The main UI is built on top of `CustomMenu`, a customizable variant of `Menu2` that leverages the native UI controls of the watch.

Sitemap widgets are implemented as `CustomMenuItem` instances. These display the current state of an element and may either:

- Provide direct interaction (e.g., toggle switches), or  
- Open full-screen control views for more complex interactions.

The _Settings_ menu is also implemented using `CustomMenu`.

### Further Reading

- [Connect IQ Core Topics – Native UI Controls](https://developer.garmin.com/connect-iq/core-topics/native-controls/)  
- [Connect IQ API Docs – `Toybox.WatchUi.CustomMenu`](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/CustomMenu.html)

---

## Subfolder `glance/`

Implements the Glance feature.

`GlanceSitemapView` provides a compact view that reads the sitemap label from persistent storage and displays it in the glance carousel.

When the app is launched in glance mode, `OHApp.getGlanceView()` acts as the entry point and prepares the corresponding view.

### Memory Constraints

When running as a glance, available memory is very limited. Connect IQ supports scoped classes and resources for this purpose. Classes required in glance mode must be annotated with `(:glance)`, and only the strictly necessary classes should be included in this scope.

---

## Subfolder `settings-menu/`

Implements the _Settings_ feature.

Currently provides the following information and actions:

- App version  
- openHAB server URL  
- Current connection mode (Phone/BLE, Wi-Fi, Offline)  
- Timestamp of the last sitemap update  
- Manual sitemap update over Wi-Fi  

Because Wi-Fi mode does not automatically poll for structural sitemap changes, updates must be triggered manually when operating without a BLE connection.  
See [No Polling of Sitemap Changes and States](https://next.openhab.org/docs/apps/garmin/#no-polling-of-sitemap-changes-and-states) in the user manual for details and screenshots.

### Platform-Specific Behavior

- **Button-based devices**  
  The _Settings_ menu appears as a parallel menu to the homepage. It is accessed by scrolling beyond the title or footer of the _Homepage_ menu, mimicking the system settings access pattern on devices such as the Fenix 7 Pro or Epix 2 Pro.

- **Touch-based devices**  
  Due to more limited gesture support, the _Settings_ menu is implemented as a regular menu item within the _Homepage_.

Device-specific behavior is defined in the `monkey.jungle` build file. Exclusion annotations (also used in input delegates) ensure that the correct implementation is compiled per device.

### Subfolders

#### Subfolder `manager/`

Contains `SettingsMenuManager`, which controls the lifecycle and presentation of the settings menu.

It maintains singleton instances of the menu and its input delegate, tracks whether the menu is currently visible, and coordinates transitions between the homepage and the settings view. It also determines focus behavior based on slide direction and input type, and manages pushing and popping the view on the `ViewStack`.

#### Subfolder `menu/`

Contains the `SettingsMenu` implementation based on `BaseMenu`, along with the corresponding input delegates for handling user interaction.

#### Subfolder `menu-items/`

Contains the individual menu items displayed within the _Settings_ menu.

---

## Subfolder `sitemap/`

Implements the core UI for displaying and interacting with openHAB sitemap content.

This includes:

- The main sitemap menu  
- Menu items representing sitemap elements  
- Full-screen control views for complex interactions  

For detailed information, see the folder’s [README](sitemap/README.md).
