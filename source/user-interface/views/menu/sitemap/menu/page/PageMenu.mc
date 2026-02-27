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

    // See BasePageMenu.invalidateStructure for details
    public function invalidateStructure() as Void {
        var parent = _weakParent.get() as BasePageMenu?;
        if( parent == null ) {
            throw new GeneralException( "Parent reference is no longer valid" );
        }
        parent.invalidateStructure();
    }
}