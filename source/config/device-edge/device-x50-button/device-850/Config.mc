import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
* Config specific to button-based Edge devices.
*/
class Config extends EdgeX50ButtonBaseConfig {
    protected function initialize() { EdgeX50ButtonBaseConfig.initialize(); }

    // The following two constants control the workaround for a firmware bug on the
    // Edge 550 and 850 that prevents the focus indicator from being rendered properly.
    //
    // On these devices, the native focus indicator is a frame drawn on top of the
    // menu item in the system-defined background color (which cannot be changed
    // from the CIQ app). The frame adapts to the system’s dark and light display modes.
    //
    // The intended behavior is that the CIQ app fills the menu item with a contrasting
    // color to highlight the focused item. However, CustomMenuItem.isFocused() is
    // faulty on these devices, so this mechanism does not work as expected.
    //
    // On the Edge 550, the standard focus indicator is suppressed and the
    // alternate focus indicator is shown instead.
    //
    // On the Edge 850, only the standard focus indicator is suppressed.
    // The alternate focus indicator is not used because it is visually
    // unappealing and difficult to notice.
    //
    // If touch input is available as an alternative input method, we assume
    // the user will use touch interaction, which does not require a focus
    // indicator.
    //
    // See also:
    // Bug report: https://github.com/openhab/openhab-garmin/issues/267
    // Workaround implementation: https://github.com/openhab/openhab-garmin/issues/268
    (:debug)
    public static const UI_MENU_FOCUS_EDGEX50_SUPRESS_FOCUS_INDICATOR as Boolean = false;
    (:release)
    public static const UI_MENU_FOCUS_EDGEX50_SUPRESS_FOCUS_INDICATOR as Boolean = true;

}