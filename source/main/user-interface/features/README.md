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

## Folder Structure

### Subfolder `glance/`

Implements the Glance feature.

For detailed information, see the folder’s [README](glance/README.md).

### Subfolder `settings/`

Implements the _Settings_ feature.

For detailed information, see the folder’s [README](settings/README.md).

### Subfolder `sitemap/`

Implements the core UI for displaying and interacting with openHAB sitemap content.

This includes:

- The main sitemap menu  
- Menu items representing sitemap elements  
- Full-screen control views for complex interactions  

For detailed information, see the folder’s [README](sitemap/README.md).
