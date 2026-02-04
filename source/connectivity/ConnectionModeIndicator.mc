/*
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;

class ConnectionModeIndicator extends BufferedBitmapDrawable {

    private static var _instance as ConnectionModeIndicator?;

    public static function drawIndicator( dc as Dc ) as Void {
        if( _instance == null ) {
            _instance = new ConnectionModeIndicator();
        }
        _instance.draw( dc );
    }

    private var _bufferedBitmap as BufferedBitmapType;

    public function initialize() {

        _bufferedBitmap = BufferedBitmapFactory.createBufferedBitmap( {
            :width => System.getDeviceSettings().screenWidth, 
            :height => System.getDeviceSettings().screenHeight, 
        } );

        BufferedBitmapDrawable.initialize( {
            :bufferedBitmap => _bufferedBitmap,
            :locX => 0, 
            :locY => 0 
        } );

        var dc = _bufferedBitmap.getDc();
        dc.setColor( Constants.UI_COLOR_WIFI, Graphics.COLOR_TRANSPARENT );
        dc.clear();
        dc.setPenWidth( Constants.UI_CONNECTION_MODE_INDICATOR_WIDTH );
        var offset = Constants.UI_CONNECTION_MODE_INDICATOR_WIDTH/2;
        if( System.getDeviceSettings().screenShape == Toybox.System.SCREEN_SHAPE_RECTANGLE ) {
            dc.drawRectangle( offset, offset, width-offset, height-offset );
        } else {
            dc.drawCircle( width/2, height/2, ( width/2 ) - offset );
        }
    }

    public function draw( dc as Dc ) {
        if( ConnectivityHandler.get().isOnWifiConnection() ) {
            BufferedBitmapDrawable.draw( dc );
        }
    }
}
*/