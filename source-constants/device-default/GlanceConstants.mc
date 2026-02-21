import Toybox.Lang;

/*
* The default `Constants` implementation inherits all default values and overrides none.
*/
(:glance)
class GlanceConstants extends GlanceDefaultConstants {
    protected function initialize() { GlanceDefaultConstants.initialize(); }
}