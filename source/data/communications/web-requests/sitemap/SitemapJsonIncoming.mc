import Toybox.Lang;

/*
 * This class represents the sitemap JSON received from a web request.
 * It stores the following:
 * - The original JSON dictionary
 * - The estimated size, as calculated by SitemapRequest
 * - The timestamp when the instance was created
 */
class SitemapJsonIncoming {
    public var json as JsonObject;
    public var estimatedSize as Number;
    public var timestamp as Number;

    // Constructor
    public function initialize( l_json as JsonObject, l_estimatedSize as Number ) {
        json = l_json;
        estimatedSize = l_estimatedSize;
        timestamp = Time.now().value();
    }

    // Provides the JSON in the tuple needed for putting it in Storage
    public function getForStorage() as SitemapStore.StoredJson {
        return [json, timestamp];
    }
}