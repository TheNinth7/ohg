# Folder `base`

Contains foundational base classes for menu items and full-screen control views. Concrete widget implementations build upon these classes to ensure consistent behavior and appearance across the application.

---

## Folder Structure

### Subfolder `control/`

Provides base classes for full-screen control views that support interaction patterns too complex to be handled directly within menu items.

For detailed information, see the folder’s [README](control/README.md).

### Subfolder `menu-items/`

Contains base classes for menu items. Menus represent sitemap pages, while menu items represent the individual widgets. Some widgets allow direct interaction, others open full-screen control views, and some open additional menus or simply display information.

- `WidgetMenuItem`  
  The base class for all widgets. It builds on `StructuredMenuItem` and translates most elements from the data layer into a visual representation, such as icons, display state, and action indicators. It also processes updates and provides extension points for subclasses to react to state changes. Widgets that do not support state changes, such as text items or page links, derive directly from `WidgetMenuItem`.

- `CommandMenuItem`  
  Extends `WidgetMenuItem` and adds the infrastructure required to send commands. It serves as the foundation for interactive widgets such as switches and numeric setpoint or slider controls, essentially any widget that allows the user to modify state.