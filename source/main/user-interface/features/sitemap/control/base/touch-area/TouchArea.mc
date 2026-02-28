import Toybox.Lang;

/*
 * Abstract base class for touch-sensitive areas on the screen.
 *
 * A touch area represents a region that can respond to tap events
 * and trigger a corresponding action. This class holds only a unique
 * identifier (id), and defines an abstract contains(x, y) method that 
 * must be implemented by subclasses to determine if a given point 
 * lies within the touch area.
 *
 * Usage:
 * - Create a view that extends BaseControlView.
 * - Add instances of touch areas via addTouchArea().
 * - Alternatively, use InteractiveRelativeBitmap drawables with a defined touch identifier.
 * - Handle touch events by implementing BaseControlViewDelegate.onAreaTap().
 */
class TouchArea {
    // Handle the identifier
    private var _id as Symbol;
    protected function initialize( id as Symbol ) {
        _id = id;
    }
    public function getId() as Symbol {
        return _id;
    }

    // Abstract function for subclasses to implement
    public function contains( coordinates as [Number, Number] ) as Boolean {
        throw new AbstractMethodException( "TouchArea.contains" );        
    }
}