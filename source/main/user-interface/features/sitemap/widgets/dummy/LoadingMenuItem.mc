import Toybox.Lang;
import Toybox.WatchUi;

class LoadingMenuItem extends StructuredMenuItem {
    
    // Constructor
    public function initialize() {
        StructuredMenuItem.initialize( { :label => "Loading..." } );
    }
}