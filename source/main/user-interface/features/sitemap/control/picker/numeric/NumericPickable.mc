import Toybox.Lang;

/*
 * DynamicPickOption implementation for float-based pickables.
 *
 * This implementation uses a SitemapNumeric instance to format
 * the displayed label of the pickable according to the configured
 * numeric formatting rules.
 */
class NumericPickable extends DynamicPickOption {
    public function initialize( value as Float, sitemapNumeric as SitemapNumeric ) {
        // Initialize the parent class
        DynamicPickOption.initialize( 
            value, 
            sitemapNumeric.formatStateWithUnitLong( value ) 
        );
    }
}