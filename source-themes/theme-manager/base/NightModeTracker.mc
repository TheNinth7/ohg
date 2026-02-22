import Toybox.Lang;
import Toybox.Graphics;

class NightModeTracker {

    /******* STATIC *******/ 

    private static var _instance as NightModeTracker?;

    public static function get() as NightModeTracker {
        if( _instance == null ) {
            _instance = new NightModeTracker();
        }
        return _instance;
    }

    /******* INSTANCE *******/ 

    private var _isNightModeEnabled as Boolean;

    public function initialize() {
        _isNightModeEnabled = update();
    }

    public function isNightModeEnabled() as Boolean {
        return _isNightModeEnabled;
    }
    
    public function update() as Boolean {
        var deviceSettings = System.getDeviceSettings();
        _isNightModeEnabled = deviceSettings has :isNightModeEnabled && deviceSettings.isNightModeEnabled;
        return _isNightModeEnabled;
    }

}