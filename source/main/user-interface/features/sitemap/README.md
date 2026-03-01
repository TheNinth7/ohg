# Folder `sitemap`

Implements the core UI for displaying and interacting with openHAB sitemap content.

This module represents the main functionality of the app. It renders the sitemap structure as a navigable menu hierarchy, displays item states, and enables user interaction either through direct commands or dedicated full-screen control views.

This includes:

- The main sitemap menu  
- Menu items representing sitemap elements  
- Full-screen control views for advanced interactions  

---

## Subfolder `base/`

Contains base classes for menu items and full-screen control views from which the concrete widget implementations are derived.

For detailed information, see the folder’s [README](base/README.md).

---

## Subfolder `pages/`

Implements the main sitemap menu that represents sitemap pages and renders the hierarchical navigation structure.

For detailed information, see the folder’s [README](pages/README.md).

---

## Subfolder `shared/`

Contains shared components used within the sitemap UI, such as the command selection menu and a full-screen value picker that replaces the standard CIQ picker with a custom implementation.

For detailed information, see the folder’s [README](shared/README.md).

---

## Subfolder `widgets/`

Contains the concrete widget implementations. Each widget is implemented as a menu item. Some widgets additionally provide command selection menus or full-screen control views that are opened when the menu item is selected.

This folder also includes the factory responsible for instantiating the correct menu item for a given sitemap element from the data layer.

For detailed information, see the folder’s [README](widgets/README.md).