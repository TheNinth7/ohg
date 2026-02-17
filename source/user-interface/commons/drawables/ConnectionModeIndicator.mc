import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

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
class ConnectionModeIndicator extends BufferedBitmapDrawable {

    enum Location {
        LOCATION_MENU,
        LOCATION_CUSTOM_VIEW
    }

    private static var _bufferedBitmap as BufferedBitmapType?;

    private static function getBufferedBitmap() as BufferedBitmapType {
        if( _bufferedBitmap == null ) {
            _bufferedBitmap = createOrUpdate();
        }
        return _bufferedBitmap;
    }

    private static function createOrUpdate() as BufferedBitmap {
        var elements = new Array<Drawable>[0];

        elements.add( getStateIcon() );
        elements.add( getBluetoothIcon() );
        var wifi = getWifiIcon();
        if( wifi != null ) {
            elements.add( wifi );
        }

        var width = 0;
        var height = 0;
        var spacing = ( System.getDeviceSettings().screenWidth * 0.025 ).toNumber();

        for( var i = 0; i < elements.size(); i++ ) {
            var element = elements[i];
            height = CustomMath.max( height, element.height ).toNumber();
            width += ( element.width ).toNumber();
            if( i > 0 ) {
                width += spacing;
            }
        }

        var bufferedBitmap = BufferedBitmapFactory.createBufferedBitmap( {
            :height => height,
            :width => width
        } );

        var dc = bufferedBitmap.getDc();

        var locX = 0;

        for( var i = 0; i < elements.size(); i++ ) {
            var element = elements[i];
            element.setLocation( locX, WatchUi.LAYOUT_VALIGN_CENTER );
            element.draw( dc );
            locX += element.width + spacing;
        }

        return bufferedBitmap;
    }

    private static function getStateIcon() as Drawable {
        var ch = ConnectionHandler.get();
        var rezId;
        if( ch.isBluetoothConnected() ) {
            rezId = Rez.Drawables.iconConnStateGreen;
        } else if( ch.isOffline() ) {
            rezId = Rez.Drawables.iconConnStateRed;
        } else {
            rezId = Rez.Drawables.iconConnStateYellow;
        }
        return new Bitmap( { :rezId => rezId } );
    }

    private static function getBluetoothIcon() as Drawable {
        var rezId;
        if( ConnectionHandler.get().isBluetoothConnected() ) {
            rezId = Rez.Drawables.iconBluetoothOn;
        } else {
            rezId = Rez.Drawables.iconBluetoothOff;
        }
        return new Bitmap( { :rezId => rezId } );
    }

    private static function getWifiIcon() as Drawable? {
        var ch = ConnectionHandler.get();
        if( ! ch.isBluetoothConnected() && ch.hasWifiCapability() ) {
            var rezId;
            if( ch.isWifiConnected() ) {
                rezId = Rez.Drawables.iconWifiOn;
            } else if( ch.get().hasWifiCheckPending() ) {
                rezId = Rez.Drawables.iconWifiCheck;
            } else {
                rezId = Rez.Drawables.iconWifiOff;
            }
            return new Bitmap( { :rezId => rezId } );
        }
        return null;
    }

    public static function update() as Void {
        _bufferedBitmap = createOrUpdate();
    }

    // Constructor
    public function initialize( location as Location ) {
        BufferedBitmapDrawable.initialize( { 
            :bufferedBitmap => getBufferedBitmap(), 
        } );

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

    public function draw( dc as Dc ) as Void {
        BufferedBitmapDrawable.setBufferedBitmap( getBufferedBitmap() );
        BufferedBitmapDrawable.draw( dc );       
    }
}