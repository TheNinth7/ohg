import Toybox.Lang;

/*
 * Task for asynchronously creating a sitemap element and
 * adding it to the parent container.
 */
class SitemapContainerBuildTask extends BaseSitemapProcessorTask {
    private var _sitemapContainer as SitemapContainer;
    private var _widget as JsonAdapter;
    private var _weakTaskQueue as WeakReference;

    // Constructor
    // Storing all the data we need for adding
    public function initialize( 
        sitemapContainer as SitemapContainer, 
        widget as JsonAdapter,
        taskQueue as TaskQueue
    ) {
        BaseSitemapProcessorTask.initialize();
        _sitemapContainer = sitemapContainer;
        _widget = widget;
        _weakTaskQueue = taskQueue.weak();
    }
    
    // Add the element
    public function invoke() as Void {
        var taskQueue = _weakTaskQueue.get() as TaskQueue?;
        if( taskQueue == null ) {
            throw new GeneralException( "TaskQueue reference is no longer valid" );
        }
        _sitemapContainer.addWidget(
            SitemapWidgetFactory.createByType( 
                _widget,
                _sitemapContainer.isSitemapFresh(),
                taskQueue
            )
        );
    }
}