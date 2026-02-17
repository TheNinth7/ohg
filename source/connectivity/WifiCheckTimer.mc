import Toybox.Timer;
import Toybox.WatchUi;
import Toybox.Lang;

/*
 * Processing the result of a Wi-Fi availability check requires a view to be loaded.
 * However, if a check is triggered during startup, the result may return before
 * the WifiCheckView is loaded as the initial view; in that case, processing is
 * deferred.
 *
 * This timer task therefore checks whether the initial view has already been
 * loaded and then processes the deferred result.
 *
 * The timer is started in WifiCheckView.onUpdate(), because the view is only
 * considered loaded after that.
 */
/*
class WifiCheckTimer extends Timer.Timer {
    public function initialize() {
        Timer.Timer.initialize();
        startTimer();
    }

    private function startTimer() as Void {
        Timer.Timer.start( method( :checkWifiState ), 50, false );
    }

    public function checkWifiState() as Void {
        // If there is a view now, we process the deferred result,
        // otherwise restart the timer
        if( ViewHandler.getCurrentViewSafe()[0] != null ) {
            ConnectivityHandler.get().processDeferredResult();
        } else {
            startTimer();
        }
    }
}
*/