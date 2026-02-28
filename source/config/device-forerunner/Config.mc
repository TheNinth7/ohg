import Toybox.Lang;

/*
* Config for the Forerunner series.
*/
class Config extends BaseConfig {
    protected function initialize() { BaseConfig.initialize(); }
    
    // Positions of the keys, for drawing input hints
    // Corresponds to BaseControlView.InputHints enumeration
    // 0=ENTER
    // 1=BACK
    public static const UI_INPUT_HINT_POSITIONS as Array<Number> = [25, 330];
}