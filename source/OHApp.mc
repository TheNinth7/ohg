import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

/*
 * Base class for the app. Responsible for initializing
 * the initial view for both glance and widget modes, as well
 * as handling logic that runs during app startup and shutdown.
 *
 * This class also includes logic executed when the app is updated
 * or when settings are changed.
 */
(:glance)
class OHApp extends Application.AppBase {

    // In some places we have different logic depending on
    // whether we are in the glance or widget
    private static var _glanceView as GlanceSitemapView?;
    public static function isGlance() as Boolean {
        return _glanceView != null;
    }

    // Constructor
    public function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    public function onStart(state as Dictionary?) as Void {
        // this could be used for startup logic that is common to
        // glance and widget. Currently there is none
    }

    // onStop() is called when the application is exiting
    (:typecheck(disableGlanceCheck))
    public function onStop(state as Dictionary?) as Void {
        // Logger.debug( "OHApp.onStop" );
        if( ! isGlance() ) {
            SitemapStore.persist();
        }
    }

    // Initializes the widget view
    (:typecheck(disableGlanceCheck))
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        try {
            // First we initialize the menu from storage
            var menu = HomepageMenu.createFromStorage();
            var hasMenu = menu != null;

            // Then we start the sitemap request
            SitemapRequest.get().start();
            
            // Starting the sitemap request may return an immediate error, which
            // SitemapRequest.onReceive reports to the ExceptionHandler via
            // handleException, and the ExceptionHandler stores it
            // consumeException then acts on the exception, and based if toasts
            // shall be used displays a toast for non-fatal errors, and in all
            // other cases returns an errorView for display.
            var errorView = ExceptionHandler.consumeStartupException( hasMenu );

            if( errorView != null ) {
                // If there is an error view, display it
                return [errorView];
            } else if( hasMenu ) {
                // If there is HomepageMenu, display it
                return [ menu as View, HomepageMenuDelegate.get() ];
            } else {
                // Otherwise show the loading view
                return [ new LoadingView() ];
            }
        } catch( ex ) {
            // Any exceptions occuring in this function are 
            // also displayed as error view
            return [ ErrorView.createOrUpdate( ex ) ];
        }
    }

    
    // Initializes the glance view
    function getGlanceView() as [ GlanceView ] or [ GlanceView, GlanceViewDelegate ] or Null {
        _glanceView = new GlanceSitemapView();
        return [ _glanceView ];
    }


    // If there is a new app version or app settings
    // have changed, we clear the storage to avoid
    // using data that may not apply anymore or
    // is structured differently than a new app version
    // expecteds.
    (:release) function onAppUpdate() as Void {
        Storage.clearValues();
    }
    function onSettingsChanged() as Void {
        // Logger.debug( "OHApp.onSettingsChanged" );
        Storage.clearValues();
    }

}