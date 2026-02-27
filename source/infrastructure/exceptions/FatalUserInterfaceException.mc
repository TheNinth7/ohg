import Toybox.Lang;

/*
 * Class for fatal user interface exceptions that should be displayed
 * to the user as full-screen error.
 */
class FatalUserInterfaceException extends GeneralException {
    function initialize( ex as Exception ) {
        GeneralException.initialize( "Fatal UI error: " + ex.getErrorMessage() );
    }
}
