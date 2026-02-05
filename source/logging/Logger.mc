import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.System;

/*
 * This class provides functions for printing debug output 
 * to the debug console or log file.
 */
(:glance)
public class Logger {

    // `Info` should be used where the output is a permanent part of the code,
    // in contrast to temporary debug statements which are typically commented 
    // in and out as needed for debugging purposes.
    public static function info( text as String ) as Void {
        debug( text );
    }

    // Output a debug statement
    (:debug)
    public static function debug( text as String ) as Void {
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateString = Lang.format(
            "$4$.$5$.$6$ $1$:$2$:$3$",
            [
                now.hour,
                now.min,
                now.sec,
                now.day,
                now.month,
                now.year
            ] );
        System.println( dateString + ": " + text );
    }

    // Output the content of an exception
    (:debug)
    public static function debugException( ex as Exception ) as Void {
        var errorMsg = ex.getErrorMessage();
        if( errorMsg != null ) {
            debug( errorMsg );
        }
        // For communication exceptions, the source is known. Additionally,
        // there is a bug in the SDK that causes an exception in `printStackTrace`, 
        // particularly when the exception is thrown during a synchronous call 
        // to `SitemapRequest.onReceive()` during startup.
        if( ! ( 
                ex instanceof CommunicationBaseException 
                || ex instanceof UnexpectedResponseException
                || ex instanceof ConfigException
                || ex instanceof JsonParsingException
                || ex instanceof OutOfMemoryException
                || ex instanceof NonFatalUserInterfaceException
                || ex instanceof OfflineException
            ) )
            {
            ex.printStackTrace();
            System.println(" ");
        }
    }
  
    (:debug)
    public static function debugMemory( estimatedSitemapSize as Number? ) as Void {
        debug( "      Used memory = " + System.getSystemStats().usedMemory + " B" );
        debug( "     Total memory = " + System.getSystemStats().totalMemory + " B" );
        debug( "      Free memory = " + System.getSystemStats().freeMemory + " B" );
        if( estimatedSitemapSize != null ) {
            debug( "Est. sitemap size = " + estimatedSitemapSize + " B" );
        }
    }

    (:debug)
    public static function debugConnectionInfo() as Boolean {
        Logger.debug( "ConnectivityHandler.debugConnectionInfo" );
        var bluetooth = System.getDeviceSettings().connectionInfo[:bluetooth];
        Logger.debug( "Bluetooth: " + ( bluetooth == null ? "nostate" : bluetooth.state ) );
        var wifi = System.getDeviceSettings().connectionInfo[:wifi];
        Logger.debug( "Wi-Fi: " + ( wifi == null ? "nostate" : wifi.state ) );
        var lte = System.getDeviceSettings().connectionInfo[:lte];
        Logger.debug( "LTE: " + ( lte == null ? "nostate" : lte.state ) );
        return wifi != null && wifi.state == System.CONNECTION_STATE_CONNECTED;
    }

    // For release builds, there shall be no debug output
    (:release) public static function debug( text as String ) as Void {}
    (:release) public static function debugException( ex as Exception ) as Void {}
    (:release) public static function debugMemory( estimatedSitemapSize as Number? ) as Void {}
}