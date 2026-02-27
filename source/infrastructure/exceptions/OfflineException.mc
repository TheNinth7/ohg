import Toybox.Lang;

/*
 * Exception thrown if there is no connectivity.
 */
class OfflineException extends NonFatalUserInterfaceException {
    function initialize() {
        NonFatalUserInterfaceException.initialize( NonFatalUserInterfaceException.EX_OFFLINE );
    }

    public function getToastMessage() as String {
        return "OFFLINE";
    }
}