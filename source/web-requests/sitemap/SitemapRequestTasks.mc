import Toybox.Lang;

/*
 * This file defines all asynchronous task classes used to update an existing
 * menu structure based on responses from `SitemapRequest`.
 *
 * NOTE: Many of these tasks are time-consuming and will therefore schedule
 * additional asynchronous tasks to the *front of the queue*, ensuring they
 * are executed before the next queued task.
 *
 * The response is processed using the following task sequence:
 *
 * 1) ProcessIncomingJsonTask:
 *    Triggered by `SitemapRequest` with a JSON dictionary as input.
 *    It creates a `SitemapHomepage` and schedules the next task in the sequence.
 *
 *    If no menu exists yet, this task initiates:
 *      1.1) CreateHomepageTask:
 *           Initializes the menu structure using asynchronous tasks.
 *      1.2) SwitchToHomepageTask:
 *           Switches from the current view to the `HomepageMenu`.
 *
 *    If a menu already exists, it initiates:
 *      1.3) UpdateHomepageTask:
 *           Updates the existing menu structure asynchronously.
 *      1.4) RefreshUiTask:
 *           Refreshes the UI based on the current state:
 *           - If in a valid menu, refreshes the current screen.
 *           - If the menu structure is invalid or an error view is active, 
 *             navigates to the homepage menu.
 *           - If in the settings menu, does nothing.
 *
 * 2) MakeNextRequestTask:
 *    Triggered at the end of both the above sequences (from either
 *    SwitchToHomepageTask or RefreshUiTask) to initiate the next request.
 */

// Base class for asynchronous tasks that implement the
// processing of menu initialization and update
class BaseSitemapProcessorTask {
    protected function initialize() {
    }
    public function handleException( ex as Exception ) as Void {
        SitemapRequest.get().handleException( ex );
    }
}

// 1)
// The first task initalizes with the incoming JSON
// and a instantiates a SitemapHomepage to reepresent it
// This is a recursive process, and SitemapPage, the base
// class of SitemapHomepage, will create tasks on its own
// for the processing. These tasks are added to THE FRONT
// OF THE QUEUE, and therefore will be executed before 
// the next step is triggered.
class ProcessIncomingJsonTask extends BaseSitemapProcessorTask {

    private var _json as SitemapJsonIncoming;
    public function initialize( json as SitemapJsonIncoming ) {
        BaseSitemapProcessorTask.initialize();
        _json = json;
    }

    public function invoke() as Void {
        // Logger.debug( "ProcessIncomingJsonTask.invoke" );

        var sitemapHomepage = SitemapStore.updateSitemapFromJson( _json );

        if( ! HomepageMenu.exists() ) {
            // No menu exists yet, so we process the JSON and transition 
            // from the LoadingView to the menu.
            // This can also happen after an out-of-memory exception,
            // where the menu was cleared — in that case, we switch
            // from the ErrorView to the new menu.
            AsyncTaskQueue.get().add( new CreateHomepageTask( sitemapHomepage ) );
        } else {
            // There is already a menu, so we update it,
            // asynchronously to not block the UI
            AsyncTaskQueue.get().add( new UpdateHomepageTask( sitemapHomepage ) );
        }
    }
}


// 1.1)
// Creates the HomepageMenu and then switches to it. Since initialization is
// time-consuming, HomepageMenu.create() schedules its own tasks to the
// front of the queue. The view switch is added to the back of the queue and
// will be processed only after all initialization tasks have completed.
class CreateHomepageTask extends BaseSitemapProcessorTask {
    private var _sitemapHomepage as SitemapHomepage;

    public function initialize( sitemapHomepage as SitemapHomepage ) {
        BaseSitemapProcessorTask.initialize();
        _sitemapHomepage = sitemapHomepage;
    }
    
