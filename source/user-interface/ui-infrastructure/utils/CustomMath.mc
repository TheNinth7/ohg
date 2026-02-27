import Toybox.Lang;
import Toybox.Math;

/*
 * The Math class lacks some utility functions, so we implement them here
 * (e.g. square(), min()).
 */
class CustomMath {

    public static function abs( x as Numeric ) as Numeric {
        return x < 0 ? -x : x;
    }

    // Returns the number of decimal places in a float
    public static function getDecimalPlaces( value as Float, maxDigits as Number ) as Number {

        // epsilon = 10^-(maxDigits + 1)
        var epsilon = 1.0;
        for (var i = 0; i < maxDigits + 1; i++) {
            epsilon /= 10.0;
        }

        var scaled = value;

        for (var digits = 0; digits <= maxDigits; digits++) {

            var rounded = scaled.toNumber();

            if( abs( scaled - rounded ) < epsilon) {
                return digits;
            }

            scaled *= 10.0;
        }

        return maxDigits;
    }

    public static function max( a as Numeric, b as Numeric ) as Numeric {
        return a > b ? a : b;
    }

    public static function min( a as Numeric, b as Numeric ) as Numeric {
        return a < b ? a : b;
    }

    public static function round( value as Numeric, decimalPlaces as Number ) as Numeric {
        var multiplier = Math.pow( 10, decimalPlaces );
        return Math.round( value * multiplier ) / multiplier;
    }

    public static function square( a as Numeric ) as Numeric {
        return a * a;
    }

}