import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Drawable for rendering an on/off toggle switch.
 *
 * Uses the two bitmaps provided by OnOffStateBitmaps and updates
 * the BufferedBitmap in its superclass based on the current toggle state.
 */
class OnOffStateDrawable extends BufferedBitmapDrawable {

    // Storing the state helps us determining if there was an
    // actual change of state, when setEnabled is called.
    private var _isEnabled as Boolean?;
    private var _smallIcon as Boolean;

    // Constructor
    // Processes the initial state
    public function initialize( isEnabled as Boolean?, smallIcon as Boolean ) {
        _isEnabled = isEnabled;
        _smallIcon = smallIcon;

        BufferedBitmapDrawable.initialize( {
            :bufferedBitmap => getOnOffBitmap( isEnabled, smallIcon )
        } );
    }


    // setEnabled is called with every sitemap update
    // To improve performance, we only switch the BufferedBitmap
    // if the state changed
    public function setEnabled( isEnabled as Boolean?, smallIcon as Boolean ) as Void {
        if( _isEnabled != isEnabled || _smallIcon != smallIcon ) {
            _isEnabled = isEnabled;
            _smallIcon = smallIcon;
            setBufferedBitmap( getOnOffBitmap( isEnabled, smallIcon ) );
        }
    }

    // Returns the right bitmap for a given state
    private function getOnOffBitmap( isEnabled as Boolean?, smallIcon as Boolean ) as BufferedBitmapType {
        var bitmaps = smallIcon
                        ? SmallOnOffStateBitmaps.get()
                        : OnOffStateBitmaps.get();
        return isEnabled == null
                ? bitmaps.nostate
                : isEnabled
                    ? bitmaps.on
                    : bitmaps.off;
    }
}

/* Simple implementation for rendering the state as text
class OnOffStateDrawable extends Text {
    public function initialize( isEnabled as Boolean ) {
        Text.initialize( {
            :text => getStateText( isEnabled ),
            :font => Graphics.FONT_SMALL,
            :color => getColor( isEnabled ),
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        } );
    }
    public function setEnabled( isEnabled as Boolean ) as Void {
        setColor( getColor( isEnabled ) );
        setText( getStateText( isEnabled ) );
    }
    private function getStateText( isEnabled as Boolean ) as String {
        return isEnabled ? "ON" : "OFF";
    }
    private function getColor( isEnabled as Boolean ) as ColorType {
        return isEnabled ? 0xe64a19 : Constants.UI_COLOR_INACTIVE;
    }
}
*/