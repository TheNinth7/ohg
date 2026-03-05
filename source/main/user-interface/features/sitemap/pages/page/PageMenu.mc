import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

/*
 * The `PageMenu` is used for frame elements that appear below the `Homepage` element.
 * Currently, it inherits all necessary functionality from `BasePageMenu` and does not
 * require any additional behavior.
 */
class PageMenu extends BasePageMenu {

    // Parent is kept as weak reference to avoid
    // memory leaks due to circular references
    private var _weakParent as WeakReference;
    
    public function initialize( 
        sitemapContainer as SitemapContainerImplementation,
        parent as BasePageMenu,
        processingMode as BasePageMenu.ProcessingMode
    ) {
        BasePageMenu.initialize( 
            sitemapContainer, 
            null, 
            processingMode 
        );
        _weakParent = parent.weak();
    }

    // Overrides the base class addItem() to remove the loading
    // item if present.
    public function addItem( item as CustomMenuItem ) as Void {
        Logger.debug( "PageMenu.addItem" );
        if( getItem( 0 ) instanceof LoadingMenuItem ) {
            Logger.debug( "PageMenu.addItem: removing loading item" );
            deleteItem( 0 );
        }
        BaseMenu.addItem( item );
    }

    // Checks if menu items are present and adds the loading menu item
    // if none exist.
    // Pushing an empty menu as a view leads to weird side effects,
    // therefore this is called every time before a page menu is pushed.
    // The loading menu item is removed when the first real item
    // is added. See addItem() above.
    public function ensureItems() as Void {
        Logger.debug( "PageMenu.ensureItems" );
        if( getItemCount() < 1 ) {
            Logger.debug( "PageMenu.ensureItems: adding loading item" );
            BasePageMenu.addItem( new LoadingMenuItem() );
        }
    }

    // See BasePageMenu.invalidateStructure for details
    public function invalidateStructure() as Void {
        var parent = _weakParent.get() as BasePageMenu?;
        if( parent == null ) {
            throw new GeneralException( "Parent reference is no longer valid" );
        }
        parent.invalidateStructure();
    }
}