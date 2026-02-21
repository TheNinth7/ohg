import Toybox.Lang;

/*
 * The default `Theme` implementation inherits all default values.
 */
(:glance)
class Theme extends NightModeTheme {
    private function initialize() { NightModeTheme.initialize(); }

    /*
    * In the simulator, the Edge 540 and 840 do not show a focus indicator.
    * Therefore, in debug builds, a colored background is added to make
    * it easier to work with the app in the simulator.
    * On real devices, a focus indicator is present, so coloring the
    * background is not required.
    */
    (:debug)
    public static var focusedMenuItemBackgroundColor as ColorType = menuItemBackgroundColor;
}