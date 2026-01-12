import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

/*
    Command request for sending commands to the 
    native REST API of openHAB.
    openHAB 5.0 and newer accept JSON-wrapped command as payload.
    openHAB versions older than 5.0 only support receiving the command as RAW content, 
    which is not suppored by the Garmin SDK.
*/
class NativeCommandRequest extends BaseCommandRequest {

     // Constructor
     // @param item - the menu item to be associated with this command
    public function initialize( item as CommandRequestDelegate ) {
        BaseCommandRequest.initialize( 
            item, 
            AppSettings.getUrl() + "rest/items/" + item.getItemName(),
            // for hard-coding a different test endpoint: 
            // "http://net-nas-1:8080/rest/items/" + item.getItemName(),
            Communications.HTTP_REQUEST_METHOD_POST 
        );
        //setOption( :responseType, Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN );
        setHeader( "Content-Type", Communications.REQUEST_CONTENT_TYPE_JSON );
        setHeader( "X-Openhab-Source", "org.openhab.app.garmin" );
    }

    // Sending a command
    // @param cmd - the command value, e.g. "ON" or "OFF"
    public function sendCommand( cmd as String ) as Void {
        makeWebRequest( { "value" => cmd } );
    }

}
