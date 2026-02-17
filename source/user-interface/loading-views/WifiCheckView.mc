import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

/* Simple view that displays a message informing the user that
 * the phone connection is not available and that the app is
 * checking whether WiFi is available.
 */
/*
class WifiCheckView extends WatchUi.View {

    // Indicate to onUpdate() that this is the first execution
    private var _first as Boolean = true;
    
    // Drawable for the message
    private var _bitmap as Bitmap;


    // Constructor, creates the TextArea drawable.
    public function initialize() {
        View.initialize();
        
        _bitmap = new Bitmap( {
            :rezId => Rez.Drawables.iconSearchForWifi,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        } );
    }

    // Determins whether the WifiCheckView is currently showing
    public static function isShowing() as Boolean {
        return ViewHandler.getCurrentViewSafe()[0] instanceof WifiCheckView;
    }

    // Called when the view is shown.
    //
    // On startup, if we enter Wi-Fi mode and there is no sitemap, we trigger a sync.
    // If the sync succeeds, we switch to the HomepageMenu. Otherwise, any sync errors
    // are shown in a full-screen error view.
    //
    // Switching to those views is only possible after the user confirms the sync-mode
    // confirmation view and that view has been popped from the view stack.
    //
    // The API does not provide a callback for that exact moment. After the sync views are
    // popped, the app returns to WifiCheckView, so we run the logic here in onShow().
    public function onShow() as Void {
        
        // While in the `WifiCheck`, all errors should trigger a full-screen error view.
        // Showing a toast is not useful in this context, as the loading state prevents 
        // meaningful user interaction.
        ToastHandler.setUseToasts( false );
        
        // Logger.debug( "WifiCheckView: onShow" );

        // Check whether a sitemap update was run.
        // As indicated by "consume", this result is returned only once.
        // A subsequent call to consumeLastSyncResult will only return a value
        // if another sync has been executed.
        var lastSyncResult = SitemapSyncDelegate.get().consumeLastSyncResult();
        
        try {
            // [0] is true, if a sync was done
            if( lastSyncResult[0] ) {
                // [1] contains an exception if the sync resulted in an error
                var syncEx = lastSyncResult[1];
                if( syncEx == null ) {
                    // If the sync was successful, we switch to the HomepageMenu
                    if( HomepageMenu.exists() ) {
                        _bitmap.setBitmap( Rez.Drawables.iconHourglassBlue );
                        WatchUi.switchToView( 
                            HomepageMenu.get(), 
                            HomepageMenuDelegate.get(), 
                            WatchUi.SLIDE_BLINK 
                        );
                    } else {
                        throw new GeneralException( "WifiCheckView.onShow: HomepageMenu is missing." );
                    }
                } else {
                    // If the sync was not successful, throw the exception so it can be handled
                    // in the catch clause below.
                    throw syncEx;
                }
            }
        } catch( ex ) {
            // Switches to the full-screen error view.
            // This handles not only exceptions from the sync itself, but also any
            // exceptions that occur when switching to the HomepageMenu after a
            // successful sync.
            ExceptionHandler.handleSyncException( ex );
        }
    }

    // Display the connectivity status message 
    function onUpdate( dc as Dc ) as Void {
        // We need to clear the clip, because there is bug in Garmin SDK,
        // with a clip in the menu title setting a clip in subsequent views
        // being displayed. See here for more details:
        // https://github.com/TheNinth7/ohg/issues/81
        dc.clearClip();

        dc.clear();

        _bitmap.draw( dc );

        // See `WifiCheckTimer` for details
        if( _first == true ) {
            new WifiCheckTimer();
            _first = false;
        }
    }
}
*/