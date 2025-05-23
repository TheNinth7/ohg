import Toybox.Lang;
import Toybox.WatchUi;

class NoStateMenuItem extends BaseSitemapMenuItem {
    
    // The text status Drawable
    private var _text as Text;

    // Constructor
    public function initialize( sitemapPrimitiveElement as SitemapPrimitiveElement ) {
        _text = new StatusText( "—" );
        BaseSitemapMenuItem.initialize(
            {
                :id => sitemapPrimitiveElement.id,
                :label => sitemapPrimitiveElement.label,
                :status => _text
            }
        );
    }

    // Updates the menu item
    public function update( sitemapElement as SitemapElement ) as Boolean {
        return true;
    }

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return 
            sitemapElement instanceof SitemapPrimitiveElement
            && ! sitemapElement.hasItemState() 
            && ! sitemapElement.hasWidgetState();
    }
}
