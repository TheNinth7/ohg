import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;

/*
 * Drawable that displays the connection mode indicator.
 *
 * When connected via phone, it shows a green Bluetooth icon.
 * When connected via Wi-Fi, it shows a red Bluetooth icon and a blue Wi-Fi symbol.
 *
 * The drawable supports two positioning modes:
 * - setCenterY: for round screens. Centers the icon horizontally and places it
 *   at the given vertical coordinate.
 * - setLocationUpperLeftCorner: for rectangular screens. Places the icon in the
 *   upper-left corner with some padding.
 */
class ConnectionModeIndicator extends Bitmap {

    enum Location {
        LOCATION_MENU,
        LOCATION_CUSTOM_VIEW
    }

    // Constructor
    public function initialize( location as Location ) {
        Bitmap.initialize( { :rezId => getResourceId() } );

        if( System.getDeviceSettings().screenShape == Toybox.System.SCREEN_SHAPE_RECTANGLE ) {
            var spacing = height * 0.2;
            setLocation( spacing, spacing );
        } else {
            var locYFactor = 
                location == LOCATION_MENU
                ? 0.05
                : 0.02;
            setLocation( 
                WatchUi.LAYOUT_HALIGN_CENTER, 
                Constants.UI_SCREEN_HEIGHT * locYFactor
            );
        }
    }

    // Draw, but only if we are in Wi-Fi mode
    public function draw( dc as Dc ) as Void {
        Bitmap.setBitmap( getResourceId() );

        Bitmap.draw( dc );
    }

    // Retrieves the ResourceId of the icon that shall be shown,
    // based on the current connection mode
    private function getResourceId() as ResourceId {
        switch( ConnectivityHandler.get().getState() ) {
            case ConnectivityHandler.PHONE_CONNECTION:
                return Rez.Drawables.iconConnectionModeBluetooth;
            case ConnectivityHandler.WIFI_CONNECTION:
                return Rez.Drawables.iconConnectionModeWifi;
            case ConnectivityHandler.WIFI_CHECK_PENDING:
                return Rez.Drawables.iconConnectionModeWifiCheckPending;
            default:
                if( ConnectivityHandler.get().hasWifiCapability() ) {
                    return Rez.Drawables.iconConnectionModeOfflineWifi;
                } else {
                    return Rez.Drawables.iconConnectionModeOffline;
                }
        }
    }
}