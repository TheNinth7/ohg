import Toybox.Lang;

/*
 * Asynchronous task to be executed after ConnectivityHandler updates the menu
 * structure with invalidated states. If the menu is currently visible, the UI
 * is refreshed; otherwise, the menu is pushed onto the view stack.
 */
 class WifiCheckRefreshUiTask {

    public function invoke() as Void {

        if( HomepageMenu.isSitemapShowing() ) {
            WatchUi.requestUpdate();
        } else {
            if( HomepageMenu.exists() ) {
                ViewHandler.popToBottomAndSwitch( HomepageMenu.get(), HomepageMenuDelegate.get() );
            } else {
                throw new GeneralException( "WifiCheckRefreshUiTask: HomepageMenu does not exist" );
            }
        }
    }

    public function handleException( ex as Exception ) as Void{
        ExceptionHandler.handleException( ex );
    }
}
