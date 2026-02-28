# Folder `control`

Contains full-screen control views that provide more advanced interaction models than can be achieved directly within menu items.

These views are used for sitemap elements that require complex input handling, such as selecting numeric values (Setpoint, Slider) or controlling media playback. They allow richer interaction patterns while remaining consistent with the device’s input capabilities.

On button-based devices, full-screen views display visual input hints that indicate the function of each physical button. On button-based devices with touch support, these input hints also react to touch input. On pure touch-based devices, dedicated on-screen buttons are rendered instead.

See the screenshots in the [Setpoint/Slider section](https://next.openhab.org/docs/apps/garmin/#resulting-ui-3) for examples.

---

## Subfolder `base/`

Provides the foundation for all full-screen control views.

It contains the base mechanisms for:

- Layouting drawables  
- Displaying input hints  
- Routing user input  

### Subfolders

- **`base/input-hints/`**  
  Contains classes responsible for rendering input hints—visual indicators that map physical device buttons to actions.

- **`base/touch-area/`**  
  Provides support for defining circular and rectangular touch areas that trigger actions. These integrate with `ControlView` to enable touch interaction.

- **`base/view/`**  
  Defines the `ControlView` base class and the corresponding input delegate used by all full-screen control implementations.

---

## Subfolder `picker/`

Implements a custom replacement for the Garmin SDK’s `Picker`.

The custom implementation (`DynamicPicker`) allows scrolling through and selecting values while overcoming limitations of the native SDK picker (e.g., dynamic option handling and improved interaction behavior).

### Subfolders

- **`picker/base/`**  
  Contains the base implementation, including `DynamicPicker` and its supporting classes.

- **`picker/numeric/`**  
  Provides the concrete implementation for Setpoint and Slider widgets.  
  Allows the user to select a floating-point value from a range defined in the sitemap, based on `DynamicPicker`.

  See the [Setpoint/Slider section](https://next.openhab.org/docs/apps/garmin/#setpoint-and-slider) for usage details and examples.

---

## Subfolder `player/`

Implements `PlayerView`, which enables interaction with media players (play/pause, next/previous) and displays the current playback state.

See the [Player section](https://next.openhab.org/docs/apps/garmin/#player) for usage details and examples.

---

## Subfolder `rollershutter/`

Implements `RollershutterView`, which allows control of a rollershutter (up/down/stop) and displays the current state.

See the [Rollershutter section](https://next.openhab.org/docs/apps/garmin/#rollershutter) for usage details and examples.