    public function invoke() as Void {
        // Logger.debug( "CreateHomepageMenuTask.invoke" );
        // The whole logic fits in one statement, we
        // create the new HomepageMenu, feed it into
        // the SwitchToHomepageTask and schedule that task
        AsyncTaskQueue.get().add(
            new SwitchToHomepageTask(
                HomepageMenu.createFromWebResponse( _sitemapHomepage )
            )
        );
    }
}

// 1.2)
// Switches to the newly created HomepageMenu view and
// triggers the next sitemap request
class SwitchToHomepageTask extends BaseSitemapProcessorTask {
    private var _homepageMenu as HomepageMenu;

    public function initialize( homepageMenu as HomepageMenu ) {
        BaseSitemapProcessorTask.initialize();
        _homepageMenu = homepageMenu;
    }
    
    public function invoke() as Void {
        // Logger.debug( "SwitchToHomepageTask.invoke" );
        WatchUi.switchToView( 
            _homepageMenu, 
            HomepageMenuDelegate.get(), 
            WatchUi.SLIDE_BLINK 
        );
        AsyncTaskQueue.get().add( new TriggerNextRequestTask() );
    }
}


// 1.3)
// The first step for an update it to update the menu structure ...
class UpdateHomepageTask extends BaseSitemapProcessorTask {

    // This tasks needs the SitemapHomepage representing the
    // newly incoming data as input
    private var _sitemapHomepage as SitemapHomepage;
    public function initialize( sitemapHomepage as SitemapHomepage ) {
        BaseSitemapProcessorTask.initialize();
        _sitemapHomepage = sitemapHomepage;
    }

    public function invoke() as Void {
        // Logger.debug( "UpdateHomepageTask.invoke" );
        if( ! HomepageMenu.exists() ) {
            throw new GeneralException( "HomepageMenu does not exist" );
        }
        
        HomepageMenu.get().update( _sitemapHomepage );

        AsyncTaskQueue.get().add( new RefreshUiTask() );
    }
}

// 1.4)
// ... and then we update the UI
//
// Refresh the UI based on the current context and menu validity:
//
// - If currently in a menu and the menu structure remains valid (as per task input),
//   refresh the current screen.
// - If the menu structure is no longer valid, navigate to the root (homepage) menu.
// - If currently in an error view, also navigate to the homepage menu.
// - If currently in the settings menu, do nothing.
class RefreshUiTask extends BaseSitemapProcessorTask {

    public function initialize() {
        BaseSitemapProcessorTask.initialize();
    }

    public function invoke() as Void {
        
        // Logger.debug( "RefreshUiTask.invoke" );

        if( ! HomepageMenu.exists() ) {
            throw new GeneralException( "HomepageMenu does not exist" );
        }

        var homepage = HomepageMenu.get();

        // If we are in the settings menu, we do nothing
        if( ! SettingsMenuHandler.isShowingSettings() ) {
            // If the structure is not valid anymore or an error view
            // view is shown, we reset the view to the homepage
            if( ( ! homepage.structureRemainsValid() 
                    && ! ( WatchUi.getCurrentView()[0] instanceof HomepageMenu ) )
                || ErrorView.isShowing() )
                {
                // Logger.debug( "SitemapRequest.onReceive: resetting to homepage" );
                ViewHandler.popToBottomAndSwitch( homepage, HomepageMenuDelegate.get() );
            } else {
                // If the structure is still valid and no error is shown,
                // then we update the screen, showing the changes in the
                // currently displayed menu
                // Logger.debug( "SitemapRequest.onReceive: requesting UI update" );
                WatchUi.requestUpdate();
            }
        }
        AsyncTaskQueue.get().add( new TriggerNextRequestTask() );
    }
}

// 2)
// ... and finally, we trigger the next request
class TriggerNextRequestTask extends BaseSitemapProcessorTask {
    public function initialize() {
        BaseSitemapProcessorTask.initialize();
    }
    public function invoke() as Void {
        // Logger.debug( "TriggerNextRequestTask.invoke" );
        SitemapRequest.get().triggerNextRequest();
    }
}
