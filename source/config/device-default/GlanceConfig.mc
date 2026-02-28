import Toybox.Lang;

/*
* The default `Config` implementation inherits all default values and overrides none.
*/
(:glance)
class GlanceConfig extends GlanceBaseConfig {
    protected function initialize() { GlanceBaseConfig.initialize(); }
}