import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.Application;
import Toybox.Time;
import Toybox.System;

/*
 * `SitemapStore` holds the latest JSON sitemap data and persists it to storage 
 * when the application ends. This applies to both glance and widget modes, 
 * enabling faster startup and immediate display of current data.
 *
 * The JSON data is stored as a tuple with a timestamp indicating its age.
 * Based on this timestamp and a configurable expiry time, a flag indicating
 * whether the state is fresh is passed to the SitemapHomepage and propagated
 * to all sitemap-related classes. Error handling also uses this freshness flag,
 * determined by this class's isSitemapFresh() function.
 *
 * On older devices, the glance view may lack sufficient memory to read the 
 * full JSON from storage or handle web requests. To address this, the sitemap 
 * label is stored separately, allowing at least the label to be shown in the glance view.
 */

(:glance)
class SitemapStore  {
    // Storage field names
    private static const STORAGE_JSON as String = "sitemapJson";
    private static const STORAGE_LABEL as String = "sitemapLabel";

    // Timer after which a state is considered stale
    private static const STATE_EXPIRATION_TIME as Number = 10;

    // Current JSON/label
    // The JSON is stored together with a numeric timestamp
    typedef StoredJson as [JsonObject, Number];
    private static var _json as StoredJson?;
    private static var _title as String?;
    private static var _estimatedSitemapSize as Number = 0;

    // Accessor functions for the label
    public static function getLabel() as String? {
        if( _title == null ) {
            _title = Storage.getValue( STORAGE_LABEL ) as String?;
        }
        return _title;
    }

    // Return the sitemap currently stored in Memory
    (:typecheck(disableGlanceCheck))
    public static function getSitemapFromMemory() as SitemapHomepage? {
        if( _json != null ) {
            return new SitemapHomepage( 
                new JsonAdapter( _json[0] ), 
                isSitemapFresh(), 
                false 
            );
        }
        return null;
    }

    // Return the sitemap currently stored in Storage
    (:typecheck(disableGlanceCheck))
    public static function getSitemapFromStorage() as SitemapHomepage? {
        _json = Storage.getValue( STORAGE_JSON ) as StoredJson?;
        return getSitemapFromMemory();
    }

    // Returns true if the currently held JSON's age is 
    // within the expiry the expiry time, false if it is older. 
    // Returns false if there is no JSON.
    public static function isSitemapFresh() as Boolean {
        if( _json != null ) {
            var dataAge = 
                Time.now().compare( 
                    new Moment( ( _json as StoredJson )[1] ) 
                );
            // Logger.debug( "SitemapStore.isSitemapFresh=" + ( dataAge < STATE_EXPIRATION_TIME ) );
            return dataAge < STATE_EXPIRATION_TIME;
        } else {
            return false;
        }
    }

    // Creates a new sitemap and updates the JSON
    // as well as the label
    (:typecheck(disableGlanceCheck))
    public static function updateSitemapFromJson( 
        incomingJson as SitemapJsonIncoming
    ) as SitemapHomepage {
        _json = incomingJson.getForStorage();
        _estimatedSitemapSize = incomingJson.estimatedSize;
        var homepage = new SitemapHomepage( 
            new JsonAdapter( incomingJson.json ), 
            true, 
            true 
        );
        _title = homepage.title;
        return homepage;
    }


    // Deletes the sitemap from Storage to invalidate it in case of a fatal
    // error during a sitemap request. After such an error, the sitemap should
    // only be shown again once fresh data has been successfully retrieved.
    public static function deleteSitemapFromStorage() as Void {
        Storage.deleteValue( STORAGE_JSON );
        _json = null;
    }

    // Persist the current data to storage
    // This function is called by OHApp wenn the application is stopped
    public static function persist() as Void {
        if( _title != null ) {
            Storage.setValue( STORAGE_LABEL, _title );
            _title = null;
        }
        
        // Logger.debugMemory( _estimatedSitemapSize );

        // Only write to memory if the JSON takes less than 80kB in memory
        // Testing has shown that somewher around 90kB, Storage.setValue
        // will crash, independent of free memory
        if( _json != null && _estimatedSitemapSize <= 81920 ) {
            // Logger.debug( "SitemapStore: persisting JSON" );
            Storage.setValue( STORAGE_JSON, _json as Array<Application.PropertyValueType> );
            _json = null;
        } else if ( _estimatedSitemapSize > 81920 ) {
            // Logger.debug( "SitemapStore: not persisting, JSON too large" );
            deleteSitemapFromStorage();
        }
    }
}
