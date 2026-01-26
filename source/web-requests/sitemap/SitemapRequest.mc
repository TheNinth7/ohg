import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.Application.Storage;
import Toybox.Application;
import Toybox.Timer;

/*
 * This class handles web requests for sitemap data and follows the Singleton pattern.
 *
 * Responsibilities:
 * - Constructs the URL for the sitemap request.
 *
 * - Implements Communication.makeWebRequest:
 *     - start(): initiates the first web request.
 *     - After each response, schedules the next request based on the polling interval.
 *       If the polling interval is 0, the next request is triggered immediately.
 *     - stop(): halts all further web requests.
 *       If a request is already in progress, its response will be ignored after stop() is called.
 *
 * - Implements onReceive() to process responses:
 *     - On success, forwards the incoming JSON to the `SitemapProcessor`.
 *
 * - Implements handleError() to process errors that occur in onReceive() or within
 *   the `SitemapProcessor`. This function schedules the next request based on both
 *   the minimum error polling interval and the configured regular polling interval.
 *
 * - Implements logic for triggering the next request, applying the appropriate delay
 *   based on the current polling configuration.
 */
class SitemapRequest extends BaseRequest {
    
    /******* STATIC *******/ 

    // Singleton instance and accessor
    private static var _instance as SitemapRequest?;

    public static function get() as SitemapRequest {
        if( _instance == null ) {
            _instance = new SitemapRequest();
        }
        return _instance as SitemapRequest;
    }

    /******* INSTANCE *******/ 

    public const SITEMAP_ERROR_MINIMUM_POLLING_INTERVAL as Number = 1000;

    // Defines the source value to be used for exception handling
    private const SOURCE as CommunicationBaseException.Source = CommunicationBaseException.EX_SOURCE_SITEMAP;

    // The assembled URL for the request
    private var _url as String;
    
    // Members for controlling the behavior when stopped.
    // if _stopCount is > 0, no further requests will be allowed
    // Each stop will increase the stop count, and only after
    // one start was called for each stop, requests are continued
    // We start stopped, so the initial value is 1
    private var _stopCount as Number = 1;

    // _hasPendingRequest is true if we are inbetween a makeRequest()
    // and an onReceive
    private var _hasPendingRequest as Boolean = false;
    // If stop() is called and there is a pending request, this
    // is set to true to instrucht onReceive() to ignore the
    // next incoming response.
    private var _ignoreNextResponse as Boolean = false;

    // Members for controlling the web request loop
    private var _pollingInterval as Number;
    private var _timer as Timer.Timer = new Timer.Timer();

    // Stores the number of requests sent, for debugging
    // purposes
    private var _requestCount as Number = 0;
    private var _responseCount as Number = 0;

    // Store the memory usage before making the request, to
    // estimate the memory used by the received JSON
    // See `SitemapStore` for details.
    private var _memoryUsedBeforeRequest as Number = 0;

    // Constructor
    private function initialize() {
        // Initialize super class
        BaseRequest.initialize( Communications.HTTP_REQUEST_METHOD_GET );
        // Set response content type
        setOption( :responseType, Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON );

        // Set the polling interval
        _pollingInterval = AppSettings.getPollingInterval();
        
        // Assemble the URL
        _url = AppSettings.getUrl() + "rest/sitemaps/" + AppSettings.getSitemap();
    }

    // Handles exceptions from onReceive() and the SitemapProcessor.
    // The exception is passed to the ExceptionHandler, and the next
    // request is scheduled using a delay based on the greater of:
    // - the error polling interval, or
    // - the configured regular polling interval.
    public function handleException( ex as Exception ) as Void {
        // Logger.debug( "SitemapRequest.handleException" );
        // Logger.debugMemory( null );

        // If an out-of-memory error occurs, it might be due to a sitemap change
        // where parts of the old and new menu structures coexist in memory.
        // To prevent this, we clear the menu so the next request starts fresh.
        if( ex instanceof OutOfMemoryException ) {
            HomepageMenu.clear();
        }

        ExceptionHandler.handleException( ex );
        
        // If an error occurs during processing the sitemap from
        // storage, the request is already schedule and we do 
        // not need to to it anymore
        if( ! _hasPendingRequest ) {
            triggerNextRequestInternal( 
                _pollingInterval > SITEMAP_ERROR_MINIMUM_POLLING_INTERVAL
                    ? _pollingInterval
                    : SITEMAP_ERROR_MINIMUM_POLLING_INTERVAL 
            );
        }
    }

    // Makes the web request
    public function makeRequest() as Void {
        // If we are stopped we do not execute any make
        // requests anymore
        if( _stopCount <= 0 && ! _hasPendingRequest ) {
            _requestCount++;
            // Logger.debug( "SitemapRequest.makeRequest (#" + _requestCount + ")" );
            // Logger.debugMemory( null );
            
            // _hasPendingRequest has to be set to true BEFORE makeWebRequest
            // For some errors (like -104/no phone), on receive is called
            // synchronously by makeWebRequest. If in this case, 
            // _hasPendingRequest would come after makeWebRequest it would
            // be set to true without there being any pending web request,
            // which would cancel the next request and thus stop the
            // sitemap request loop
            _hasPendingRequest = true;
            Communications.makeWebRequest( _url, null, getBaseOptions(), method( :onReceive ) );
            _memoryUsedBeforeRequest = System.getSystemStats().usedMemory;
        } else {
            // Logger.debug( "SitemapRequest.makeRequest: stopped or has pending request, not executed" );
        }
    }

