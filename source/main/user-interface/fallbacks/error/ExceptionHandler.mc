import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;

/*
 * The `ExceptionHandler` should be used throughout the widget to handle unexpected exceptions.
 *
 * Its behavior includes:
 * - Showing a toast notification for non-fatal sitemap communication errors.
 * - Displaying a full-screen error view for non-fatal sitemap errors if the state is stale.
 * - Showing a toast notification for command communication errors, as these typically affect only 
 *   individual items and do not compromise the entire sitemap view.
 * - Displaying a full-screen error view immediately for all other errors.
 *
 * Full-screen errors are managed by `ErrorView`, while toast notifications are handled by `WarningToastHandler`.
 */
public class ExceptionHandler {
    /*
    * Note on STARTUP EXCEPTIONS:
    *
    * Most exceptions during startup are handled directly by `OHApp`, which starts 
    * into an error view if needed. However, startup also triggers the first sitemap request. 
    * If this request fails immediately (e.g., with error -104: no phone), `onReceive()` 
    * may be called before any view is ready to display the error.
    *
    * To handle this, such exceptions are stored by `handleException()` and later consumed 
    * by one of the two views that may be loaded initially: `LoadingView` or `HomepageMenu`.
    *
    * The stored value is a tuple consisting of the exception itself and a flag indicating 
    * whether it should already be treated as fatal.
    *
    * NOTE: The "non-fatal" flag in this tuple is not necessarily the same as `exception.isFatal()`.
    * An exception might not be inherently fatal, but may still be treated as such 
    * if it has persisted beyond a configured threshold.
    */
    private static var _startupException as [Exception, Boolean]?;
    
    /*
    * Used for handling communication and general errors happening during background processing.
    * There may still be some places in the code where this is used for user interface exceptions, but
    * those instances should all be migrated to handleUserInterfaceException.
    */
    public static function handleBackgroundException( ex as Exception ) as Void {
        // Logger.debug( "ExceptionHandler.handleBackgroundException" );
        Logger.debugException( ex );

        var isSitemapFresh = SitemapStore.isSitemapFresh();
        
        // Supress emtpy responses
        // If 
        // - the setting to suppress empty response errors is enabled
        // - and this exception is classified as such
        // - and the state is still within the expiry time, 
        // we do nothing further
        // Reading the configuration may lead to an error, in which case we
        // process this exception with the remainder of this function
        try {
            if( ex instanceof CommunicationBaseException
                && ex.suppressAsEmptyResponse()
                && AppSettings.suppressEmptyResponseExceptions()
                && isSitemapFresh 
            ) {
                    // Logger.debug( "ExceptionHandler: Suppressing empty response" );
                    return;
            }
        } catch( ex1 ) {
            ex = ex1;
        }

        /*
        * A toast notification will be shown under the following conditions:
        * - Only if the current view has indicated to the `WarningToastHandler` that toasts are allowed.
        * - For all non-sitemap (i.e., command) communication errors.
        * - For sitemap errors that are not fatal in themselves and 
        *   the state is still fresh (within the state expiry time).
        *
        * In all other cases, a full-screen error view is displayed instead.
        */
        if( WarningToastHandler.useToasts()
            && ex instanceof CommunicationBaseException 
            &&  ( ! ex.isFrom( CommunicationBaseException.EX_SOURCE_SITEMAP )
                  || ( isSitemapFresh && !ex.isFatal() ) ) 
        ) {
            // Logger.debug( "ExceptionHandler: non-fatal error: " + ex.getToastMessage().toUpper() );
            
            // If there is no view yet, the exception is stored
            // as startup exception, otherwise the toast will be shown
            if( ViewStack.getCurrentView()[0] == null ) {
                // Logger.debug( "ExceptionHandler: storing non-fatal startup exception" );
                _startupException = [ex, false];
            } else {
                WarningToastHandler.showWarning( ex.getToastMessage() );
            }
        } else {
            // Logger.debug( "ExceptionHandler: fatal error" );
            
            // Fatal errors clear the stored JSON to avoid showing outdated data.
            // After a fatal error, the menu is only shown once a new successful
            // response is received. Without clearing the cache, restarting the app
            // would briefly show the menu before the error happens again.
            // Clearing the cache ensures the app goes directly into a loading or
            // error view until valid data is received.
            SitemapStore.deleteSitemapFromStorage();
            
            // If no view is currently active, the exception is stored as a startup exception.
            // Otherwise, the full-screen error view is shown immediately.
            if( ViewStack.getCurrentView()[0] == null ) {
                // Logger.debug( "ExceptionHandler: storing fatal startup exception" );
                _startupException = [ex, true];
            } else {
                ErrorView.showOrUpdate( ex );
            }
        }
    }


    /*
    * Used to handle errors from a sitemap sync that is automatically triggered on app startup.
    *
    * Errors that occur while sending a command or during a user-triggered sitemap sync
    * are already handled by the sync API and are shown in the sync confirmation view.
    * No additional error handling by the app is required in those cases.
    */
    public static function handleSyncException( ex as Exception ) as Void {
        // Logger.debug( "ExceptionHandler.handleSyncException" );
        Logger.debugException( ex );

        // If no view is currently active, the exception is stored as a startup exception.
        // Otherwise, the full-screen error view is shown immediately.
        if( ViewStack.getCurrentView()[0] == null ) {
            // Logger.debug( "ExceptionHandler: storing sync startup exception" );
            _startupException = [ex, true];
        } else {
            ErrorView.showOrUpdate( ex );
        }
    }


    /*
    * Used for handling errors coming from user interface interactions.
    */
    public static function handleUserInterfaceException( ex as Exception ) as Void {
        // Logger.debug( "ExceptionHandler.handleUserInterfaceException" );
        Logger.debugException( ex );

        // While this should not happen, we check if we are in the startup phase,
        // and if yes, ignore the exception
        if( ViewStack.getCurrentView()[0] != null ) {
            // NonFatalUserInterfaceException is used for non-fatal UI exceptions, for which
            // we will show a toast notification
            if( ex instanceof NonFatalUserInterfaceException ) {
                WarningToastHandler.showWarning( ex.getToastMessage() );
            } else {
                // In case of a fatal UI error we stop doing sitemap requests
                SitemapRequest.get().stop();
                
                // If the exception is not already a FatalUserInterfaceException, we wrap
                // it in one
                if( ! ( ex instanceof FatalUserInterfaceException ) ) {
                    ex = new FatalUserInterfaceException( ex );
                }
                
                // Show the error view
                ErrorView.showOrUpdate( ex );
            }
        }
    }


    /*
    * This function must be called by views by `OHApp` in getInitialView().
    *
    * Depending on the type of exception that occurred during startup, 
    * it will display either a toast notification or return a full-screen 
    * error view.
    */
    public static function consumeStartupException( useToast as Boolean ) as ErrorView? {
        if( _startupException != null ) {
            var startupException = _startupException;
            _startupException = null;
            var ex = startupException[0];
            
            /*
            * A toast is shown if the startup exception is a non-fatal 
            * communication error and the calling view has enabled toast notifications.
            */
            if( useToast && !startupException[1] && ex instanceof CommunicationBaseException ) {
                WarningToastHandler.showWarning( ex.getToastMessage() );
            } else {
                return ErrorView.createOrUpdate( ex );
            }
        }
        return null;
    }
}