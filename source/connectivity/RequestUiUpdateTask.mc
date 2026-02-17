import Toybox.Lang;

/*
 * Asynchronous task to be executed after HomepageMenu.hideStates updates the menu
 * structure with invalidated states.
 */
 class RequestUiUpdateTask {

    // Refresh the UI
    public function invoke() as Void {
        WatchUi.requestUpdate();
    }

    // Called by AsyncTaskQueue if there is an exception in invoke()
    public function handleException( ex as Exception ) as Void{
        ExceptionHandler.handleBackgroundException( ex );
    }
}
