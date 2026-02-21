import Toybox.Lang;

/*
* Constants for the Forerunner series.
*/
class Constants extends DefaultConstants {
    protected function initialize() { DefaultConstants.initialize(); }
    
    // Positions of the keys, for drawing input hints
    // Corresponds to CustomView.InputHints enumeration
    // 0=ENTER
    // 1=BACK
    public static const UI_INPUT_HINT_POSITIONS as Array<Number> = [25, 330];
}