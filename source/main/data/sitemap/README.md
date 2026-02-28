# Folder `sitemap`

Defines the data model used to parse and represent sitemap content received from openHAB.

The classes in this folder convert the JSON representation delivered by openHAB into a structured object model. This model serves as the foundation for building and rendering the user interface.

**Further Reading**

- [User Manual – Sitemap Setup](https://next.openhab.org/docs/apps/garmin/#sitemap-setup)  

---

## Subfolder Structure

### Subfolder `base/`

Contains `SitemapElement.mc`, the abstract base class for all sitemap elements.

It defines shared properties and common parsing logic used by all concrete sitemap element types.

---

### Subfolder `json/`

The Connect IQ API delivers JSON data as a dictionary.  
`JsonObjectAdapter` provides type-safe accessors for retrieving objects, arrays, strings, numbers, and booleans from the JSON structure.

This layer isolates JSON handling details from the higher-level sitemap model.

---

### Subfolder `pages/`

Contains classes representing the **content** of container-type sitemap elements (e.g., frames or groups).

These classes model the internal structure and child elements of a container. They do not represent the container widget itself, but rather the content that is displayed within it.

To keep the UI responsive and avoid limitations such as the Watchdog timeout for long-running code and stack size restrictions caused by recursive processing, pages are processed asynchronously and non-recursively. The work is split into small tasks that are executed by the task queue implementation.

---

### Subfolder `widgets/`

Contains `SitemapElement` subclasses representing concrete sitemap widgets, such as switches, sliders, text labels, and container elements.

For container-type elements (e.g., frames or groups), the widget class describes the container itself and links to the corresponding implementation in `pages/` to represent its content.

#### Subfolders

- **`base/`**  
  Contains `SitemapWidget`, the base class for all widget-type elements.  
  Also includes the `Item` base class representing an openHAB item, as well as helper classes for parsing colors and icons.

- **`factory/`**  
  Contains `SitemapWidgetFactory`, responsible for instantiating the appropriate `SitemapElement` subclass based on a given JSON object.

- **Concrete widget directories**  
  Each directory implements specific sitemap element types.

  In some cases, the `SitemapWidgetFactory` maps multiple openHAB sitemap element types to a single implementation.  
  For example, `numeric/` handles both *Setpoint* and *Slider* elements.
