import Toybox.Lang;

/*
 * Represents a state along with its description.
 * Used to handle both widget mappings and item command descriptions.
 */

class StateDescription extends BaseDescription {
    private var _value as String;
    
    public function initialize( value as String, label as String ) {
        BaseDescription.initialize( value, label );
        _value = value;
    }

    public function getValue() as String {
        return _value;
    }
}