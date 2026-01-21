import Toybox.Lang;

/*
 * Class for non-fatal user interface exceptions that should be displayed
 * to the user as a toast notification.
 */
 (:glance)
class NonFatalUserInterfaceException extends Exception {

    // Supported error codes
    enum ErrorCode {
        EX_POP_VIEW_ON_EMPTY_STACK, // UI:00
        EX_INVALID_STATE_TYPE,      // UI:01
        EX_INVALID_COMMAND          // UI:02
    }    

    // The error code of this instance
    private var _errorCode as ErrorCode;

    // Constructor
    public function initialize( errorCode as ErrorCode ) {
        _errorCode = errorCode;
        Exception.initialize();
    }

    // Maps error codes to toast messages
    public function getToastMessage() as String {
        return "UI:" + _errorCode.format( "%02u");
    }
}