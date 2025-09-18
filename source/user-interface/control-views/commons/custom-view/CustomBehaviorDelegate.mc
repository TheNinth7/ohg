import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Base class for delegates used with CustomView.
 *
 * The onSelect() method is triggered by a screen tap, which can conflict
 * with using onTap() for handling touch events on specific areas.
 * Therefore, base classes should not override onSelect(). Instead, they
 * should use onKey() for button-based input.
 *
 * For touch input, subclasses can implement onAreaTap() to receive taps
 * along with the identifier of the touched area. This identifier corresponds
 * to the one used when defining the area in CustomView.
 *
 * If touch areas are not being used, subclasses may override onTap()
 * to define a single behavior for all screen taps.
 */
class CustomBehaviorDelegate extends BehaviorDelegate {

    // Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    // onSelect is declared protected, and thus cannot be overriden
    protected function onSelect() as Boolean {
        return false;
    }

    // The onTap() implementation checks which touch area has
    // been tapped and then calls onTapArea() with its identifier
    public function onTap( clickEvent as ClickEvent ) as Boolean {
        // Logger.debug "CustomBehaviorDelegate.onTap" );

        // Only do this if the view is a CustomView
        var currentView = WatchUi.getCurrentView()[0];
        if( currentView instanceof CustomView ) {
            var touchAreas = currentView.getTouchAreas();
            var coordinates = clickEvent.getCoordinates();
            for( var i = touchAreas.size() - 1; i >= 0; i-- ) {
                var touchArea = touchAreas[i];
                if( touchArea.contains( coordinates ) ) {
                    return onAreaTap( touchArea.getId(), clickEvent );
                }
            }
        }
        return false;
    }

    // Subclasses should override this and implement
    // behaviors for the individual tap areas
    public function onAreaTap( area as Symbol, clickEvent as ClickEvent ) as Boolean {
        // Logger.debug "CustomBehaviorDelegate.onAreaTap" );
        return false;
    }
}