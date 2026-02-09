import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

/*
 * A collection of small helper functions.
 */
class LittleHelpers {
    
    // Compares two nullable objects and returns true if
    // both are equal, or both are null
    public static function nullSafeEquals( a as Object?, b as Object? ) as Boolean {
        return ( a == null && b == null ) || ( a != null && a.equals( b ) );
    }

    // Takes a nullable Drawable and if it is not null,
    // draws it on the provided Dc.
    public static function drawIfNotNull( drawable as Drawable?, dc as Dc ) as Void {
        if( drawable != null ) {
            drawable.draw( dc );
        }
    }

    // Takes a nullable tuple where the second element is
    // a Drawable, and draws if it is not null
    public static function drawTupleIfNotNull( tuple as [Object, Drawable]?, dc as Dc ) as Void {
        if( tuple != null ) {
            tuple[1].draw( dc );
        }
    }

    // Returns the width of a Drawable, taking into
    // consideration that the `StateText` has a 
    // precomputedWidth property, to compensate for the
    // incomplete implementation of the API's `Text.width`, 
    // which is not populated until after the draw
    public static function getDrawableWidthOrNull( drawable as Drawable? ) as Number? {
        return
            drawable == null
                ? null
                : getDrawableWidth( drawable );
    }
    public static function getDrawableWidth( drawable as Drawable ) as Number {
        return
            drawable instanceof StateText
                ? drawable.precomputedWidth
                : drawable.width.toNumber();
    }

    // Returns the height of a Drawable, taking into
    // consideration that the `StateText` has a 
    // getFontHeight function, to compensate for the
    // incomplete implementation of the API's `Text.height`, 
    // which is not populated until after the draw
    public static function getDrawableHeight( drawable as Drawable ) as Number {
        return
                drawable instanceof StateText                
                ? drawable.getFontHeight()
                : drawable.height.toNumber();
    }
}