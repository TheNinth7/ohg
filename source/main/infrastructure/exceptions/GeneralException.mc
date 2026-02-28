import Toybox.Lang;

/*
 * Base exception for all other errors.
 * Used when an exception does not fit into any of the more specific exception classes.
 */
 (:glance)
class GeneralException extends Exception {
    private var _msg as String;
    function initialize( msg as String ) {
        Exception.initialize();
        _msg = msg;
    }

    function getErrorMessage() as String or Null {
        return _msg;
    }
}