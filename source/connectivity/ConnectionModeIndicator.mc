import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;

/*
 * Drawable for displaying the connection mode indicator.
 * When connected via phone, nothing is shown.
 * When connected via Wi-Fi, a blue Wi-Fi symbol is shown.
 */
class ConnectionModeIndicator extends Bitmap {

    // Constructor
    public function initialize() {
        Bitmap.initialize( { :rezId => Rez.Drawables.iconWifi } );
    }

    // Draw, but only if we are in Wi-Fi mode
    public function draw( dc as Dc ) {
        if( ConnectivityHandler.get().isOnWifiConnection() ) {
            Bitmap.draw( dc );
        }
    }

    // Sets the vertical position.
    // Accepts the y-coordinate of the intended center of the indicator
    // and derives the Drawable's locY value from it.
    public function setCenterY( centerY as Number ) as Void {
        setLocation(
            WatchUi.LAYOUT_HALIGN_CENTER,
            centerY - ( getDimensions()[1] / 2 ).toNumber()
        );
    }
}