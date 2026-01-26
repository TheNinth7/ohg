import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

/* Simple view that displays a message informing the user that
 * the phone connection is not available and that the app is
 * checking whether WiFi is available.
 */
class WifiCheckView extends WatchUi.View {

    private var _textArea as TextArea;

    // Constructor, creates the TextArea drawable.
    public function initialize() {
        View.initialize();
        
        _textArea = new TextArea( {
            :text => "No phone:\nchecking WiFi availability ...",
            :font => Constants.UI_ERROR_FONTS,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
            :color => Constants.UI_COLOR_WIFI,
            :backgroundColor => Constants.UI_COLOR_BACKGROUND
        } );
    }

    // Sets the size of the TextArea
    public function onLayout( dc as Dc ) {
        // We get the width and height of the drawing context
        // to calculate the size of the text area ...        
        var width = dc.getWidth();
        var height = dc.getHeight();

        // ... and for round screens, adapt it to the
        // largest square fitting into the circle
        if( System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND ) {
            width = width / Math.sqrt( 2 );
            height = width;
        }

        _textArea.setSize( width, height );
    }

    /*
    * While in the `WifiCheck`, all errors should trigger a full-screen error view.
    * Showing a toast is not useful in this context, as the loading state prevents 
    * meaningful user interaction.
    */
    public function onShow() as Void {
        ToastHandler.setUseToasts( false );
    }

    // Display the connectivity status message 
    function onUpdate( dc as Dc ) as Void {
        // We need to clear the clip, because there is bug in Garmin SDK,
        // with a clip in the menu title setting a clip in subsequent views
        // being displayed. See here for more details:
        // https://github.com/TheNinth7/ohg/issues/81
        dc.clearClip();

        dc.setColor( Constants.UI_COLOR_WIFI, Constants.UI_COLOR_BACKGROUND );
        dc.clear();

        _textArea.draw( dc );
    }
}