import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * A custom menu item for the `CommandMenu`. It displays the label of a command
 * and stores the actual command for processing by the delegate.
 * It used only on Edge devices, where the `ActionMenu` is not available.
 */
(:exclForActionMenu)
class CommandMenuItem extends BaseMenuItem {

    // The values and Drawable
    private var _label as String;
    private var _command as String;
    private var _labelTextArea as Text?;

    /*
    * Constructor.
    * Initializes the superclass and stores the label and command.
    */
    public function initialize( label as String, command as String ) {
        BaseMenuItem.initialize();
        _label = label;
        _command = command;
    }

    // Returns the command
    public function getCommand() as String {
        return _command;
    }

    // Create the Drawable
    public function onLayout( dc as Dc ) as Void {
        var dcWidth = dc.getWidth();
        var dcHeight = dc.getHeight();

        var font = Constants.UI_MENU_ITEM_FONTS[0];

        var yCenter = dcHeight/2 - Graphics.getFontHeight( font )/2 + Graphics.getFontDescent( font )/2;

        // Apply the left padding
        var locX = ( dcWidth * Constants.UI_MENU_ITEM_PADDING_LEFT_FACTOR ).toNumber();
        // Apply the right padding
        var width = dcWidth - locX - ( dcWidth * Constants.UI_MENU_ITEM_PADDING_RIGHT_FACTOR ).toNumber();

        // Create the Drawables
        _labelTextArea = new Text( {
            :text => _label,
            :font => font,
            :locX => locX,
            :locY => yCenter,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
            :color => Theme.textColor,
            :backgroundColor => Theme.menuItemBackgroundColor,
            :width => width,
            :height => dcHeight
        } );
    }

    /*
    * Called by the superclass to handle drawing.
    * This event handler is responsible for rendering the content.
    */
    public function onUpdate( dc as Dc ) as Void {
        ( _labelTextArea as TextArea ).draw( dc );
    }
}