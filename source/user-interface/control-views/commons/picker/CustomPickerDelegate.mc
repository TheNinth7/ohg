import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Abstract base class for handling user interactions with a CustomPicker.
 *
 * Implement this class to respond to changes in the currently displayed value,
 * as well as user actions such as confirmation or cancellation.
 *
 * Subclasses may override the following callbacks:
 * - onUp(): Called when the user navigates up.
 * - onDown(): Called when the user navigates down.
 * - onAccept(): Called when the user confirms a selection.
 * - onCancel(): Called when the user cancels the picker.
 *
 * You may also override onKey(), but only for keys other than
 * KEY_ENTER, KEY_UP, and KEY_DOWN. If overridden, calls for these keys
 * must be passed to the superclass to ensure proper handling.
 *
 * Do not override onBack(), as it is used internally for handling cancellation.
 * Similarly, do not override onTap(); all tap events should be handled by this class.
 */
class CustomPickerDelegate extends CustomBehaviorDelegate {

    // Constructor
    public function initialize() {
        CustomBehaviorDelegate.initialize();
    }

    // The delegate functions to be implemented by
    // subclasses
    public function onUp( value as Object ) as Boolean {
        return false;
    }
    public function onDown( value as Object ) as Boolean {
        return false;
    }
    public function onAccept( value as Object ) as Boolean {
        return false;
    }
    public function onCancel() as Boolean {
        return false;
    }

    // React to key presses
    public function onKey( keyEvent as KeyEvent ) as Boolean {
        // Logger.debug( "CustomPickerDelegate.onKey: start" );
        var key = keyEvent.getKey();
        if( key == KEY_ENTER ) {
            return onAccept( getCurrentValue() );
        } else if( key == KEY_UP ) {
            return onUpInternal();
        } else if( key == KEY_DOWN ) {
            return onDownInternal();
        }
        // Logger.debug( "CustomPickerDelegate.onKey: end" );
        return false;
    }

    // onBack covers both swipe right
    // and the back key
    public function onBack() as Boolean {
        return onCancel();
    }

    // Here we react to the touch areas defined
    // in CustomPicker
    public function onAreaTap( area as Symbol, clickEvent as ClickEvent ) as Boolean {
        // Logger.debug "CustomPickerDelegate.onAreaTap" );
        if( area == :touchUp ) {
            return onUpInternal();
        } else if( area == :touchDown ) {
            return onDownInternal();
        } else if( area == :touchCheck ) {
            return onAccept( getCurrentValue() );
        } else if( area == :touchCancel ) {
            return onCancel();
        }
        return false;
    }

    // To simplify handling, we do not need the
    // factory as parameter but get it from
    // the current view. This way we also ensure
    // that this delegate is only used in combination
    // with a CustomPicker view.
    private var _factory as CustomPickerFactory?;
    private function getFactory() as CustomPickerFactory {
        if( _factory == null ) {
            var view = WatchUi.getCurrentView()[0];
            if( view instanceof CustomPicker ) {
                _factory = view.getFactory();
            } else {
                throw new GeneralException( "CustomPickerDelegate must be used with CustomPicker view" );
            }
        }
        return _factory as CustomPickerFactory;
    }

    private function getCurrentValue() as Object {
        return getFactory().getCurrent().getValue();
    }

    // Internal functions to be used in key
    // and touch events
    private function onUpInternal() as Boolean {
        getFactory().up();
        onUp( getCurrentValue() );
        WatchUi.requestUpdate();
        return false;
    }
    private function onDownInternal() as Boolean {
        getFactory().down();
        onDown( getCurrentValue() );
        WatchUi.requestUpdate();
        return false;
    }
}