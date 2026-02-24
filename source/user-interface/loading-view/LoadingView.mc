import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

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

    // True if the loading view is currently showing
    public static function isShowing() as Boolean {
        return ViewHandler.getCurrentView()[0] instanceof LoadingView;
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
    // popped, the app returns to LoadingView, so we run the logic here in onShow().
    public function onShow() as Void {
        
        // While in the `LoadingView`, all errors should trigger a full-screen error view.
        // Showing a toast is not useful in this context, as the loading state prevents 
        // meaningful user interaction.
        ToastHandler.setUseToasts( false );
        
        // Logger.debug( "WifiCheckView: onShow" );

        // Check whether a sitemap update was run.
        // As indicated by "consume", this result is returned only once.
        // A subsequent call to consumeLastSyncResult will only return a value
        // if another sync has been executed.
        var lastSyncResult = SafeSitemapSyncDelegate.consumeLastSyncResult();
        
        try {
            // [0] is true, if a sync was done
            if( lastSyncResult[0] ) {
                // [1] contains an exception if the sync resulted in an error
                var syncEx = lastSyncResult[1];
                if( syncEx == null ) {
                    // If the sync was successful, we switch to the HomepageMenu
                    if( HomepageMenu.exists() ) {
                        WatchUi.switchToView( 
                            HomepageMenu.get(), 
                            HomepageMenuDelegate.get(), 
                            WatchUi.SLIDE_BLINK 
                        );
                    } else {
                        throw new GeneralException( "No sitemap found in storage, and loading via Wi-Fi failed. Please try again or connect to your phone." );
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


    // Display the loading message 
    function onUpdate( dc as Dc ) as Void {
        dc.setColor( ThemeManager.current.textColor, ThemeManager.current.backgroundColor );
        dc.clear();
        new Bitmap( {
            :rezId => ThemeManager.current.iconHourglass,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        } ).draw( dc );
    }
}
