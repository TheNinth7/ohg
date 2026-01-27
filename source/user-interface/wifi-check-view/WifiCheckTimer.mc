import Toybox.Timer;
import Toybox.WatchUi;
import Toybox.Lang;

/*
 * Timer task that checks the WiFi connection state and, if WiFi is available,
 * replaces the `WifiCheckView` (when shown) with the menu.
 *
 * `WifiCheckView` is used as the initial view when no phone connection is
 * available, so the user can see that WiFi availability is being checked.
 *
 * Unfortunately, by the time the first availability result comes in, it is
 * too late to return a different initial view from `OhApp.getInitialView()`.
 * At the same time, `WifiCheckView` is not yet fully loaded, so it cannot be
 * replaced immediately either.
 *
 * To work around this, `WifiCheckView` starts this timer from its first
 * `onUpdate()` call and processes the initial availability result there.
 */
class WifiCheckTimer extends Timer.Timer {

    public function initialize() {
        Timer.Timer.initialize();
        Timer.Timer.start( method( :checkWifiState ), 50, false ); 
    }

    public function checkWifiState() as Void {
        // Execute only if we now have a WiFi connection available,
        // the current view is still a WifiCheckView, and
        // we actually have a HomepageMenu to switch to.
        if( ConnectivityHandler.get().isOnWiFiConnection()
            && ViewHandler.getCurrentViewSafe()[0] instanceof WifiCheckView
            && HomepageMenu.exists()
        ) {
            ViewHandler.popToBottomAndSwitch( HomepageMenu.get(), HomepageMenuDelegate.get() );
        }
    }
}