import Toybox.Lang;
import Toybox.Math;

/*
 * Touch area defined by a circular shape.
 *
 * This class represents a touch-sensitive area in the form of a circle.
 * The contains(x, y) method determines whether a point lies within
 * the circular region.
 *
 * See TouchArea for details.
 */
class CircularTouchArea extends TouchArea {

    // The coordinates and radius
    // defining the circle
    private var _x as Number;
    private var _y as Number;
    private var _squareRadius as Number; // we store the squared radius, see below for details

    public function initialize( 
        id as Symbol, 
        x as Number,
        y as Number,
        radius as Number ) 
    {
        TouchArea.initialize( id );
        _x = x;
        _y = y;
        
        // For the contains() function we need to squared radius,
        // so we do that calculation right away
        _squareRadius = CustomMath.square( radius ).toNumber();
    }

    // Formula for calculating if a given point is within
    // the circle, based on its distance to the center of
    // the circle
    public function contains( coordinates as [Number, Number] ) as Boolean {
        return 
            (
                CustomMath.square( coordinates[0] - _x )
                + CustomMath.square( coordinates[1] - _y ) 
            )
            <= _squareRadius;
    }
}