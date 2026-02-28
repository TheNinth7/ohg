# Folder `communications`

Responsible for all communication with the openHAB server.

This folder contains the connection management logic, HTTP request handling and persistence mechanisms required to keep the application state in sync with openHAB.

---

## Subfolder Structure

### Subfolder `connection/`

Contains the `ConnectionManager`, which tracks the currently available connection type (BLE vs. Wi-Fi) and manages transitions between normal, degraded (Wi-Fi), and offline modes.

For more details on connection behavior, see the [Network Access](https://next.openhab.org/docs/apps/garmin/#network-access) section of the user manual.

---

### Subfolder `sync-delegates/`

Implements Wi-Fi-based synchronization used when no BLE connection is available.

Sync delegates are responsible for sending commands and updating the sitemap over Wi-Fi. They coordinate communication logic while delegating actual HTTP request execution to the `web-requests` package.

#### Further Reading

- [User Manual – Network Access](https://next.openhab.org/docs/apps/garmin/#network-access)  
- [Connect IQ 3.1 Announcement](https://forums.garmin.com/developer/connect-iq/b/news-announcements/posts/connect-iq-3-1-connects-you-to-the-world)  
  Introduces SyncDelegate support and provides basic guidance on implementing Wi-Fi synchronization.
- [Connect IQ API Docs – `Toybox.Communications.SyncDelegate`](https://developer.garmin.com/connect-iq/api-docs/Toybox/Communications/SyncDelegate.html)  
  
### Subfolder `web-requests/`

Implements communication with the openHAB server using the Connect IQ SDK’s `Toybox.Communications` module.

These requests are used for both BLE communication and Wi-Fi mode. In addition to sending and receiving data, this layer is responsible for processing server responses—for example, initializing a new sitemap and forwarding it to the user interface.

#### Subfolders

- **`web-requests/base/`**  
  Contains `BaseRequest`, the abstract base class for all HTTP requests.  
  Provides shared functionality such as applying basic authentication and validating HTTP response codes.

- **`web-requests/command/`**  
  Implements requests for sending commands to openHAB.  
  Supports both:
  - The JSON-based REST API (available in openHAB 5 and backported to openHAB 4.3.x)
  - A custom webhook integration  

- **`web-requests/sitemap/`**  
  Handles sitemap retrieval, polling, and processing.  
  `SitemapRequest` periodically fetches sitemap data from openHAB and processes the retrieved JSON representation.
  To keep the UI responsive and avoid limitations such as the Watchdog timeout for long-running code and stack size restrictions caused by recursive processing, responses are processed asynchronously and non-recursively. The work is split into small tasks that are executed by the task queue implementation.

#### Further Reading

- [User Manual – Sending Commands](https://next.openhab.org/docs/apps/garmin/#sending-commands-2)  
- [Connect IQ Core Topics – HTTPS Requests](https://developer.garmin.com/connect-iq/core-topics/https/)  
- [Connect IQ API Docs – `Toybox.Communications`](https://developer.garmin.com/connect-iq/api-docs/Toybox/Communications.html)
