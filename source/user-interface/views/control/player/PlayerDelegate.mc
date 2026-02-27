import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Delegate responsible for processing user input in the full-screen
 * `PlayerView`. Maintains a reference to the associated
 * `PlayerMenuItem`, which it uses to send commands and update the view.
 */
class PlayerDelegate extends BaseControlViewDelegate {

    // The menu item that opened this view
    private var _menuItem as PlayerMenuItem;

    // Constructor
    public function initialize( menuItem as PlayerMenuItem ) {
        BaseControlViewDelegate.initialize();
        _menuItem = menuItem;
    }

    // React to touch area events defined in `PlayerView`
    public function onAreaTap( area as Symbol, clickEvent as ClickEvent ) as Boolean {
        // Logger.debug "PlayerDelegate.onAreaTap" );
        if( area == :touchPlayPause ) {
            return onPlayPause();
        } else if( area == :touchNext ) {
            return onNext();
        } else if( area == :touchPrevious ) {
            return onPrevious();
        }
        return false;
    }

    // This delegate function covers both the back key
    // and the swipe right gesture
    public function onBack() as Boolean {
        try {
            _menuItem.onReturn();
            ViewHandler.popView( WatchUi.SLIDE_RIGHT );
        } catch( ex ) {
            ExceptionHandler.handleUserInterfaceException( ex );
        }
        return true;
    }

    // React to key presses
    public function onKey( keyEvent as KeyEvent ) as Boolean {
        // Logger.debug( "PlayerDelegate.onKey: start" );
        try {
            var key = keyEvent.getKey();
            if( key == KEY_ENTER ) {
                return onPlayPause();
            } else if( key == KEY_UP ) {
                return onPrevious();
            } else if( key == KEY_DOWN ) {
                return onNext();
            }
            return false;
        } catch( ex ) {
            ExceptionHandler.handleUserInterfaceException( ex );
            return true;
        }
    }

    // Internal function called by the key/touch delegates
    // to issue the next command
    private function onNext() as Boolean {
        _menuItem.sendCommand( SwitchItem.ITEM_COMMAND_NEXT );
        return true;
    }

    // Internal function called by the key/touch delegates
    // to issue the play/pause command
    private function onPlayPause() as Boolean {
        _menuItem.sendPlayPause();
        return true;
    }

    // Internal function called by the key/touch delegates
    // to issue the previous command
    private function onPrevious() as Boolean {
        _menuItem.sendCommand( SwitchItem.ITEM_COMMAND_PREVIOUS );
        return true;
    }
}