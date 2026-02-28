# Folder `sitemap`

Implements the core UI for displaying and interacting with openHAB sitemap content.

This feature represents the main functionality of the app. It renders the sitemap structure as a navigable menu hierarchy, displays item states, and enables user interaction through direct commands or full-screen control views.

This includes:

- The main sitemap menu  
- Menu items representing sitemap elements  
- Full-screen control views for advanced interactions  

---

## Subfolder `command-selection/`

Implements a command selection menu used when multiple commands must be presented to the user.

This is required, for example:

- For generic switches with more than two possible commands  
- In Wi-Fi mode for on/off switches, where the current state is unknown and both options must be presented  

### Platform-Specific Implementation

- **Watches**  
  Use the native CIQ `ActionMenu`. Only a custom `CommandActionMenuDelegate` is required.

- **Edge cycling computers**  
  The `ActionMenu` is not available. Therefore, a full-screen `CommandMenu` based on `BaseMenu` is implemented, similar to the sitemap and settings menus.

---

## Subfolder `control/`

Contains full-screen control views for more complex interaction patterns than can be supported directly within menu items.

Examples include:

- Numeric pickers for `Setpoint` and `Slider` elements  
- Media player controls  

For detailed information, see the folder’s [README](control/README.md).

---

## Subfolder `menu/`

Implements the main sitemap menu that renders the sitemap hierarchy.

The initial menu structure is created from the sitemap stored in persistent storage or from the first sitemap received via the network. After initialization, the menu can be updated using the `update()` function.

Updates apply not only to item states but also to structural changes, such as adding or removing menu items when the sitemap definition changes.

### Subfolders

- **`menu/base/`**  
  Contains `BasePageMenu`, which extends `BaseMenu` and provides the logic for displaying a list of sitemap elements at a specific hierarchy level.

  To keep the UI responsive and avoid stack size limits caused by recursive calls, menu initialization and updates are processed asynchronously in small, non-recursive tasks.

- **`menu/homepage/`**  
  Implements `HomepageMenu`, representing the root level (_Homepage_) of the sitemap.

- **`menu/page/`**  
  Implements `PageMenu`, representing sitemap frames or folder-like elements.

Each menu has a corresponding input delegate.  
Exclusion annotations in `HomepageMenu` and `HomepageMenuDelegate` enable the platform-specific _Settings_ menu behavior.

---

## Subfolder `menu-items/`

Contains the concrete implementations of sitemap menu items (analogous to openHAB widgets).

`factory/MenuItemFactory` determines which menu item class to instantiate for a given `SitemapElement`.

### Key Concepts

- **MenuItem classes** (e.g., `OnOffSwitchMenuItem`) implement interactive list entries.  
- **Drawable classes** render visual components (e.g., `OnOffStatusDrawable` for switch indicators).

The base class `base/BaseSitemapMenuItem` defines the common layout and structure of all menu items, including:

- An optional left-side icon (`Drawable`)  
- A central text label  
- An optional right-side text state  
- An optional right-side bitmap status indicator (via a `Drawable`)  
- An optional action indicator signaling that the item is actionable or opens another page  

Apart from the label, all elements are optional and can be combined depending on the widget’s requirements.

In addition to visual representation, menu items handle user input and execute commands using a `CommandRequest`.  
If a full-screen control view is opened, that view delegates command execution back to the associated menu item.

### Subfolders

- **`menu-items/base/`**  
  - `BaseSitemapMenuItem` – Implements shared visual structure and layout logic  
  - `BaseWidgetMenuItem` – Bridges sitemap data-layer widgets to their UI representation  

- **`menu-items/container/`**  
  Menu items representing sitemap page elements such as `Frame` or `Group`.

- **`menu-items/factory/`**  
  Contains `MenuItemFactory`, responsible for instantiating the correct menu item for a given sitemap element.

- **`menu-items/numeric/`**  
  Implements menu items for `Setpoint` and `Slider` elements.

- **`menu-items/settings/`**  
  Contains the _Settings_ entry shown on touch-based devices.

- **`menu-items/switch/`**  
  Implements menu items for `Switch` elements.

- **`menu-items/text/`**  
  Implements menu items for `Text` elements.
