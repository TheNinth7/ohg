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
            throw new GeneralException( "ViewHandler.popView called on zero view stack size" );
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
}