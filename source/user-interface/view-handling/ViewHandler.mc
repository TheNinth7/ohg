import Toybox.Lang;
import Toybox.WatchUi;

/*
 * The `ViewHandler` must be used throughout the app for switching views, 
 * pushing/popping them from the stack and accessing the currently displayed
 * view. 
 * This allows the app to keep track of the view stack itself, enabling the
 * popToBottomAndSwitch function that returns to the root view and replaces it
 * with a given view.
 * Also it allows us to implement our own getCurrentView, since that API function
 * is not available on devices prior to CIQ 3.4.
 */
typedef ViewDelegateTuple as [View,InputDelegates or Null];

class ViewHandler {

    // Our own view stack
    private static var _viewStack as Array<ViewDelegateTuple> = [];

    // OHApp registers the initial view with this method.
    public static function registerInitialView( view as [View] or ViewDelegateTuple ) as Void {
        _viewStack.add( 
            view.size() == 1
            ? [view[0], null]
            : view 
        );
    }
    
    // Returns the current view
    public static function getCurrentView() as ViewDelegateTuple {
        return _viewStack[_viewStack.size() - 1];
    }

    // Push/pop a view on/from the stack
    public static function pushView( view as View, delegate as InputDelegates or Null, transition as SlideType ) as Void {
        WatchUi.pushView( view, delegate, transition );
        _viewStack.add( [view, delegate] );
        // Logger.debug( "ViewHandler.pushView: new stack size=" + _stackSize );
    }
    public static function popView( transition as SlideType ) as Void {
        // Logger.debug( "ViewHandler.popView: previous stack size=" + _stackSize );
        if( _viewStack.size() < 2 ) {
            throw new GeneralException( "ViewHandler.popView called on zero view stack size" );
        }
        _viewStack = _viewStack.slice( null, -1 );
        WatchUi.popView( transition );
        // Logger.debug( "ViewHandler.popView: new stack size=" + _stackSize );
    }

    // Removes all views from the stack except the base view,
    // and replaces the base view with the provided view.
    public static function popToBottomAndSwitch( view as View, delegate as InputDelegates or Null ) as Void {
        // Logger.debug( "ViewHandler.popToBottomAndSwitch: previous stack size=" + _stackSize );
        for( var i = _viewStack.size() - 1; i > 0; i-- ) {
            WatchUi.popView( WatchUi.SLIDE_IMMEDIATE );
        }
        _viewStack = [[view, delegate]];
        // Logger.debug( "ViewHandler.popToBottomAndSwitch: new stack size=" + _stackSize );
        WatchUi.switchToView( view, delegate, WatchUi.SLIDE_BLINK );
    }

     // Switch to a new view
    public static function switchToView( 
        view as WatchUi.Views, 
        delegate as WatchUi.InputDelegates or Null, 
        transition as WatchUi.SlideType
    ) as Void {
        WatchUi.switchToView( view, delegate, transition );
        _viewStack[_viewStack.size() - 1] = [view, delegate];
   }
}