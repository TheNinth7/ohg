import Toybox.Lang;
import Toybox.Graphics;

/*
* `GlanceConfig` uses a single implementation for all Venu devices with rectangular screen.
*/
(:glance)
class GlanceConfig extends BaseGlanceConfig {
    protected function initialize() { BaseGlanceConfig.initialize(); }
}