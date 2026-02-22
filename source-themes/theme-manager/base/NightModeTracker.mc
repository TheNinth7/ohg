import Toybox.Lang;
import Toybox.Graphics;

/*
 * The NightModeTracker tracks the current night mode state.
 * It is invoked by OHApp.onNightModeChanged() and can be used
 * by ThemeManager implementations to determine whether
 * night mode is active.
 *
 * For performance reasons, this class is implemented as a singleton
 * and caches the current night mode state.
 */
class NightModeTracker {

    /******* STATIC *******/ 

    // Singleton implementation
    private static var _instance as NightModeTracker?;
    public static function get() as NightModeTracker {
        if( _instance == null ) {
            _instance = new NightModeTracker();
        }
        return _instance;
    }

    /******* INSTANCE *******/ 

    // Cached state
    private var _isNightModeEnabled as Boolean;

    // Read the current state
    public function initialize() {
        _isNightModeEnabled = update();
    }

    // Return the current state
    public function isNightModeEnabled() as Boolean {
        return _isNightModeEnabled;
    }
    
    // Update function that is called by OHApp.onNightModeChanged()
    public function update() as Boolean {
        var deviceSettings = System.getDeviceSettings();
        _isNightModeEnabled = deviceSettings has :isNightModeEnabled && deviceSettings.isNightModeEnabled;
        return _isNightModeEnabled;
    }

}