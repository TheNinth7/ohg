import Toybox.Lang;

/*
 * Touch area defined by a rectangular shape.
 *
 * This class represents a touch-sensitive area in the form of a rectangle.
 * The contains(x, y) method determines whether a point lies within
 * the circular region.
 *
 * See TouchArea for details.
 */
class RectangularTouchArea extends TouchArea {

    // Coordinates of the upper left 
    // and lower right corner
    private var _x1 as Number;
    private var _y1 as Number;
    private var _x2 as Number;
    private var _y2 as Number;

    public function initialize( 
        id as Symbol, 
        x as Number,
        y as Number,
        width as Number,
        height as Number ) 
    {
        TouchArea.initialize( id );
        _x1 = x;
        _y1 = y;
        _x2 = x + width;
        _y2 = y + height;
    }

    // Formula for checking if a set of coordinates lies
    // within the rectangle
    public function contains( coordinates as [Number, Number] ) as Boolean {
        return 
            ( coordinates[0] >= _x1 && coordinates[0] <= _x2 )
            &&
            ( coordinates[1] >= _y1 && coordinates[1] <= _y2 );
    }
}