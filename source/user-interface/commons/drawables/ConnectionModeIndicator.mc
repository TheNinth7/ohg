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

    // The two location modes
    enum LocationMode {
        LOC_MODE_CENTER_Y,
        LOC_MODE_UPPER_LEFT_CORNER
    }

    // The current location mode
    private var _locMode as LocationMode?;
    
    // The center Y coordinate for the LOC_MODE_CENTER_Y
    private var _centerY as Number = 0;

    // Constructor
    public function initialize() {
        Bitmap.initialize( { :rezId => getResourceId() } );
    }

    // Draw, but only if we are in Wi-Fi mode
    public function draw( dc as Dc ) as Void {
        Bitmap.setBitmap( getResourceId() );

        if( _locMode == LOC_MODE_UPPER_LEFT_CORNER ) {
            var spacing = height * 0.2;
            setLocation( spacing, spacing );
        } else if( _locMode == LOC_MODE_CENTER_Y ) {
            var spacing = _centerY - ( height/ 2 ).toNumber();
            setLocation( WatchUi.LAYOUT_HALIGN_CENTER, spacing );
        } else {
            throw new GeneralException( "ConnectionModeIndicator: location was not set." );
        }
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

    // Activates the Center Y location mode
    public function setCenterY( centerY as Number ) as Void {
        _locMode = LOC_MODE_CENTER_Y;
        _centerY = centerY;
    }

    // Activates the upper left corner location mode
    public function setLocationToUpperLeftCorner() as Void {
        _locMode = LOC_MODE_UPPER_LEFT_CORNER;
    }
}