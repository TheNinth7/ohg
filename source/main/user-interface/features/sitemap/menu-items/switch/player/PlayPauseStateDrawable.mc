import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Drawable for rendering a play/pause state icon as part of the `PlayerMenuItem`.
 */
class PlayPauseStateDrawable extends Bitmap {

    // Storing the state helps us determining if there was an
    // actual change of state, when setEnabled is called.
    private var _isPlaying as Boolean;

    // Constructor
    // Processes the initial state
    public function initialize( isPlaying as Boolean ) {
        _isPlaying = isPlaying;

        Bitmap.initialize( {
            :rezId => getPlayPauseBitmap( isPlaying )
        } );
    }

    // setPlaying is called with every sitemap update
    // To improve performance, we only switch the bitmap
    // if the state changed
    public function setPlaying( isPlaying as Boolean ) as Void {
        if( _isPlaying != isPlaying ) {
            _isPlaying = isPlaying;
            setBitmap( getPlayPauseBitmap( isPlaying ) );
        }
    }

    // Returns the right resource id for a given state
    private function getPlayPauseBitmap( isPlaying as Boolean ) as ResourceId {
        return isPlaying == true
            ? ThemeManager.current.iconPlayMenuItem
            : ThemeManager.current.iconPauseMenuItem;
    }
}