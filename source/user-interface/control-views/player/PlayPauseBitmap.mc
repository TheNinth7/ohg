import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Bitmap implementation for rendering an play/pause bitmap, based on the item state.
 * This class works both for button- and touch-based devices.
 */
class PlayPauseBitmap extends CustomBitmap {

    // Options accepted by this class
    typedef Options as { 
        :state as String, // the current state
        :identifier as Lang.Object, 
        :locX as Lang.Numeric, 
        :locY as Lang.Numeric, 
        :width as Lang.Numeric, 
        :height as Lang.Numeric, 
        :visible as Lang.Boolean,
        :touchId as Symbol?
    };

    // Storing the state helps us determining if there was an
    // actual change of state, when setState is called.
    private var _currentState as String;

    // Resources for touch-based devices
    (:exclForButton)
    private var _playRezId as ResourceId = Rez.Drawables.iconPlayTouch;
    (:exclForButton)
    private var _pauseRezId as ResourceId = Rez.Drawables.iconPauseTouch;

    // Resources for button-based devices (where input hints are displayed)
    (:exclForTouch)
    private var _playRezId as ResourceId = Rez.Drawables.iconPlayButton;
    (:exclForTouch)
    private var _pauseRezId as ResourceId = Rez.Drawables.iconPauseButton;

    // Constructor
    // Processes the initial state
    public function initialize( options as CustomBitmap.Options ) {
        _currentState = options[:state] as String;
        options[:rezId] = getResourceId( _currentState );
        CustomBitmap.initialize( options );
    }

    // Returns the ResourceId of the bitmap to be shown for a specific state
    private function getResourceId ( currentState as String ) as ResourceId {
        return currentState.equals( SwitchItem.ITEM_STATE_PLAY )
            ? _pauseRezId
            : _playRezId;
    }
    
    // setState is called with every sitemap update
    // To improve performance, we only switch the BufferedBitmap
    // if the state changed
    public function setState( state as String ) as Void {
        if( ! _currentState.equals( state ) ) {
            _currentState = state;
            setBitmap( getResourceId( state ) );
        }
    }
}