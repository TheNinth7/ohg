import Toybox.Lang;
import Toybox.Communications;

class WifiSyncDelegate extends SyncDelegate {

    /******* STATIC *******/ 

    // Singleton instance and accessor
    private static var _instance as WifiSyncDelegate?;

    public static function get() as WifiSyncDelegate {
        if( _instance == null ) {
            _instance = new WifiSyncDelegate();
        }
        return _instance as WifiSyncDelegate;
    }

    /******* INSTANCE *******/ 

    typedef WifiSyncCommand as [String,String];

    private var _cmd as WifiSyncCommand?;

    private function initialize() {
        SyncDelegate.initialize();
    }

    public function setCommand( cmd as WifiSyncCommand ) as Void {
        _cmd = cmd;
    }

    private function ensureCommand() as WifiSyncCommand {
        if( _cmd != null ) {
            return _cmd;
        } else {
            throw new GeneralException( "WifiSyncDelegate: command is missing" );
        }
    }

    public function getItemName() as String {
        return ensureCommand()[0];
    }

    public function onCommandComplete() as Void {
        Communications.notifySyncProgress( 100 );
    }

    function onException( ex as Exception ) as Void {
    }

    public function isSyncNeeded() as Boolean {
        return true;
    }

    public function onStartSync() as Void {
        try {
            Communications.notifySyncProgress( 10 );
            var commandRequest = BaseCommandRequest.get( self );
            if( commandRequest == null ) {
                throw new GeneralException( "Neither REST API nor Webhook are supported!" );
            }
            commandRequest.sendCommand( ensureCommand()[1] );
        } catch( ex ) {
            onException( ex );
        }
    }

    public function onStopSync() as Void {
    }
}