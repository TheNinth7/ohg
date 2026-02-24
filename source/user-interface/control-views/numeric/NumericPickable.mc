import Toybox.Lang;

/*
 * CustomPickable implementation for float-based pickables.
 *
 * This implementation uses a SitemapNumeric instance to format
 * the displayed label of the pickable according to the configured
 * numeric formatting rules.
 */
class NumericPickable extends CustomPickable {
    public function initialize( value as Float, sitemapNumeric as SitemapNumeric ) {
        // Initialize the parent class
        CustomPickable.initialize( 
            value, 
            sitemapNumeric.formatStateWithUnitLong( value ) 
        );
    }
}