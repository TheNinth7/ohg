import Toybox.Lang;

/*
 * Exception thrown if the user tries to send a command but
 * there is no connectivity.
 */
class OfflineCommandException extends NonFatalUserInterfaceException {
    function initialize() {
        NonFatalUserInterfaceException.initialize( NonFatalUserInterfaceException.EX_OFFLINE );
    }

    public function getToastMessage() as String {
        return "OFFLINE";
    }
}