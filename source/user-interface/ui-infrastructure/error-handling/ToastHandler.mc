import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This static singleton class tracks whether toast notifications 
 * should currently be displayed and provides a function for showing them.
 */
public class ToastHandler {
    private static var _useToasts as Boolean = true;
    /*
    * Views should call this function in their `onShow()` method to indicate 
    * whether toast notifications should be displayed.
    *
    * Views should NOT modify this setting in `onHide()`. This allows subsequent 
    * views to inherit the state from the previous one—for example, only 
    * `HomepageMenu` needs to set it, and all following views will inherit the preference.
    */
    public static function setUseToasts( useToasts as Boolean ) as Void { 
        _useToasts = useToasts; 
    }

    /*
    * Indicates whether the current view has requested toast notifications.
    *
    * The final decision on whether a toast is shown is handled by the 
    * `ExceptionHandler`, as it considers additional factors beyond 
    * the view's preference.
    */
    public static function useToasts() as Boolean { 
        return _useToasts; 
    }

    // Show a warning toast
    public static function showWarning( warning as String ) as Void {
        WatchUi.showToast( 
            warning.toUpper(), 
            { :icon => Rez.Drawables.iconWarning } );
    }
}
