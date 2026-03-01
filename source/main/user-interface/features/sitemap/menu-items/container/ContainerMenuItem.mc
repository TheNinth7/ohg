import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This menu item implementation represents a frame, a container 
 * that holds other menu items.
 * The item's label displays the Frame's label, and in onSelectImpl(), 
 * it opens a PageMenu representing the Frame's content.
 */
class ContainerMenuItem extends BaseWidgetMenuItem {

    // Returns true if the given widget matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return sitemapWidget instanceof SitemapFrame
               || sitemapWidget instanceof SitemapGroup;
    }

    // Constructor
    // Initializes the base class and sets the menu view to open when this item is selected.
    public function initialize( 
        sitemapContainer as SitemapFrame or SitemapGroup, 
        parent as BasePageMenu,
        processingMode as BasePageMenu.ProcessingMode
    ) {
        BaseWidgetMenuItem.initialize( { 
            :sitemapWidget => sitemapContainer,
            :stateTextResponsive => sitemapContainer.getDisplayStateOrNull(),
            :parent => parent,
            :processingMode => processingMode
        } );
    }

    // When the state changes, change the displayed state text
    public function onStateChanged() as Void {
        setStateTextResponsive( getSitemapWidget().getDisplayStateOrNull() );
    }

}