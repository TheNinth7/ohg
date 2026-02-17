import Toybox.Lang;

/*
 * The Math class lacks some utility functions, so we implement them here
 * (e.g. square(), min()).
 */
class CustomMath {
    public static function square( a as Numeric ) as Numeric {
        return a * a;
    }

    public static function min( a as Numeric, b as Numeric ) as Numeric {
        return a < b ? a : b;
    }

    public static function max( a as Numeric, b as Numeric ) as Numeric {
        return a > b ? a : b;
    }
}