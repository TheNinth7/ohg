import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Menu item for Switch elements of type "Player".
 * Displays the current state as icons (play/pause).
 * When selected, opens a dedicated full-screen view with controls 
 * for "Play"/"Pause", "Next" and "Previous".
 */
class PlayerMenuItem extends BaseWidgetMenuItem {

    // Returns true if the given widget matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return 
            sitemapWidget instanceof SitemapSwitch
            && sitemapWidget.getSwitchItem().getType().equals( "Player" );
    }

    // For sending commands
    private var _commandRequest as BaseCommandRequest?;

    // The full-screen view is instantiated only when the
    // menu item is selected
    private var _playerView as PlayerView?;

    // The SitemapSwitch is retained so it can be passed on
    // to the full-screen view when it is opened
    private var _sitemapSwitch as SitemapSwitch;

    // Constructor
    // Initializes the BaseCommandRequest used for changing the state,
    // the Drawable for the displayed state and the superclass
    public function initialize( 
        sitemapSwitch as SitemapSwitch,
        parent as BasePageMenu,
        processingMode as BasePageMenu.ProcessingMode
    ) {
        _sitemapSwitch = sitemapSwitch;
        
        _commandRequest = BaseCommandRequest.get( self, false );

        BaseWidgetMenuItem.initialize( {
                :sitemapWidget => sitemapSwitch,
                :isActionable => _commandRequest != null,
                :parent => parent,
                :processingMode => processingMode
            }
        );

        updateDisplayState();
    }

    // This function is called during a command request to identify
    // the target item that the command should be sent to.
    public function getItemName() as String {
        return _sitemapSwitch.getSwitchItem().getName();
    }

    // Nothing to be done, but needed to fullfil the delegate interface
    function onCommandComplete( syncMode as Boolean ) as Void {
    }

    // Exceptions from the command request are handed
    // over to the ExceptionHandler
    function onException( ex as Exception ) as Void {
        ExceptionHandler.handleBackgroundException( ex );
    }

    // Called by the delegate when the view is exited
    function onReturn() as Void {
        _playerView = null;
    }

    // When the menu item is selected, the full-screen 
    // view is initialized and pushed to the view stack
    public function onSelect() as Boolean {
        // First we see if the base class handles the event ...
        if( ! BaseWidgetMenuItem.onSelect() ) {
            // ... if not, and we do have a command request, then we
            // initialize a new full-screen view and display it
            if( _commandRequest != null ) {
                _playerView = new PlayerView( _sitemapSwitch );
                ViewHandler.pushView(
                    _playerView,
                    new PlayerDelegate( self ),
                    WatchUi.SLIDE_LEFT
                );
            }
        }
        return true;
    }

    // The delegate uses this function to send a command and update the state.
    // In addition to sending the command, it updates the internal state
    // immediately so the new state is displayed right away.
    // It also notifies the base class to lock the state against further
    // updates, if this behavior is enabled.
    public function sendCommand( newState as String ) as Void {
        
        // Technically there is no guarantee for a command request to
        // be present, though if there is no command request, the
        // full-screen view will not be available and now command
        // should be sent. We check for it anyway.
        if( _commandRequest == null ) {
            throw new GeneralException( "PlayerMenuItem: state update not possible because command support is not active" );
        }
        
        // Send the command
        _commandRequest.sendCommand( newState );
        
        // For PLAY and PAUSE commands we want to immediately show the
        // new state, and thus update the currently stored state and 
        // its display
        if( newState.equals( SwitchItem.ITEM_STATE_PLAY ) 
            || newState.equals( SwitchItem.ITEM_STATE_PAUSE )
        ) {
            // Perform an internal update of the state in the SitemapSwitch
            _sitemapSwitch.updateState( newState );
            
            // Notify the base class that an internal state update was performed.
            // This triggers the post-command hold time for state updates,
            // if configured in the app settings.
            notifyInternalStateUpdated();

            // Update state displayed by the menu item
            updateDisplayState();

            // If the full-screen view is still open, then we update the view 
            // and request a UI update.
            if( _playerView != null ) {
                _playerView.updateWidget( _sitemapSwitch );
                WatchUi.requestUpdate();
            }
        }
    }

    // The delegate uses this function to send play/pause commands
    // depending on the current state
    public function sendPlayPause() as Void {
        sendCommand(
            _sitemapSwitch.getSwitchItem().getState().equals( SwitchItem.ITEM_STATE_PLAY )
            ? SwitchItem.ITEM_STATE_PAUSE
            : SwitchItem.ITEM_STATE_PLAY
        );
    }

    /*
    * This function is used by both the constructor and updateWidget()
    * to refresh the displayed state.
    *
    * For PLAY and PAUSE, it uses PlayPauseStateDrawable as the
    * state drawable of the base class.
    *
    * For all other states (typically NO_STATE), the state is shown
    * using the base class’s responsive state text.
    */
    private function updateDisplayState() as Void {
        var currentStateDrawable = getStateDrawable();
        var currentState = _sitemapSwitch.getSwitchItem().getState();

        // This expression returns
        // true for PLAY
        // false for PAUSE
        // a String for any other state        
        var currentStateParsed = 
            currentState.equals( SwitchItem.ITEM_STATE_PLAY )
            ? true
            : currentState.equals( SwitchItem.ITEM_STATE_PAUSE )
              ? false
              : _sitemapSwitch.getDisplayState();

        // For PLAY/PAUSE ...
        if( currentStateParsed instanceof Boolean ) {
            // ... we either update the existing Drawable or create a new one ...
            if( currentStateDrawable instanceof PlayPauseStateDrawable ) {
                currentStateDrawable.setPlaying( currentStateParsed );
            } else {
                setStateDrawable( new PlayPauseStateDrawable( currentStateParsed ) );
            }
            // ... and do not display a text.
            setStateTextResponsive( null );
        } else if( currentStateParsed instanceof String ) {
            // And for text we set the Drawable to null and instead
            // show the text
            setStateDrawable( null );
            setStateTextResponsive( currentStateParsed );
        }
    }

    // Updates the menu item
    // This function is called when new data comes in from the
    // sitemap polling
    public function updateWidget( sitemapWidget as SitemapWidget ) as Void {
        BaseWidgetMenuItem.updateWidget( sitemapWidget );
        
        // Verify that the passed in element is of the right type
        if( ! ( sitemapWidget instanceof SitemapSwitch ) ) {
            throw new GeneralException( "Sitemap element '" + sitemapWidget.getLabel() + "' was passed into PlayerMenuItem but is of a different type" );
        }
        
        // Store the new widget
        _sitemapSwitch = sitemapWidget;

        updateDisplayState();

        // If the view is currently open, we update it as well      
        if( _playerView != null ) {
            _playerView.updateWidget( sitemapWidget );
        }
    }
}