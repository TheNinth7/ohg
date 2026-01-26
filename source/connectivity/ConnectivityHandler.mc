import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;

/*
 * This singleton class keeps track of the current connectivity state.
 *
 * Connectivity is driven by sitemap requests. On startup, the
 * ConnectivityHandler assumes that a phone connection is available
 * (PHONE_CONNECTION).
 *
 * If a sitemap request fails because the phone is not connected,
 * the SitemapRequest asks the ConnectivityHandler to check WiFi
 * availability. The connectivity state then transitions to
 * WIFI_CHECK_PENDING.
 *
 * If WiFi is available, the state moves to WIFI_CONNECTION.
 * Otherwise, it transitions to OFFLINE.
 *
 * The sitemap request continues to execute, and the connectivity
 * state is updated accordingly.
 */
 public class ConnectivityHandler {

    /******* STATIC *******/ 

    // Singleton instance and accessor
    private static var _instance as ConnectivityHandler?;

    public static function get() as ConnectivityHandler {
        if( _instance == null ) {
            _instance = new ConnectivityHandler();
        }
        return _instance as ConnectivityHandler;
    }

    /******* INSTANCE *******/ 

    // The four connectivity states
    public enum State {
        PHONE_CONNECTION,
        WIFI_CHECK_PENDING,
        WIFI_CONNECTION,
        OFFLINE
    }

    // The current state
    private var _state as State = PHONE_CONNECTION;
    
    // This is called by `SitemapRequest`, indicates that no phone 
    // connection is available and triggers a check of WiFi availability.
    public function checkWifiConnection() as Void {
        if( _state == PHONE_CONNECTION ) {
            setState( WIFI_CHECK_PENDING );
        }
        Communications.checkWifiConnection( method( :connectionStatusCallback ) );
    }

    // This is called by `SitemapRequest` and indicates that phone
    // connection is currently available
    public function confirmPhoneConnection() as Void {
        setState( PHONE_CONNECTION );
    }

    // Processes the result of the WiFi availability check.
    // Depending on the outcome, the displayed view is updated
    // and sitemap states are invalidated if necessary.
    public function connectionStatusCallback( 
        result as { 
            :wifiAvailable as Lang.Boolean, 
            :errorCode as Communications.WifiConnectionStatus 
        } 
    ) as Void {
        try {
            // If since the request was made the state has been changed
            // back to PHONE_CONNECTION, we ignore the result
            if( _state != PHONE_CONNECTION ) {
                
                // If WiFi is available ...
                if( result[:wifiAvailable] == true ) {
                    
                    // ... and that was previously unknown ...
                    if( _state != WIFI_CONNECTION ) {

                        // ... we update the state.
                        setState( WIFI_CONNECTION );

                        // Only if a HomepageMenu is available ...
                        if( HomepageMenu.exists() ) {
                            var menu = HomepageMenu.get();

                            // Check if error or WiFi check view is displayed
                            var currentView = ViewHandler.getCurrentViewSafe()[0];
                            var isMenuView = ErrorView.isShowing() 
                                            || currentView instanceof WifiCheckView;
                            var isMenuViewOrNull = isMenuView || currentView == null;

                            // ... we invalidate the values if the sitemap is not fresh ...
                            if( ! SitemapStore.isSitemapFresh() ) {
                                var sitemap = SitemapStore.getSitemapFromMemory();
                                if( sitemap != null ) {
                                    menu.update( sitemap );
                                    if( ! isMenuView ) {
                                        WatchUi.requestUpdate();
                                    }
                                } else {
                                    throw new GeneralException( "Failed to invalidate menu states because no sitemap is loaded in memory." );
                                }
                            }

                            // ... and if it is not shown, then show it
                            if( isMenuViewOrNull ) {
                                ViewHandler.popToBottomAndSwitch( menu, HomepageMenuDelegate.get() );
                            }
                        } else {
                            // Currently we only throw an exception if there is no sitemap
                            // data available. This will be changed to do a WiFi sitemap request
                            throw new GeneralException( "No sitemap in storage, sync via phone first." );
                        }
                    }
                } else {
                    
                    // If the state changed to OFFLINE ...
                    if( _state != OFFLINE ) {
                        setState( OFFLINE );

                        // ... and the sitemap is not fresh anymore, we show an 
                        // error. Therefore the error is not shown immediately but
                        // only at the treshold configured in the Constants (currently
                        // 10 seconds)
                        if( ! SitemapStore.isSitemapFresh() ) {
                            ErrorView.showOrUpdate( new OfflineException() );
                        }
                    }
                }
            }
        } catch( ex ) {
            ExceptionHandler.handleException( ex );
        }
    }

    // Called by `OhApp` during startup to determine whether
    // any special connectivity handling is required.
    // Returns a WifiCheckView if a WiFi check is pending,
    // and throws an OfflineException if there is no connectivity.
    // In all other cases, it returns null, indicating that `OhApp`
    // can assume full connectivity.
    public function ensureConnectivity() as WifiCheckView? {
        if( _state == WIFI_CHECK_PENDING ) {
            return new WifiCheckView();
        } else if (_state == OFFLINE ) {
            throw new OfflineException();
        } else {
            return null;
        }
    }

    // Returns the state
    public function getState() as State {
        return _state;
    }

    // Returns a textual description of the current state
    public function getStateDescription() as String {
        switch( _state ) {
            case PHONE_CONNECTION: return "Phone";
            case WIFI_CHECK_PENDING: return "Checking WiFi availablity ...";
            case WIFI_CONNECTION: return "WiFi";
            case OFFLINE: return "Offline";
            default: return "Invalid";
        }
    }

    // Internal functions used to update the connectivity state.
    // In addition to storing the new state, they trigger a UI update
    // if the settings menu is currently displayed, since that menu
    // shows the current connectivity mode.
    private function setState( state as State ) as Void {
        _state = state;
        if( SettingsMenuHandler.isShowingSettings() ) {
            WatchUi.requestUpdate();
        }
    }
}