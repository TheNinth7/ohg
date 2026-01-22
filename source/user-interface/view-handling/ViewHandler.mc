import Toybox.Lang;
import Toybox.WatchUi;

/*
 * The `ViewHandler` must be used throughout the app for switching views 
 * or pushing/popping them from the stack.
 *
 * Its main purpose is to track how many views are currently on the stack, 
 * so that in case of an update or error, all views can be popped and 
 * replaced with the homepage or an error view.
 */
class ViewHandler {
    // Counter for views above the base view.
    // 0 = only the base view is on the stack.
    // 1 = two views are on the stack, and so on.
    private static var _stackSize as Number = 0;

    // Push/pop a view on/from the stack
    public static function pushView( view as Views, delegate as InputDelegates or Null, transition as SlideType ) as Void {
        WatchUi.pushView( view, delegate, transition );
        _stackSize++;
        // Logger.debug( "ViewHandler.pushView: new stack size=" + _stackSize );
    }
    public static function popView( transition as SlideType ) as Void {
        // Logger.debug( "ViewHandler.popView: previous stack size=" + _stackSize );
        if( _stackSize < 1 ) {
            throw new NonFatalUserInterfaceException( NonFatalUserInterfaceException.EX_POP_VIEW_ON_EMPTY_STACK );
        }
        _stackSize--;
        WatchUi.popView( transition );
        // Logger.debug( "ViewHandler.popView: new stack size=" + _stackSize );
    }

    // Removes all views from the stack except the base view,
    // and replaces the base view with the provided view.
    public static function popToBottomAndSwitch( view as Views, delegate as InputDelegates or Null ) as Void {
        // Logger.debug( "ViewHandler.popToBottomAndSwitch: previous stack size=" + _stackSize );
        while( _stackSize > 0 ) {
            WatchUi.popView( WatchUi.SLIDE_IMMEDIATE );
            _stackSize--;
        }
        // Logger.debug( "ViewHandler.popToBottomAndSwitch: new stack size=" + _stackSize );
        WatchUi.switchToView( view, delegate, WatchUi.SLIDE_BLINK );
    }
    /*
    public function getCurrentViewSafe() as [ WatchUi.View or Null, WatchUi.InputDelegates or Null ] {
        
        var cwArray = WatchUi.getCurrentView();
        if( ! (cwArray instanceof Array ) ) {
            throw new GeneralException( "cwArray not an Array" );
        } 
        if( cwArray.size() != 2 ) {
            throw new GeneralException( "cwArray.size = " + cwArray.size() );
        }
        
        var view = cwArray[0];
        if( view != null && ! ( view instanceof WatchUi.View ) ) {
            throw new GeneralException( "cwArray[0] not a View" );
        } 

        var delegate = cwArray[1];
        if( delegate != null && 
                ! ( delegate instanceof WatchUi.InputDelegate 
                    || delegate instanceof WatchUi.BehaviorDelegate
                    || delegate instanceof WatchUi.ConfirmationDelegate
                    || delegate instanceof WatchUi.MenuInputDelegate
                    || delegate instanceof WatchUi.NumberPickerDelegate
                    || delegate instanceof WatchUi.PickerDelegate
                    || delegate instanceof WatchUi.TextPickerDelegate
                    || delegate instanceof WatchUi.WatchFaceDelegate
                    || delegate instanceof WatchUi.Menu2InputDelegate
                    || delegate instanceof WatchUi.ViewLoopDelegate ) 
        ) {
            throw new GeneralException( "cwArray[1] not an input delegate" );
        }

        return cwArray;
    }
    */
}
