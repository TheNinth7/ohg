import Toybox.Lang;

/*
* The default `Config` implementation inherits all default values and overrides none.
*/
(:glance)
class GlanceConfig extends BaseGlanceConfig {
    protected function initialize() { BaseGlanceConfig.initialize(); }
}