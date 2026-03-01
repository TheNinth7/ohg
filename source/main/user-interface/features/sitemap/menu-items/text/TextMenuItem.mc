import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Menu item implementation for `Text` sitemap elements.
 * The text state is displayed in the state field of BaseSitemapMenuItem.
 * The state is extracted from the sitemap element's label, which contains
 * both the label text and the state enclosed in square brackets.
 * This approach is preferred over retrieving the state from the associated item,
 * as the embedded state includes any formatting defined for the sitemap text element.
 */
class TextMenuItem extends BaseWidgetMenuItem {
    
    // Returns true if the given widget matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return sitemapWidget instanceof SitemapText;
    }

    // Constructor
    public function initialize( 
        sitemapText as SitemapText,
        parent as BasePageMenu,
        processingMode as BasePageMenu.ProcessingMode
    ) {
        BaseWidgetMenuItem.initialize( {
            :sitemapWidget => sitemapText,
            :stateTextResponsive => sitemapText.getDisplayState(),
            :parent => parent,
            :processingMode => processingMode
        } );
    }

    // When the state changes, change the displayed state text
    public function onStateChanged() as Void {
        setStateTextResponsive( getSitemapWidget().getDisplayState() );
    }

}