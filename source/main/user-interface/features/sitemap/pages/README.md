# Folder `pages`

Implements the main sitemap menu that renders the sitemap hierarchy.

The initial menu structure is created from the sitemap stored in persistent storage or from the first sitemap received via the network. After initialization, the menu can be updated using the `update()` function.

Updates apply not only to item states but also to structural changes, such as adding or removing menu items when the sitemap definition changes.

---

## Folder Structure

### Subfolder `base/`

Contains `BasePageMenu`, which extends `BaseMenu` and provides the logic for displaying a list of sitemap elements at a specific hierarchy level.

To keep the UI responsive and avoid stack size limits caused by recursive calls, menu initialization and updates are processed asynchronously in small, non-recursive tasks.

### Subfolder `homepage/`

Implements `HomepageMenu`, representing the root level (_Homepage_) of the sitemap.

### Subfolder `page/`

Implements `PageMenu`, representing sitemap frames or folder-like elements.

Each menu has a corresponding input delegate.  
Exclusion annotations in `HomepageMenu` and `HomepageMenuDelegate` enable the platform-specific _Settings_ menu behavior.
