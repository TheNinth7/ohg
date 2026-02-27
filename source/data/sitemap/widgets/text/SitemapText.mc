import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Text` elements.
 * Currently, it relies entirely on the functionality provided 
 * by its base class and does not add any additional behavior.
 */
class SitemapText extends SitemapWidget {

    // The associated item and its state
    private var _item as Item;

    public function initialize( 
        json as JsonAdapter, 
        isSitemapFresh as Boolean,
        taskQueue as TaskQueue
    ) {
        _item = new Item( json.getObject( "item", "Text '" + getLabel() + "' has no item" ), isSitemapFresh );

        // The superclass relies on the item for parsing the icon, 
        // therefore we initialize it after the item was created
        SitemapWidget.initialize( 
            json, 
            _item,
            null,
            isSitemapFresh,
            taskQueue
        );
    }
}