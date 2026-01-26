import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * A custom menu item that displays the current connectivity mode.
 */
class SettingsConnectivityMenuItem extends SettingsTextMenuItem {

    /*
    * Constructor.
    * Initializes the superclass with the label and sublabel.
    */
    public function initialize() {
        SettingsTextMenuItem.initialize( 
            "Connectivity Mode", 
            "n/a" 
        );
    }

    /*
    * Called by the superclass to handle drawing.
    * Also updates the connectivity mode.
    */
    public function onUpdate( dc as Dc ) as Void {
        setSubLabel( ConnectivityHandler.get().getStateDescription() );
        SettingsTextMenuItem.onUpdate( dc );
    }
}