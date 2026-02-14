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

    // Constructor
    public function initialize() {
        Bitmap.initialize( { :rezId => getResourceId() } );

        if( System.getDeviceSettings().screenShape == Toybox.System.SCREEN_SHAPE_RECTANGLE ) {
            var spacing = height * 0.2;
            setLocation( spacing, spacing );
        } else {
            var spacing = height * 0.5;
            setLocation( WatchUi.LAYOUT_HALIGN_CENTER, spacing );
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
        if( ConnectivityHandler.get().isOnWifiConnection() ) {
            return Rez.Drawables.iconWifi;
        } else {
            return Rez.Drawables.iconBluetooth;
        }
    }
}