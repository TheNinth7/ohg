import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

/*
    Command request for sending commands to the custom Webhook.
    The custom Webhook needs the Webhook HTTP binding and a custom
    thing configuration and scripted rule. See the app documentation for details.
*/
class WebhookCommandRequest extends BaseCommandRequest {

    // The parameters for the web request
    private var _parameters as Dictionary<String, Object> = {} as Dictionary<String, Object>;

    public function initialize( item as CommandRequestDelegate ) {
        // The custom Webhook uses GET as HTTP method,
        // and needs an ID provided in the configuration (refering to the Thing),
        // which is part of the URL
        BaseCommandRequest.initialize( 
            item, 
            AppSettings.getUrl() + "webhook/" + AppSettings.getWebhook(),
            // for hard-coding a different test endpoint: 
            // "http://net-nas-1:8080/webhook/" + AppSettings.getWebhook(),
            Communications.HTTP_REQUEST_METHOD_GET 
        );
        // action and itemName parameters are fixed
        _parameters["action"] = "sendCommand";
        _parameters["itemName"] = item.getItemName();
    }

    // Assemble the parameters for a given command
    // @param cmd - the command value, e.g. "ON" or "OFF"
    public function assembleParameters( cmd as String ) as Dictionary<String, Object> {
        _parameters["command"] = cmd;
        return _parameters;
    }
}