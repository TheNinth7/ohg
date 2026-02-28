# Folder `/source`

This folder contains the source code of the app, written in **Monkey C**, Garmin’s programming language. It uses the Connect IQ SDK for user interface components, application settings, persistent storage, and HTTP communication with the openHAB server.

---

## Key Concepts

### **Annotations**

- `(:glance)` marks code that must be included in the _Glance_ view.
- Exclude annotations are used to tailor the code for each target device. See the [`monkey.jungle`](../README.md#root-folder-) file in the root directory for details.

### **Inline Documentation**

All `.mc` files include inline comments and documentation describing the purpose and internal workings of each class.

### **Further Reading**

- [Connect IQ Core Topics](https://developer.garmin.com/connect-iq/core-topics/)
- [Connect IQ API Docs](https://developer.garmin.com/connect-iq/api-docs/)

---

## Folder Structure

### Root Folder `/`

Contains the `OHApp` class, the main entry point for the app. It handles:

- Initialization of the initial view in both _Glance_ and _Widget_ modes
- Startup and shutdown logic
- Reactions to app updates and settings changes

---

### Folder `exceptions`

Defines all custom exception types used by the app. All exception classes extend the base class `GeneralException`.

---

### Folder `logging`

Contains the `Logger` class, which provides utility methods to output debug statements and exceptions to the system log.

---

### Folder `settings`

Includes the `AppSettings` class, which reads, validates, and exposes application settings through static accessor methods.

**Related Resources:**

- [Connect IQ SDK Core Topics – Resources](https://developer.garmin.com/connect-iq/core-topics/resources/)
- [Connect IQ API Docs – `Toybox.Application.Properties`](https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/Properties.html)
- See also: [Folder `resources`](https://github.com/TheNinth7/ohg#folder-resources)

---

### Folder `sitemap`

This folder defines the data model for parsing and representing sitemap content from openHAB. It forms the foundation for building the user interface menus. The following subdirectories and files are included:

- `base/SitemapElement`: The abstract base class for all sitemap elements.
- `factory/SitemapElementFactory`: Responsible for instantiating the appropriate `SitemapElement` subclass from a JSON representation of a sitemap element.
- `item-descriptions`: Contains classes that model the state and command descriptions of openHAB items.
- `sitemap-pages`: Contains `SitemapElement` subclasses that act as containers, grouping other sitemap elements (e.g., frames, groups).
- `sitemap-primitives`: Contains `SitemapElement` subclasses representing basic UI components such as switches, sliders, and text labels.

---

### Folder `storage`

Handles reading from and writing to persistent storage. As of now, the following data is stored:

- **JSON Dictionary**: Caches the latest sitemap data for use on app startup.
- **Sitemap Label**: Stored for display by the _Glance_, in case the sitemap cannot be loaded due to memory constraints.
- **Sitemap Error Count**: Tracks non-fatal communication errors across _Glance_ and _Widget_ modes. If errors persist, they are escalated to fatal errors. This count is preserved across sessions and shared between both app modes.

**Related Resources:**

- [Connect IQ Core Topics – Persisting Data](https://developer.garmin.com/connect-iq/core-topics/persisting-data/)
- [Connect IQ API Docs – `Toybox.Application.Storage`](https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/Storage.html)

---

### Folder `user-interface`

Contains all user interface implementations. For detailed documentation, see the folder’s [README](https://github.com/TheNinth7/ohg/tree/main/source/user-interface#folder-user-interface).

---

### Folder `web-requests`

Implements communication with the openHAB server using the Connect IQ SDK's `Communication` module.

#### Subfolders:

- **`base/`**
  Contains `BaseRequest`, the base class for all HTTP requests. It includes shared logic such as applying basic authentication and checking HTTP response codes.

- **`command/`**
  Implements requests for sending commands to openHAB. Supports both:

  - The JSON-based REST API (available in openHAB 5 and as a backport for openHAB 4.3.x)
  - A custom webhook integration
    _(See the user manual for configuration details.)_

- **`sitemap/`**
  Handles sitemap retrieval, polling, and processing logic:

  - `SitemapRequest`: Periodically fetches sitemap data from openHAB and triggers its processing.
  - `SitemapProcessor` and `SitemapProcessorTasks`: Process the retrieved sitemap data and act as the interface between `SitemapRequest` and the menu update logic in `/user-interface/sitemap-menu`.

**Further reading:**

- [Connect IQ Core Topics - JSON REST Requests](https://developer.garmin.com/connect-iq/core-topics/https/)  
- [Connect IQ API Docs - `Toybox.Communications`](https://developer.garmin.com/connect-iq/api-docs/Toybox/Communications.html)
