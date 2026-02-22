import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Singleton class that provides two BufferedBitmaps representing
 * a toggle switch in the "on" and "off" positions.
 *
 * Each BufferedBitmap is used to obtain a corresponding Dc (Drawing Context),
 * allowing the switch to be rendered using primitive shapes such as circles and rectangles.
 */
class OnOffStateBitmaps {
    
    // Singleton accessor
    private static var _instance as OnOffStateBitmaps?;
    public static function get() as OnOffStateBitmaps {
        if( _instance == null ) {
            _instance = new OnOffStateBitmaps();
        }
        return _instance as OnOffStateBitmaps;
    }

    // The circles are again defines as a factor to the width (Constants.UI_MENU_ITEM_TOGGLE_SWITCH_WIDTH)
    private const OUTER_CIRCLE_FACTOR = 0.8;
    private const INNER_CIRCLE_FACTOR = 0.75;
    
    // Factors applied to the inner-circle radius, to determine
    // the size of the line displayed if there is no state
    private const NO_STATE_LINE_LENGTH_FACTOR = 0.7;
    private const NO_STATE_LINE_WIDTH_FACTOR = 0.6;

    // The BufferedBitmaps for ON and OFF
    public var on as BufferedBitmapType;
    public var off as BufferedBitmapType;
    public var nostate as BufferedBitmapType;

    // Constructor
    public function initialize() {
        on = BufferedBitmapFactory.createBufferedBitmap( {
            :width => Constants.UI_MENU_ITEM_TOGGLE_SWITCH_WIDTH,
            :height => Constants.UI_MENU_ITEM_TOGGLE_SWITCH_HEIGHT,
        } );
        draw( on, true );

        off = BufferedBitmapFactory.createBufferedBitmap( {
            :width => Constants.UI_MENU_ITEM_TOGGLE_SWITCH_WIDTH,
            :height => Constants.UI_MENU_ITEM_TOGGLE_SWITCH_HEIGHT,
        } );
        draw( off, false );

        nostate = BufferedBitmapFactory.createBufferedBitmap( {
            :width => Constants.UI_MENU_ITEM_TOGGLE_SWITCH_WIDTH,
            :height => Constants.UI_MENU_ITEM_TOGGLE_SWITCH_HEIGHT,
        } );
        draw( nostate, null );
    }

    // Draws the switch UI element.
    // The outline is composed of two circles and a rectangle:
    // - Colored in openHAB orange when "on"
    // - Colored in light grey when "off"
    // A smaller black circle indicates the current on/off position.
    protected function draw( bufferedBitmap as BufferedBitmapType, isEnabled as Boolean? ) as Void {
        var dc = bufferedBitmap.getDc();
        dc.clear();

        // Define the color of the switch
        if( isEnabled ) {
            dc.setColor( ThemeManager.current.onColor, Graphics.COLOR_TRANSPARENT );
            
            // Currently not used, because it does not work on Edge devices (it should)
            // and also not on devices pre-CIQ 4.0.0. Apart from having to specifiy
            // the background color, there is no drawback in using setColor
            // dc.setFill( 0xFF000000 + ThemeManager.current.onColor );
        } else {
            dc.setColor( ThemeManager.current.stateColor, Graphics.COLOR_TRANSPARENT );

            // See the comment on the first setFill
            // dc.setFill( 0xFF000000 + Graphics.stateColor );
        }
        
        // Spacing defines the gap between the outer edge of the `Drawable` and the switch.
        // This is necessary because anti-aliasing can cause drawing primitives to slightly 
        // exceed their intended boundaries.
        var spacing = ( dc.getWidth() * (1-OUTER_CIRCLE_FACTOR) / 2 ).toNumber();
        // Radius of the upper and lower circles of the switch outline
        var radius = (dc.getWidth()/2).toNumber() - spacing;
        var xCenter = spacing + radius; // Horizontal center of the switch
        var upperYCenter = xCenter; // Center of the upper circle
        var lowerYCenter = dc.getHeight() - spacing - radius; // Center of the lower circle
        dc.setPenWidth( 1 );
        if(  Constants.UI_USE_ANTI_ALIASING && dc has :setAntiAlias ) {
            dc.setAntiAlias( true );
        }
        dc.fillCircle( xCenter, upperYCenter, radius );
        dc.fillCircle( xCenter, lowerYCenter, radius );
        // Correction values -1 and + 3 have been determined by
        // trial and error and tested on different devices
        dc.fillRectangle( xCenter-radius-1, upperYCenter, radius*2 + 3, lowerYCenter - upperYCenter );

        // draw the inner circle showing the switch state

        dc.setColor( ThemeManager.current.backgroundColor, Graphics.COLOR_TRANSPARENT );
        // See the comment on the first setFill
        // dc.setFill( 0xFF000000 + Graphics.COLOR_BLACK );

        var innerRadius = radius * INNER_CIRCLE_FACTOR;
        if( isEnabled != null ) {
            var toggleCenter = isEnabled ? upperYCenter : lowerYCenter;
            dc.fillCircle( xCenter, toggleCenter, innerRadius );
        } else {
            dc.setPenWidth( innerRadius * NO_STATE_LINE_WIDTH_FACTOR );
            innerRadius = innerRadius * NO_STATE_LINE_LENGTH_FACTOR;
            var yCenter = ( dc.getHeight()/2 ).toNumber();
            dc.drawLine( xCenter - innerRadius, yCenter, xCenter + innerRadius, yCenter );
        }
    }
}