import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;

/*
 * Config for the Venu X1.
 */
class Config extends VenuSquareConfig {
    private function initialize() { VenuSquareConfig.initialize(); }

    // The Venu X1 has rounded corners, so we need to indent the
    // connection mode indicator further.
    public static const UI_CONTROL_CMI_RECTANGULAR_HALIGN as Number = 
        ( BaseConfig.UI_SCREEN_WIDTH * 0.09 ).toNumber();

}