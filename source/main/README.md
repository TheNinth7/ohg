# Folder `main`

Contains the primary application source code shared across all target devices.  
This folder includes the core implementation of the app, covering the data layer, infrastructure services, and the user interface.

While most code in this directory is shared, certain parts are conditionally included or excluded per device using build annotations. Device-specific [constants](../config/README.md) and [themes](../themes/README.md) are maintained separately.

---

## Folder Structure

### Subfolder `data/`

Implements the data layer of the application.

This includes:

- The internal sitemap representation  
- Synchronization with the server (receiving updates and sending commands)  
- Communication handling  
- Persistence of sitemap data in storage  

For more details, see the folder’s [README](data/README.md).

### Subfolder `infrastructure/`

Provides the technical foundation of the application.

It contains the main `OHApp` class responsible for managing the application lifecycle, along with cross-cutting services such as logging, memory management, task coordination, and other shared technical utilities.

For more details, see the folder’s [README](infrastructure/README.md).

### Subfolder `user-interface/`

Contains all presentation-layer code.

This folder defines how the application is rendered and how users interact with it. It includes feature screens, reusable UI components, global fallback states (e.g., error and loading views), and UI-specific infrastructure such as view management and theming.

For more details, see the folder’s [README](user-interface/README.md).
