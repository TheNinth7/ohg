import Toybox.Graphics;
import Toybox.WatchUi;

/*
 * A simple full-screen view that displays "Loading ...".
 *
 * This view is shown when the widget starts and no sitemap is available in storage— 
 * typically during the first launch after installation, a version update, 
 * or a settings change.
 */
class LoadingView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    /*
    * While in the `LoadingView`, all errors should trigger a full-screen error view.
    * Showing a toast is not useful in this context, as the loading state prevents 
    * meaningful user interaction.
    */
    public function onShow() as Void {
        ToastHandler.setUseToasts( false );
    }

    // Display the loading message 
    function onUpdate( dc as Dc ) as Void {
        dc.setColor( Constants.UI_COLOR_TEXT, Constants.UI_COLOR_BACKGROUND );
        dc.clear();
        new Text( {
            :text => "Loading ...",
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        } ).draw( dc );
    }
}
