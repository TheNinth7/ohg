# Folder `shared`

Contains shared components used within the sitemap UI

---

## Folder Structure

### Subfolder `command-selection/`

Implements a command selection menu used when multiple commands must be presented to the user.

This is required, for example:

- For generic switches with more than two possible commands  
- In Wi-Fi mode for on/off switches, where the current state is unknown and both options must be presented  

#### Platform-Specific Implementation

- **Watches**  
  Use the native CIQ `ActionMenu`. Only a custom `CommandActionMenuDelegate` is required.

- **Edge cycling computers**  
  The `ActionMenu` is not available. Therefore, a full-screen `CommandMenu` based on `BaseMenu` is implemented, similar to the sitemap and settings menus.

### Subfolder `picker/`

Implements a custom replacement for the Garmin SDK’s `Picker`.

The custom implementation (`DynamicPicker`) allows scrolling through and selecting values while overcoming limitations of the native SDK picker (e.g., dynamic option handling and improved interaction behavior).

#### Folder Structure

- **`picker/base/`**  
  Contains the base implementation, including `DynamicPicker` and its supporting classes.

- **`picker/numeric/`**  
  Provides the concrete implementation for Setpoint and Slider widgets.  
  Allows the user to select a floating-point value from a range defined in the sitemap, based on `DynamicPicker`.

  See the [Setpoint/Slider section](https://next.openhab.org/docs/apps/garmin/#setpoint-and-slider) for usage details and examples.