    // Processes the response
    public function onReceive( 
        responseCode as Number, 
        data as Dictionary<String,Object?> 
            or String 
            or PersistedContent.Iterator 
            or Null 
    ) as Void {
        _hasPendingRequest = false;
        _responseCount++;
        // Logger.debug( "SitemapRequest.onReceive: start (#" + _responseCount + ")" );

        // When stop() is called, and there is a pending request, then
        // _ignoreNextResponse is set true. onReceive() acts on this,
        // ignores the next response and resets the member
        if( _ignoreNextResponse ) {
            // Logger.debug( "SitemapRequest.onReceive: ignoring this response");
            _ignoreNextResponse = false;
        } else {
            try {
                // Verify response code and response data (in the call to process)
                // These functions of the super class throw an exception if the 
                // code/data is not OK. Additionally checkResponseCode may return
                // false in conditions where no error is raised but the response
                // shall be ignored
                if( checkResponseCode( responseCode, SOURCE ) ) {
                    
                    // Any positive result indicates that the phone connection is working.
                    // Note that the exception handler also performs this confirmation
                    // for all errors except no-phone errors.
                    ConnectivityHandler.get().confirmPhoneConnection();
                    
                    // The JSON is processed by processIncomingJson()
                    processIncomingJson( 
                        new SitemapJsonIncoming( 
                            checkResponse( data, SOURCE ), 
                            System.getSystemStats().usedMemory
                                - _memoryUsedBeforeRequest 
                        )
                    );
                }
            } catch( ex ) {
                // Calling the handler for exceptions
                // Logger.debug( "SitemapRequest.onReceive: exception");
                handleException( ex );
            }
        }
        // Logger.debug( "SitemapRequest.onReceive: end");
    }

    /*
    * Processes the incoming JSON data by:
    * - Updating the SitemapStore
    * - Asynchronously creating or updating the menu structure
    * - Passing any exceptions to the handleException() function below
    * - Triggering the next request
    *
    * The work is broken down into small tasks and processed via the AsyncTaskQueue.
    * This allows recursive data structures to be handled iteratively, avoiding stack overflows
    * and reducing the risk of prolonged code execution errors
    * (e.g., "Watchdog Tripped Error - Code Executed Too Long").
    * It also helps maintain UI responsiveness.
    *
    * For task sequencing details, see SitemapRequestTasks.mc.
    */
    private function processIncomingJson( incomingJson as SitemapJsonIncoming ) as Void {
        // Logger.debug( "SitemapRequest.incomingJson" );

        var taskQueue = AsyncTaskQueue.get();

        // Under normal circumstances, the queue should be empty at this point,
        // as each new request is only triggered as the final step of processing
        // the previous one. The only exception is during startup, when an initial
        // request is sent immediately and processed in parallel with the asynchronous
        // loading of the sitemap from storage. In this case, it's possible that the
        // response arrives before the sitemap has finished loading. If that happens,
        // we cancel any remaining tasks and proceed directly with processing the response.
        if( ! taskQueue.isEmpty() ) {
            // Logger.debug( "SitemapRequest encountered non-empty task queue" );
            taskQueue.removeAll();
        }

        // If the menu hasn’t been created yet, we're likely in a non-interactive
        // loading or error view. In this state, we prioritize speed over responsiveness
        // to complete processing as quickly as possible.
        if( ! HomepageMenu.exists() ) {
            taskQueue.prioritizeSpeed();
        } else {
            taskQueue.prioritizeResponsiveness();
        }

        // Start with the first task; it will handle scheduling all 
        // subsequent tasks as needed.
        taskQueue.add( new ProcessIncomingJsonTask( incomingJson ) );
    }

    // Start the request loop
    public function start() as Void {
        // Logger.debug( "SitemapRequest.start" );
        if( _stopCount <= 0 ) {
            throw new GeneralException( "Tried to start already running sitemap request" );
        } else {
            _stopCount--;
            // Logger.debug( "SitemapRequest.start: new count=" + _stopCount );
        }
        if( _stopCount == 0 ) {
            // Logger.debug( "SitemapRequest.start: making request" );
            makeRequest();
        }
    }

    // Stops the request loop
    // If there is a pending request, onReceive() is instructed to
    // ignore the next response
    public function stop() as Void {
        _stopCount++;
        // When the SitemapRequest is stopped, all ongoing asynchronous
        // processing is also halted. Tasks in the task queue are atomic
        // in the sense that stopping between tasks will not cause any
        // data inconsistencies.
        AsyncTaskQueue.get().removeAll();
        if( _hasPendingRequest ) {
            // Logger.debug( "SitemapRequest.stop: pending request, will ignore the next response" );
            _ignoreNextResponse = true;
        }
    }


    // Used by the SitemapProcessor and TriggerNextRequestTask
    // to trigger the next request after the current response has been
    // successfully processed.
    public function triggerNextRequest() as Void {
        // Logger.debug( "SitemapRequest.triggerNextRequest" );
        triggerNextRequestInternal( _pollingInterval );
    }

    // Internal function for triggering the next request,
    // used both by handleException() and triggerNextRequest()
    private function triggerNextRequestInternal( delay as Number ) as Void {
        // Logger.debug( "SitemapRequest.triggerNextRequestInternal" );
        // Depending on the delay the next request is
        // scheduled via timer or triggered immediately
        if( delay > 0 ) {
            // Logger.debug( "SitemapRequest: starting timer for " + _pollingInterval + "ms" );
            _timer.start( 
                method( :makeRequest ), 
                delay, 
                false 
            );
        } else {
            makeRequest();
        }
    }
}