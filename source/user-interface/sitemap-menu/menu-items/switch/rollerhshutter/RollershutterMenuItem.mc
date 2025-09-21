import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Menu item for Switch elements of type "Rollershutter".
 * Displays the current state as text, applying any available mappings and state descriptions.
 * When selected, opens a dedicated full-screen view with controls for "Up", "Down", and "Stop".
 */
class RollershutterMenuItem extends BaseWidgetMenuItem {

    // Returns true if the given widget matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return 
            sitemapWidget instanceof SitemapSwitch
            && sitemapWidget.getSwitchItem().getType().equals( "Rollershutter" );
    }

    // For sending commands
    private var _commandRequest as BaseCommandRequest?;

    // The full-screen view is instantiated only when the
    // menu item is selected
    private var _rollershutterView as RollershutterView?;

    // The SitemapSwitch is retained so it can be passed on
    // to the full-screen view when it is opened
    private var _sitemapSwitch as SitemapSwitch;

    // The Drawable for the state
    private var _stateDrawable as StateText;

    // Constructor
    // Initializes the BaseCommandRequest used for changing the state,
    // the Drawable for the displayed state and the superclass
    public function initialize( 
        sitemapSwitch as SitemapSwitch,
        parent as BasePageMenu,
        processingMode as BasePageMenu.ProcessingMode
    ) {
        _sitemapSwitch = sitemapSwitch;
        
        _commandRequest = BaseCommandRequest.get( self );

        // The state shown in the menu item
        _stateDrawable = new StateText( sitemapSwitch.getDisplayState() );
        
        BaseWidgetMenuItem.initialize( {
                :sitemapWidget => sitemapSwitch,
                :stateDrawable => _stateDrawable,
                :isActionable => true,
                :parent => parent,
                :processingMode => processingMode
            }
        );
    }

    // This function is called during a command request to identify
    // the target item that the command should be sent to.
    public function getItemName() as String {
        return _sitemapSwitch.getSwitchItem().getName();
    }

    // Nothing to be done, but needed to fullfil the delegate interface
    function onCommandComplete() as Void {
    }

    // Exceptions from the command request are handed
    // over to the ExceptionHandler
    function onException( ex as Exception ) as Void {
        ExceptionHandler.handleException( ex );
    }

    // Called by the delegate when the view is exited
    function onReturn() as Void {
        _rollershutterView = null;
    }

    // When the menu item is selected, the full-screen 
    // view is initialized and pushed to the view stack
    public function onSelect() as Boolean {
        // First we see if the base class handles the event ...
        if( ! BaseWidgetMenuItem.onSelect() ) {
            // ... if not, and we do have a command request, then we
            // initialize a new full-screen view and display it
            if( _commandRequest != null ) {
                _rollershutterView = new RollershutterView( _sitemapSwitch );
                ViewHandler.pushView(
                    _rollershutterView,
                    new RollershutterDelegate( self ),
                    WatchUi.SLIDE_LEFT
                );
            }
        }
        return true;
    }

    // The delegate uses this function to update the state
    // Note that the command is sent but the local state is NOT
    // updated. This is because for Rollershutter, the state
    // does not reflect the actual command (up/down/stop), but 
    // always shows the numeric opening percentage
    public function sendCommand( newState as String ) as Void {
        if( _commandRequest == null ) {
            throw new GeneralException( "RollershutterMenuItem: state update not possible because command support is not active" );
        }
        ( _commandRequest as BaseCommandRequest ).sendCommand( newState );
    }

    // Updates the menu item
    // This function is called when new data comes in from the
    // sitemap polling
    public function updateWidget( sitemapWidget as SitemapWidget ) as Void {
        BaseWidgetMenuItem.updateWidget( sitemapWidget );
        
        // Verify that the passed in element is of the right type
        if( ! ( sitemapWidget instanceof SitemapSwitch ) ) {
            throw new GeneralException( "Sitemap element '" + sitemapWidget.getLabel() + "' was passed into RollershutterMenuItem but is of a different type" );
        }
        
        // Store the new widget
        _sitemapSwitch = sitemapWidget;
        
        // Update the state drawable
        _stateDrawable.setText( sitemapWidget.getDisplayState() );
        
        // If the view is currently open, we update it as well      
        if( _rollershutterView != null ) {
            _rollershutterView.updateWidget( sitemapWidget );
        }
    }
}