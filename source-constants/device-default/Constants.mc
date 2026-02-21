import Toybox.Lang;

/*
 * The default `Constants` implementation inherits all base values 
 * without overriding any defaults.
 */
class Constants extends DefaultConstants {
    protected function initialize() { DefaultConstants.initialize(); }
}