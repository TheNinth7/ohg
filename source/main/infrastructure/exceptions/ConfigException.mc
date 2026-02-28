import Toybox.Lang;

/*
 * Exception thrown for any errors encountered while reading the application settings.
 */
(:glance)
class ConfigException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
