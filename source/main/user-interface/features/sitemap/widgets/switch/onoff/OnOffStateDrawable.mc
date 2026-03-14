import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Drawable for rendering an on/off toggle switch.
 *
 * Uses the two bitmaps provided by OnOffStateBitmaps and updates
 * the BufferedBitmap in its base class based on the current toggle state.
 */
class OnOffStateDrawable extends BufferedBitmapDrawable {

    // Storing the state helps us determining if there was an
    // actual change of state, when setEnabled and setFocus is called.
    private var _isEnabled as Boolean?;
    private var _useSmallIcon as Boolean;
    private var _isFocused as Boolean;

    // Constructor
    // Processes the initial state
    public function initialize( 
        isEnabled as Boolean?, 
        isFocused as Boolean, 
        useSmallIcon as Boolean 
    ) {
        _isEnabled = isEnabled;
        _isFocused = isFocused;
        _useSmallIcon = useSmallIcon;

        BufferedBitmapDrawable.initialize( {
            :bufferedBitmap => getOnOffBitmap( isEnabled, isFocused, useSmallIcon )
        } );
    }


    // setEnabledAndIconSize is called with every sitemap update
    // To improve performance, we only switch the BufferedBitmap
    // if the state changed
    public function setEnabledAndIconSize( isEnabled as Boolean?, useSmallIcon as Boolean ) as Void {
        if( _isEnabled != isEnabled || _useSmallIcon != useSmallIcon ) {
            _isEnabled = isEnabled;
            _useSmallIcon = useSmallIcon;
            setBufferedBitmap( getOnOffBitmap( isEnabled, _isFocused, useSmallIcon ) );
        }
    }

    // setFocus is called with every draw, since the focus can change anytime
    // To improve performance, we only switch the BufferedBitmap
    // if the state changed
    public function setFocus( isFocused as Boolean ) as Void {
        if( _isFocused != isFocused ) {
            _isFocused = isFocused;
            setBufferedBitmap( getOnOffBitmap( _isEnabled, isFocused, _useSmallIcon ) );
        }
    }

    // Returns the right bitmap for a given state
    private function getOnOffBitmap( 
        isEnabled as Boolean?, 
        isFocused as Boolean, 
        useSmallIcon as Boolean 
    ) as BufferedBitmapType {
        
        var theme = isFocused
                    ? ThemeManager.focused
                    : ThemeManager.current;

        var bitmaps = useSmallIcon
                        ? theme.smallOnOffBitmaps
                        : theme.onOffBitmaps;

        return isEnabled == null
                ? bitmaps.nostate
                : isEnabled
                    ? bitmaps.on
                    : bitmaps.off;
    }
}