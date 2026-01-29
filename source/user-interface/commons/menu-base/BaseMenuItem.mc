import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * `BaseMenuItem` serves as the base class for all menu item implementations.
 *
 * Its current responsibility is to draw the focus indicator on devices that require it 
 * (e.g., Edge 540/840). Additional shared functionality may be added in the future.
 *
 * Subclasses must implement the `onLayout()` and `onUpdate()` methods, which mimic 
 * the behavior of the Garmin SDK`s View class. 
 * - `onLayout()` is called once before the first update to perform layout calculations.
 * - `onUpdate()` is called each time the menu item needs to be redrawn.
 */

class BaseMenuItem extends CustomMenuItem {
    
    // Set to true once onLayout() has been called
    private var _hasLayout as Boolean = false;

    // Constructor
    // This base class currently only uses the `id` from the options;
    // all other options are used by derived classes.
    protected function initialize() {
        CustomMenuItem.initialize( null, {} );
    }

    public function draw( dc as Dc ) as Void {
        try {
            if( ! _hasLayout ) {
                _hasLayout = true;
                onLayout( dc );
            }

            // If the focused background color is not transparent and the item is focused, 
            // fill the background with the specified color.
            if( ( isFocused() ) && 
                Constants.UI_MENU_ITEM_BG_COLOR_FOCUSED != Graphics.COLOR_TRANSPARENT ) {
                    dc.setColor( Constants.UI_COLOR_TEXT, Constants.UI_MENU_ITEM_BG_COLOR_FOCUSED );
                    dc.clear();
            }

            onUpdate( dc );
        } catch( ex ) {
            ExceptionHandler.handleBackgroundException( ex );
        }
    }

    // May be implemented by subclasses to perform layout calculations
    public function onLayout( dc as Dc ) as Void;

    // Must be implemented by sub-classes, to draw their content
    public function onUpdate( dc as Dc ) as Void {
        throw new AbstractMethodException( "BaseMenuItem.drawImpl" );
    }

}