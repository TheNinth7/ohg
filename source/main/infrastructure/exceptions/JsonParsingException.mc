import Toybox.Lang;

/*
 * Exception thrown for errors encountered when parsing the JSON dictionary
 * from a web response or from storage into the data structures defined in `source/sitemap`.
 */
 (:glance)
class JsonParsingException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
