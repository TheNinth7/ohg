import Toybox.Lang;

/*
 * Base class for textual descriptions identified by an ID.
 * Used for widget mappings, item commands, and state descriptions.
 */

 // An array of descriptions
typedef BaseDescriptionArray as Array<BaseDescription>;

class BaseDescription {
    private var _id as String;
    private var _label as String;
 
    // Constructor
    protected function initialize( id as String, label as String ) {
        _id = id;
        _label = label;
    }

    // Checks if the ID of this instance equals a given ID
    public function equalsById( otherId as String ) as Boolean {
        return _id.equals( otherId );
    }

    // Returns the label
    public function getLabel() as String {
        return _label;
    }
}