import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Abstract base class for handling user interactions with a DynamicPicker.
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
 * must be passed to the base class to ensure proper handling.
 *
 * Do not override onBack(), as it is used internally for handling cancellation.
 * Similarly, do not override onTap(); all tap events should be handled by this class.
 */
class BaseDynamicPickerDelegate extends BaseControlViewDelegate {

    // Constructor
    public function initialize() {
        BaseControlViewDelegate.initialize();
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
        // Logger.debug( "BaseDynamicPickerDelegate.onKey: start" );
        try {
            var key = keyEvent.getKey();
            if( key == KEY_ENTER ) {
                return onAccept( getCurrentValue() );
            } else if( key == KEY_UP ) {
                return onUpInternal();
            } else if( key == KEY_DOWN ) {
                return onDownInternal();
            }
            // Logger.debug( "BaseDynamicPickerDelegate.onKey: end" );
            return false;
        } catch( ex ) {
            ExceptionHandler.handleUserInterfaceException( ex );
            return true;
        }
    }

    // onBack covers both swipe right
    // and the back key
    public function onBack() as Boolean {
        try {
            return onCancel();
        } catch( ex ) {
            ExceptionHandler.handleUserInterfaceException( ex );
            return true;
        }
    }

    // Here we react to the touch areas defined
    // in DynamicPicker.
    public function onAreaTap( area as Symbol, clickEvent as ClickEvent ) as Boolean {
        // Logger.debug "BaseDynamicPickerDelegate.onAreaTap" );
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
    // with a DynamicPicker view.
    private var _factory as BaseDynamicPickerDataSource?;
    private function getFactory() as BaseDynamicPickerDataSource {
        if( _factory == null ) {
            var view = ViewStack.getCurrentView()[0];
            if( view instanceof DynamicPicker ) {
                _factory = view.getFactory();
            } else {
                throw new GeneralException( "BaseDynamicPickerDelegate must be used with DynamicPicker view" );
            }
        }
        return _factory as BaseDynamicPickerDataSource;
    }

    private function getCurrentValue() as Object {
        return getFactory().getCurrent().getValue();
    }

    // Internal functions to be used in key
    // and touch events
    private function onUpInternal() as Boolean {
        // Logger.debug( "BaseDynamicPickerDelegate.onUpInternal: start" );
        getFactory().up();
        try{
            onUp( getCurrentValue() );
            WatchUi.requestUpdate();
        } catch( ex ) {
            // If an exception occurs, we undo the change
            getFactory().down();
            throw ex;
        }
        // Logger.debug( "BaseDynamicPickerDelegate.onUpInternal: end" );
        return true;
    }
    private function onDownInternal() as Boolean {
        // Logger.debug( "BaseDynamicPickerDelegate.onDownInternal: start" );
        getFactory().down();
        try{
            onDown( getCurrentValue() );
            WatchUi.requestUpdate();
        } catch( ex ) {
            // If an exception occurs, we undo the change
            getFactory().up();
            throw ex;
        }
        // Logger.debug( "BaseDynamicPickerDelegate.onDownInternal: end" );
        return true;
    }
}