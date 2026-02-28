import Toybox.Lang;

/*
 * The default `Config` implementation inherits all base values 
 * without overriding any defaults.
 */
class Config extends BaseConfig {
    protected function initialize() { BaseConfig.initialize(); }
}