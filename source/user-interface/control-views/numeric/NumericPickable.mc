import Toybox.Lang;

/*
 * A CustomPickable implementation that combines a value and a unit
 * into a single display label.
 */
class NumericPickable extends CustomPickable {
    public function initialize( value as Number, unit as String ) {
        
        // On the Fenix 6 Pro there seems to be a bug that leads to floats being
        // passed into this function, and further passed onto the delegate, running
        // into our type check there.
        // https://github.com/openhab/openhab-garmin/issues/209
        // Therefore we ensure conversion to a Number here:
        // UPDATE: the source is reading from JSON, so this has been moved to JsonObjectAdapter
        // value = value.toNumber();
        
        // Initialize the parent class
        CustomPickable.initialize( value, value.toString() + unit );
    }
}