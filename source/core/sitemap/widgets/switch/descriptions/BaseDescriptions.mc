import Toybox.Lang;

/*
 * Base class for representing value/description pairs.
 * Common use cases include sitemap mappings, item command descriptions,
 * and item state descriptions.
 */
public class BaseDescriptions {
    
    private var _descriptions as Array<BaseDescription>;
    
    // We cache the size for faster access
    private var _size as Number;

    public function initialize( descriptions as Array<BaseDescription> ) {
        _descriptions = descriptions;
        _size = _descriptions.size();
    }

    public function hasDescriptions() as Boolean {
        return _size > 0;
    }

    public function get( i as Number ) as BaseDescription {
        return _descriptions[i];
    }

    // Lookup a command/state and if found return the label
    public function lookup( state as String ) as String? {
        for( var i = 0; i < _descriptions.size(); i++ ) {
            var description = _descriptions[i];
            if( description.equalsById( state ) ) {
                return description.getLabel();
            }
        }
        return null;
    }

    public function size() as Number {
        return _size;
    }
}