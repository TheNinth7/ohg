import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Factory class for creating the appropriate object 
 * based on a given sitemap element.
 */
class SitemapWidgetFactory {

    // Create an element for a given type
    public static function createByType( 
        widget as JsonAdapter, 
        isSitemapFresh as Boolean,
        taskQueue as TaskQueue
    ) as SitemapWidget {

        // Determine the widget type
        var type = widget.getString( "type", "Widget without type" ); 

        // Based on the groupType of the Group item, the Group sitemap element
        // is either mapped to a type-specific widget (for consistent presentation)
        // or falls back to a generic Group widget if no specific type is supported.
        if( type.equals( "Group" ) ) {
            var groupType = 
                widget.getObject( "item", "Group without item" )
                    .getOptionalString( "groupType" );
            switch( groupType ) {
                case "Switch": type = "Switch"; break;
                case "Rollershutter": type = "Switch"; break;
                case "Dimmer": type = "Slider"; break;
            }
        }

        // Now we create the widget object based on the type
        if( type.equals( "Switch" ) || type.equals( "Selection" ) ) {
            return new SitemapSwitch( widget, isSitemapFresh, taskQueue );
        } else if( type.equals( "Setpoint" ) || type.equals( "Slider" ) ) {
            return new SitemapNumeric( widget, isSitemapFresh, taskQueue );
        } else if( type.equals( "Text" ) ) {
            return new SitemapText( widget, isSitemapFresh, taskQueue );
        } else if( type.equals( "Group" ) ) {
            return new SitemapGroup( widget, isSitemapFresh, taskQueue );
        } else if( type.equals( "Frame" ) ) {
            return new SitemapFrame( widget, isSitemapFresh, taskQueue );
        } else {
            throw new JsonParsingException( "Unsupported element type '" + type + "'." );
        }
    }
}