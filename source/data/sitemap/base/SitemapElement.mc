import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Base class for all sitemap elements, containing members
 * and functions common to both `SitemapWidget` and `SitemapPage`.
 *
 * This class includes only the functionality shared by both,
 * such as the indicator of whether the sitemap is still fresh,
 * and a parser function for widget labels and page titles,
 * which follow the same format.
 */
class SitemapElement {

    protected static const NO_DISPLAY_STATE as String = "—";

    private var _isSitemapFresh as Boolean;

    // Constructor
    protected function initialize( isSitemapFresh as Boolean ) {
        _isSitemapFresh = isSitemapFresh;
    }

    // Indicates whether the state is fresh
    // If received via web request, it is always considered
    // fresh, if read from storage it depends on the data's age
    public function isSitemapFresh() as Boolean {
        return _isSitemapFresh;
    }

    // Widget labels and page titles may include a display state in the format:
    //   label [state]
    // The display state represents the item's current state with display
    // patterns applied. 
    // This function parses the input into two parts: the label and the state,
    // and returns them as a tuple: [0] = label, [1] = state.
    protected static function parseLabelState( json as JsonAdapter, id as String, errorMessage as String ) as [String, String] {
        var fullLabel = json.getString( id, errorMessage );
        var label = fullLabel;
        var remoteDisplayState = null;
        var bracket = fullLabel.find( " [" ) as Number?;
        if( bracket != null ) {
            label = fullLabel.substring( null, bracket ) as String?;
            if( label == null ) {
                throw new JsonParsingException( "Label '" + label + "' does not have label before the [state]" );
            }
            remoteDisplayState = fullLabel.substring( bracket+2, fullLabel.length()-1 ) as String?;
        }
        if( remoteDisplayState == null || remoteDisplayState.equals( "-" ) ) {
            remoteDisplayState = NO_DISPLAY_STATE;
        }
        return [label, remoteDisplayState];
    }
}