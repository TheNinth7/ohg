import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * DynamicPicker is a replacement for Garmin's built-in Picker, addressing several limitations:
 *
 * 1. Immediate Action Triggering:
 *    - Garmin's Picker does not support triggering actions (e.g., sending commands) 
 *      while the user scrolls through options.
 *    - Although it's possible to do this via PickerFactory.getDrawable(), 
 *      it's an unintended workaround and may cause issues on some devices.
 *
 * 2. Dynamic Option Modification:
 *    - The built-in Picker does not support removing options after initialization.
 *    - While PickerFactory controls the option list, the Picker manages the current index,
 *      making it fragile when options disappear.
 *    - This is problematic for numerics, which might initially show a state outside 
 *      the configured range and later remove it after a new selection.
 *
 * 3. Poor Input Hint Design:
 *    - The standard Picker only indicates "Confirm" as a possible action.
 *    - In many cases (such as this one), a "Cancel" action is also important.
 *    - On at least one tested device, no input hints were shown at all.
 *
 * DynamicPicker simplifies things by supporting only Strings (not Drawables) 
 * for the title and pickable options.
 *
 * - Pickable options must provided using DynamicPickOption, or a subclass.
 * - The BaseDynamicPickerDataSource must be implemented to supply the values and manage the index.
 *   It provides up(), down(), and getCurrent() methods, allowing dynamic addition/removal of items.
 * - The BaseDynamicPickerDelegate defines callbacks for onUp() and onDown(), 
 *   in addition to the standard onAccept() and onCancel().
 *
 * See the Numeric menu item and control view implementation for an example of how to 
 * implement a BaseDynamicPickerDataSource and BaseDynamicPickerDelegate.
 */
class DynamicPicker extends BaseControlView {

    // The BaseDynamicPickerDataSource implementation
    private var _factory as BaseDynamicPickerDataSource;
    public function getFactory() as BaseDynamicPickerDataSource {
        return _factory;
    }

    private var _title as String; // The title as String

    // The Drawable for drawing the currently focused pickable
    private var _pickable as Text?;

    // The constructor takes the display title as String,
    // and the implementation of the BaseDynamicPickerDataSource
    public function initialize( title as String, factory as BaseDynamicPickerDataSource ) {
        BaseControlView.initialize();
        _title = title;
        _factory = factory;
    }

    // onLayout is called once when the view is opened,
    // and initiates all the Drawables   
    public function onLayout( dc as Dc ) as Void {
        // Logger.debug( "DynamicPicker.onLayout" ) );

        var dcHeight = dc.getHeight();
        var dcWidth = dc.getWidth();

        // Add the title and connection mode indicator using 
        // the standard layout provided by the base class
        addTitleAndConnectionIndicator( _title, dcWidth, dcHeight );

        // Vertical starting point of the controls
        // and the pickable. All these Drawables are
        // placed relative to this point.
        var yStart = 0.375;
        
        // The text field showing the current value
        _pickable = new RelativeText( {
            :font => Graphics.FONT_LARGE,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX => 0.5, // We do not use WatchUi.LAYOUT_HALIGN_CENTER because that would override :justification
            :locY => yStart + 0.25
        } );
        addDrawable( _pickable );

        // The up/down arrows
        addDrawable( new InteractiveRelativeBitmap( {
            :rezId => Rez.Drawables.chevronUpGrey,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => yStart
        } ) );
        addDrawable( new InteractiveRelativeBitmap( {
            :rezId => Rez.Drawables.chevronDownGrey,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => yStart + 0.5
        } ) );

        // Touch areas for the up/down arrows.
        //
        // These areas cover the entire screen:
        // - Anything above the vertical center of the current Pickable is considered "up".
        // - Anything below is considered "down".
        //
        // Smaller touch areas for confirm/cancel are defined afterward,
        // and they take precedence over the up/down areas.
        addTouchArea( 
            new RectangularTouchArea( 
                :touchUp, 
                0, 
                0, 
                dcWidth, 
                ( dcHeight*(yStart+0.25) ).toNumber()
        ) );
        addTouchArea( 
            new RectangularTouchArea( 
                :touchDown, 
                0, 
                ( dcHeight*(yStart+0.25) ).toNumber(), 
                dcWidth, 
                dcHeight
        ) );

        // There are different implementations for
        // button- and touch-based devices
        addInputHints( yStart + 0.25 );
    }

    // On button-based devices we use the input hints
    // feature of the BaseControlView
    (:exclForTouch)
    private function addInputHints( y as Float ) as Void {
        addInputHint( InputHint.HINT_KEY_ENTER, InputHint.HINT_TYPE_CHECK, :touchCheck );
        addInputHint( InputHint.HINT_KEY_BACK, InputHint.HINT_TYPE_CANCEL, :touchCancel );
    }

    // On touch-based devices we place two icons for
    // confirm and cancel
    // The icons are instantiated as InteractiveRelativeBitmap with
    // a touchId defined, which will automatically add
    // their touch area to the BaseControlView
    (:exclForButton)
    private function addInputHints( y as Float ) as Void {
        var xSpace = 0.15;
        addDrawable( new InteractiveRelativeBitmap( {
            :rezId => Rez.Drawables.iconCancel,
            :locX => xSpace,
            :locY => y,
            :touchId => :touchCancel
        } ) );
        
        addDrawable( new InteractiveRelativeBitmap( {
            :rezId => Rez.Drawables.iconCheck,
            :locX => 1 - xSpace,
            :locY => y,
            :touchId => :touchCheck
        } ) );
    }

    // onUpdate we just get the current value and
    // let the superclass draw all the Drawables
    public function onUpdate( dc as Dc ) as Void {
        if( _pickable != null ) {
            _pickable.setText( _factory.getCurrent().getLabel() );
        }
        BaseControlView.onUpdate( dc );
    }
}