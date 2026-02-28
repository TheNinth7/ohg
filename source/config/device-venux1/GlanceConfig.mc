import Toybox.Lang;
import Toybox.Graphics;

/*
* `GlanceConfig` uses a single implementation for all Edge devices.
*/
(:glance)
class GlanceConfig extends GlanceBaseConfig {
    protected function initialize() { GlanceBaseConfig.initialize(); }
}