import Toybox.Lang;

/*
 * Represents a single selectable option in the DynamicPicker.
 *
 * Each DynamicPickOption stores:
 * - A label (String) for display in the picker UI.
 * - A value object that is passed to the DynamicPickerDelegate's
 *   onUp(), onDown(), and onAccept() callbacks.
 */
class DynamicPickOption {
    private var _value as Object;
    private var _title as String;

    public function initialize( value as Object, label as String ) {
        _value = value;
        _title = label;
    }

    public function getValue() as Object {
        return _value;
    }

    public function getLabel() as String {
        return _title;
    }
}