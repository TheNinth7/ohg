import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Application.Properties;

/*
 * The glance view of the app.
 */
(:glance) 
class GlanceSitemapView extends WatchUi.GlanceView {
    
    // Glance shows a single text area
    private var _textArea as TextArea;

    // Constructor
    public function initialize() {
        GlanceView.initialize();
        
        // Initialize the text area
        // Width and height can only be set once a Dc is available
        _textArea = new TextArea( { 
            :backgroundColor => Graphics.COLOR_TRANSPARENT,
            :font => GlanceConstants.UI_GLANCE_FONTS,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        } );
    }

    public function onUpdate( dc as Dc ) as Void {
        // If size has not been set yet, then set it
        if( _textArea.width == 0 ) {
            _textArea.setSize( dc.getWidth(), dc.getHeight() );
        }
        try {
            // Apply standard or night mode color
            if( System.getDeviceSettings().isNightModeEnabled ) {
                _textArea.setColor( GlanceConstants.UI_FONT_COLOR_NIGHT );
            } else {
                _textArea.setColor( GlanceConstants.UI_FONT_COLOR );
            }

            // Display either the homepage label or if it is not available a default
            var label = SitemapStore.getLabel();
            if( label != null ) {
                _textArea.setText( label );
            } else {
                _textArea.setText( "openHAB" );
            }
            
            // If an offset is defined in the constants,
            // we apply it here (currently used for Edge devices only)
            if( GlanceConstants.UI_GLANCE_TEXT_OFFSET != 0 ) {
                _textArea.setLocation( 
                    WatchUi.LAYOUT_HALIGN_CENTER, 
                    dc.getHeight()/2 - _textArea.height/2 + GlanceConstants.UI_GLANCE_TEXT_OFFSET
                );
            }
        } catch( ex ) {
            // Show any errors
            _textArea.setColor( Graphics.COLOR_RED );
            var msg = ex.getErrorMessage();
            msg = msg != null ? msg : "Unknown error";
            _textArea.setText( msg );
        }
        _textArea.draw( dc );
    }
}
