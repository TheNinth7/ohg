import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Input delegate for the settings menu on button-based devices.
 *
 * On these devices, the settings menu is implemented as a parallel menu 
 * to the homepage menu. The footer of the homepage menu displays a settings 
 * icon, and scrolling beyond the last menu item opens the settings menu 
 * with the first item focused. Similarly, scrolling up beyond the first item 
 * in the homepage menu opens the settings menu with the last item focused.
 *
 * Conversely, exiting the settings menu by scrolling up past the first item 
 * returns to the homepage menu with focus on its last item. Scrolling down 
 * past the last settings item returns to the homepage menu with focus on its 
 * first item.
 *
 * Although these are two separate menu views, they behave as a unified menu, 
 * seamlessly transitioning between homepage and settings items.
 *
 * This delegate manages those transitions from the settings menu back to the homepage menu.
 */
(:exclForSettingsMenuItem)
class ButtonSettingsMenuDelegate extends BaseSettingsMenuDelegate {
    public function initialize() {
        BaseSettingsMenuDelegate.initialize();
    }

    /*
    * When exiting the settings menu by scrolling down, use the `SLIDE_UP` transition.
    * This transition not only animates the menu but also informs the `SettingsMenuHandler`
    * which menu item should be focused in the homepage menu.
    */
    public function onNextPage() as Boolean {
        try {
            SettingsMenuHandler.hideSettings( WatchUi.SLIDE_UP );
        } catch( ex ) {
            ExceptionHandler.handleUserInterfaceException( ex );
        }
        return true;
    }

    // Same as above, but for leaving the settings menu by scrolling up
    public function onPreviousPage() as Boolean {
        try {
            SettingsMenuHandler.hideSettings( WatchUi.SLIDE_DOWN );
        } catch( ex ) {
            ExceptionHandler.handleUserInterfaceException( ex );
        }
        return true;
    }

    // Back button triggers the same behavior as when scrolling up
    public function onBack() as Void {
        onPreviousPage();
    }

    /*
    * The behavior delegates above are only available on devices running CIQ 5.1.0 or later.
    * For older devices, we use the `onWrap()` handler, which is triggered when the menu 
    * is scrolled beyond the first or last item. The direction can be inferred from the key.
    *
    * However, `onWrap()` does not work with touch input, so the behavior delegates 
    * introduced in CIQ 5.1.0 are preferred when available.
    */
    (:exclForCiq510Plus)
    public function onWrap( key as Key ) as Boolean {
        try {
            if( key == KEY_DOWN ) {
                onNextPage();
            } else if( key == KEY_UP ) {
                onPreviousPage();
            }
        } catch( ex ) {
            ExceptionHandler.handleUserInterfaceException( ex );
        }
        // Returning false indicates to the system that
        // it should not scroll to the opposite end
        // of the menu
        return false;
    }
}