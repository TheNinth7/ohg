import Toybox.Lang;

/*
 * Asynchronous task to be executed after ConnectivityHandler updates the menu
 * structure with invalidated states. If the menu is currently visible or we are
 * in the settings, the UI is refreshed; otherwise, the menu is pushed onto the view stack.
 */
 class WifiCheckRefreshUiTask {

    public function invoke() as Void {
        if( HomepageMenu.isSitemapShowing() || SettingsMenuHandler.isShowingSettings() ) {
            WatchUi.requestUpdate();
        } else {
            if( HomepageMenu.exists() ) {
                ViewHandler.popToBottomAndSwitch( HomepageMenu.get(), HomepageMenuDelegate.get() );
            } else {
                throw new GeneralException( "WifiCheckRefreshUiTask: HomepageMenu does not exist" );
            }
        }
    }

    // Called by AsyncTaskQueue if there is an exception in invoke()
    public function handleException( ex as Exception ) as Void{
        ExceptionHandler.handleBackgroundException( ex );
    }
}
