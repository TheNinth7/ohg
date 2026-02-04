import Toybox.WatchUi;
import Toybox.Lang;

class WifiIndicatorLayer extends Layer {
    public function initialize() {
        var width = System.getDeviceSettings().screenWidth;
        var height = System.getDeviceSettings().screenHeight;

        Layer.initialize( {
            :width => width,
            :height => height
        } );

        var dc = getDc();

        if( dc != null ) {
            dc.setColor( Constants.UI_COLOR_WIFI, Graphics.COLOR_TRANSPARENT );
            dc.clear();
            dc.setPenWidth( 4 );
            dc.drawCircle( width / 2, height / 2, ( width / 2 ) - 2 );
        }
    }
}