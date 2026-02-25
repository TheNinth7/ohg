import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Frame` elements.
 *
 * For frames, the list of widgets is embedded at the same JSON level as the widget itself.
 * Therefore, we populate the `linkedPage` member of the parent class with a
 * `SitemapFramePage`, created from the JSON object passed into this widget.
 */
class SitemapFrame extends SitemapWidget {

    public function initialize( 
        json as JsonAdapter, 
        isSitemapFresh as Boolean,
        taskQueue as TaskQueue
    ) {
        SitemapWidget.initialize( 
            json, 
            null,
            new SitemapFramePage( 
                json, 
                isSitemapFresh,
                taskQueue
            ),
            isSitemapFresh,
            taskQueue
        );
    }
}