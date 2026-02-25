import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Widget class representing `Group` elements.
 * This widget does not require an associated item or additional JSON data.
 * It relies entirely on the default behavior of the parent class to handle the linked page.
 */
class SitemapGroup extends SitemapWidget {
    public function initialize( 
        json as JsonAdapter, 
        isSitemapFresh as Boolean,
        taskQueue as TaskQueue
    ) {
        SitemapWidget.initialize( 
            json, 
            null,
            null,
            isSitemapFresh,
            taskQueue as TaskQueue
        );
    }
}