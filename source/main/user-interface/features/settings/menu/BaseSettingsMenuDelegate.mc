import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

/*
 * Base class for settings menu input delegates.
 *
 * This class handles selection of menu items and provides common behavior
 * shared by all device types.
 *
 * Two delegates derive from this class:
 *  - one for button-based devices
 *  - one for touch-based devices
 *
 * The derived delegates implement additional device-specific behavior.
 */
class BaseSettingsMenuDelegate extends PageMenuDelegate {
    protected function initialize() {
        PageMenuDelegate.initialize();
    }

    // Called when an item is selected
    public function onSelect( item as MenuItem ) as Void {
        try{
            // Actionable items are using the base sitemap menu item
            if( item instanceof StructuredMenuItem ) {
                item.onSelect();
            }
        } catch( ex ) {
            ExceptionHandler.handleUserInterfaceException( ex );
        }
    }
}