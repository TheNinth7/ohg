import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
 * Drawable that renders the connection mode indicator.
 *
 * The indicator is composed of the following elements:
 *
 * - State indicator: a circular color marker representing the current
 *   connection status:
 *     - Green   Bluetooth connection (full functionality available)
 *     - Yellow  Wi-Fi connection (limited functionality, no state updates)
 *     - Red     No connection (no state updates, no commands possible)
 *
 * - Bluetooth icon:
 *     - Shown as enabled or disabled, depending on the current status.
 *
 * - Wi-Fi icon:
 *     - Shown as enabled, disabled, or "pending check".
 *     - Only displayed if the device supports Wi-Fi and Wi-Fi is configured.
 *
 * Architecture:
 * The class is split into two parts:
 *
 * - A static component that maintains a buffered bitmap containing the
 *   fully rendered current indicator. This avoids redundant redraws and
 *   reduces resource usage.
 *
 * - An instance component that can be created multiple times with different
 *   screen locations. All instances share the same buffered bitmap to
 *   conserve memory and processing time.
 *
 * Usage:
 * A location type must be provided when creating an instance. The constructor
 * sets the initial position accordingly. The location can later be changed
 * by calling setLocation().
 */
class ConnectionModeIndicator extends BufferedBitmapDrawable {

    // The locations supported when instantiating the class
    // LOCATION_MENU for the title area of CustomMenu implementations
    // LOCATION_CUSTOM_VIEW for full-screen control views
    enum Location {
        LOCATION_MENU,
        LOCATION_CUSTOM_VIEW
    }

    /******* STATIC *******/ 

    // The buffered bitmap singleton
    private static var _bufferedBitmap as BufferedBitmapType?;

    // Creates or updates the buffered bitmap to reflect the
    // current connection mode. Invoked by ConnectionHandler
    // whenever the connection mode changes.
    private static function createOrUpdate() as BufferedBitmapType {
        
        // First, all the icons are assembled in an array
        var elements = new Array<Drawable>[0];
        elements.add( getStateIcon() );
        elements.add( getBluetoothIcon() );
        var wifi = getWifiIcon();
        if( wifi != null ) {
            elements.add( wifi );
        }

        // Next the required width and height is calculated from
        // the assembled Drawables.
        // Width is the sum of all the Drawable widths with added spacing.
        // Height is the height of the tallest Drawable.
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

        // If there is an existing buffered bitmap with the
        // right size, it is kept, otherwise a new one is created
        var newBufferedBitmap = _bufferedBitmap;
        if( newBufferedBitmap == null
            || newBufferedBitmap.getWidth() != width 
            || newBufferedBitmap.getHeight() != height 
        ) {
            newBufferedBitmap = BufferedBitmapFactory.createBufferedBitmap( {
                :height => height,
                :width => width
            } );
        } 

        // Obtain and clear the Dc
        var dc = newBufferedBitmap.getDc();
        dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );
        dc.clear();

        // Draw all elements, from left to right
        var locX = 0;
        for( var i = 0; i < elements.size(); i++ ) {
            var element = elements[i];
            element.setLocation( locX, WatchUi.LAYOUT_VALIGN_CENTER );
            element.draw( dc );
            locX += element.width + spacing;
        }

        return newBufferedBitmap;
    }

    // Accessor for the buffered bitmap singleton
    private static function getBufferedBitmap() as BufferedBitmapType {
        if( _bufferedBitmap == null ) {
            _bufferedBitmap = createOrUpdate();
        }
        return _bufferedBitmap;
    }

    // Determins which Bluetooth icon shall be displayed
    private static function getBluetoothIcon() as Drawable {
        var rezId;
        if( ConnectionHandler.get().isBluetoothConnected() ) {
            rezId = Rez.Drawables.iconBluetoothOn;
        } else {
            rezId = Rez.Drawables.iconBluetoothOff;
        }
        return new Bitmap( { :rezId => rezId } );
    }

    // Determins which state icon shall be displayed
    private static function getStateIcon() as Drawable {
        var ch = ConnectionHandler.get();
        var rezId;
        if( ch.isBluetoothConnected() ) {
            rezId = Rez.Drawables.iconConnStateGreen;
        } else if( ch.isWifiConnected() ) {
            rezId = Rez.Drawables.iconConnStateYellow;
        } else {
            // Offline and pending Wi-Fi check are both red
            rezId = Rez.Drawables.iconConnStateRed;
        }
        return new Bitmap( { :rezId => rezId } );
    }

    // Determins which Wi-Fi icon shall be displayed
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

    // Used by the ConnectionHandler when the mode changes
    public static function update() as Void {
        _bufferedBitmap = createOrUpdate();
    }

    /******* INSTANCE *******/ 

    // The location of this instance
    private var _location as Location;

    // Constructor
    // Determines the indicator position based on the provided
    // location type and the current screen shape.
    //
    // On rectangular screens, the indicator is placed in the
    // upper-left corner.
    //
    // On round screens, it is positioned at the top center.
    // In menu views, the indicator is placed slightly lower
    // than in full-screen views to account for the different
    // title text positioning.
    public function initialize( location as Location ) {
        
        _location = location;

        // Initialize the parent class with the singleton buffered bitmap
        BufferedBitmapDrawable.initialize( { 
            :bufferedBitmap => getBufferedBitmap(), 
        } );

        // Set the location as outlined above
        if( Constants.UI_SCREEN_SHAPE == Toybox.System.SCREEN_SHAPE_RECTANGLE ) {
            // Only custom view location is set here
            // Location for menu is set in draw() since Dc is
            // needed for determining the location
            if( location == LOCATION_CUSTOM_VIEW ) {
                var spacing = ( height * 0.2 ).toNumber();
                setLocation( spacing, spacing );
            }
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

    // Draws the connection mode indicator.
    //
    // If the size has changed, the buffered bitmap is recreated.
    // The parent class is always updated with the current buffered
    // bitmap instance to ensure the current indicator is drawn.
    public function draw( dc as Dc ) as Void {
        if( locX == 0 && _location == LOCATION_MENU ) {
            setLocation( WatchUi.LAYOUT_HALIGN_CENTER, dc.getHeight() * 0.525 );
        }
        BufferedBitmapDrawable.setBufferedBitmap( getBufferedBitmap() );
        BufferedBitmapDrawable.draw( dc );       
    }
}