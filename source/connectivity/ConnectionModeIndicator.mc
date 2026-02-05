import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;

class ConnectionModeIndicator extends Bitmap {

    public function initialize() {
        Bitmap.initialize( { :rezId => Rez.Drawables.iconWifi } );
    }

    public function draw( dc as Dc ) {
        if( ConnectivityHandler.get().isOnWifiConnection() ) {
            Bitmap.draw( dc );
        }
    }

    public function setCenterY( centerY as Number ) as Void {
        setLocation(
            WatchUi.LAYOUT_HALIGN_CENTER,
            centerY - ( getDimensions()[1] / 2 ).toNumber()
        );
    }
}