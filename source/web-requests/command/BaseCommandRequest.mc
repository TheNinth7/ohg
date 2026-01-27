import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

/*
    Base class for command requests
    Command requests are used to issue commands to openHAB items
    There are two derivates of this class, one for the custom Webhook,
    and one for the native REST APIs
    This class 
    - holds the menu item that this request is associated with
      - the menu item has to implement the CommandRequestDelegate,
        which prescribes event handlers for processing the result of the command
    - holds the URL for the request
    - provides a function for making the request, to be used by derivates
    - processes the response and calls the event handler of the item
*/

// Interface to be implemented by menu items that issue commands.
// Defines the functions and callbacks required for interaction 
// of the command request with the menu item.
typedef CommandRequestDelegate as interface {
    function getItemName() as String;
    function onCommandComplete() as Void;
    function onException( ex as Exception ) as Void;
};

class BaseCommandRequest extends BaseRequest {
    
    // Depending on the settings, either a native REST API command request 
    // or a custom Webhook command request is instantiated.
    // If neither is configured, no command request is created, and items 
    // will only display their current state.
    public static function get( delegate as CommandRequestDelegate ) as BaseCommandRequest? {
        if( AppSettings.supportsRestApi() ) {
            return new NativeCommandRequest( delegate );
        } else if( AppSettings.supportsWebhook() ) {
            return new WebhookCommandRequest( delegate );
        }
        return null;
    }

    // The URL for the command request
    private var _url as String;
    
    // The item is kept as weak reference, to avoid
    // memory leaks due to circular references
    private var _weakItem as WeakReference;

    // We count the currently open requests for this item
    // If there is more than one, we cancel all requests in the
    // queue, to avoid BLE_QUEUE_FULL errors.
    // See makeWebRequest() for details.    
    private var _requestCounter as Number = 0;

    // Constructor
    protected function initialize( 
        item as CommandRequestDelegate, 
        url as String, 
        method as Communications.HttpRequestMethod 
    ) {
        BaseRequest.initialize( method );
        _weakItem = item.weak();
        _url = url;
    }

    // Implemented by subclasses to provide the parameters for the web request.
    public function assembleParameters( cmd as String ) as Dictionary<String, Object> {
        throw new AbstractMethodException( "BaseCommandRequest.assembleParameters" );
    }

    // Implemented by subclasses to provide the parameters for the web request.
    public function sendCommand( cmd as String ) as Void {
        if( ! ConnectivityHandler.get().isOnWiFiConnection() ) {
            makeWebRequest( assembleParameters( cmd ) as Dictionary<Object, Object> );
        } else {
            var item = _weakItem.get() as CommandRequestDelegate?;

            if( item != null ) {
                
                WifiSyncDelegate.get().setCommand( [ item.getItemName(), cmd ] );

                if( Communications has :startSync2 ) {
                    Communications.startSync2( { :message => "Sending command via WiFi ..." } );
                } else {
                    Communications.startSync();
                }
            } else {
                ExceptionHandler.handleException(
                    new GeneralException( "sendCommand: item reference is no longer valid" )
                );
            }

            
        }
    }

    // Triggers the web request
    // @param parameters - options for the web request, as per Communication.makeWebRequest
    protected function makeWebRequest( parameters as Dictionary<Object, Object>? ) as Void {
        // Logger.debug "BaseCommandRequest: makeWebRequest to " + _url );
        try {
            // Logger.debug( "BaseCommandRequest.makeWebRequest: stopping sitemap request" );
            SitemapRequest.get().stop();
            // If there is more than one open request for this item,
            // we cancel all requests to avoid -101/BLE_QUEUE_FULL errors.
            // This will also cancel any ongoing sitemap requests, which is acceptable.
            //
            // It may cancel commands for other items as well, but this is
            // highly unlikely—users typically can’t move between items
            // and trigger multiple commands quickly enough for this to be an issue.
            //
            // This situation mainly affects custom views. When commands are sent
            // from a menu item, the menu system blocks new commands until the
            // previous one has completed.
            if( _requestCounter > 0 ) {
                // Logger.debug( "BaseCommandRequest: cancelling previous requests!" );
                cancelAllRequests();
                _requestCounter = 0;
            }

            _requestCounter++;
            Communications.makeWebRequest( _url, parameters, getBaseOptions(), method( :onReceive ) );
        } catch( ex ) {
            // Logger.debug( "BaseCommandRequest.makeWebRequest: restarting sitemap request after error" );
            SitemapRequest.get().start();
            throw ex;
        }
    }

    // Processes the response to the web request
    // If the request was successful, onCommandComplete() is called
    // If there was an error, onException() is being called
    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        var item = _weakItem.get() as CommandRequestDelegate?;
        
        if( item == null ) {
            ExceptionHandler.handleException(
                new GeneralException( "onReceive: item reference is no longer valid" )
            );
        } else {
            try {
                _requestCounter--;
                // Logger.debug( "BaseCommandRequest.onReceive: restarting sitemap request" );
                SitemapRequest.get().start();
                if( checkResponseCode( responseCode, CommunicationException.EX_SOURCE_COMMAND ) ) {
                    item.onCommandComplete();
                }
            } catch( ex ) {
                item.onException( ex );
                ExceptionHandler.handleException( ex );
            }
        }
    }
}   