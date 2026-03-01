# Folder `user-interface`

Contains the complete presentation layer of the application.

This directory defines how the app is rendered and how users interact with it. It includes feature implementations, reusable UI components, fallback views, abstract base classes, and the internal runtime mechanisms required to coordinate UI behavior.

---

## Folder Structure

### Subfolder `fallbacks/`

Contains components responsible for fallback behavior, such as error handling and the loading view.

These classes are used when normal feature rendering cannot proceed (e.g., due to communication failures or missing data). They ensure that the application remains robust and provides meaningful feedback to the user.

For more details, see the folder’s [README](fallbacks/README.md).

### Subfolder `features/`

Implements the main user-facing features of the application.

The current feature categories are:

- **Glance** – A compact view shown in the device’s glance carousel  
- **Settings** – A menu providing status information and maintenance actions  
- **Sitemap** – The core feature of the app, displaying and enabling interaction with openHAB sitemap elements  

For more details, see the folder’s [README](features/README.md).

### Subfolder `shared/`

Contains reusable UI components that are used across multiple features.

These classes represent visible UI elements or composable building blocks that can be rendered in different contexts.

For more details, see the folder’s [README](shared/README.md).

### Subfolder `ui-infrastructure/`

Contains central, stateful runtime facilities that support the user interface.

These are not reusable helper functions or visual components. Instead, they provide shared management services accessed by all UI modules, such as view stack coordination, resource caching, and dynamic UI state tracking (e.g., night mode).

Unlike `shared`, which provides reusable UI components, `ui-infrastructure` implements the underlying mechanisms that coordinate and maintain global UI behavior.

For more details, see the folder’s [README](ui-infrastructure/README.md).
