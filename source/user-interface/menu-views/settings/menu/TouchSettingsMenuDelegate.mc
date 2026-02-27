import Toybox.Lang;
import Toybox.WatchUi;

/*
 * On touch devices, presenting the settings menu as a parallel menu 
 * beneath the homepage menu is less intuitive. Instead, the settings menu 
 * is included as a regular item within the homepage menu.
 *
 * In this setup, the input delegate only needs to implement the `onBack()` behavior.
 */
(:exclForSettingsFooter)
class TouchSettingsMenuDelegate extends BaseSettingsMenuDelegate {
    public function initialize() {
        BaseSettingsMenuDelegate.initialize();
    }

    public function onBack() as Void {
        try {
            SettingsMenuHandler.hideSettings( WatchUi.SLIDE_RIGHT );
        } catch( ex ) {
            ExceptionHandler.handleUserInterfaceException( ex );
        }
    }
}