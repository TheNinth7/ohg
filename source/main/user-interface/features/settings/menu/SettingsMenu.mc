import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

/*
 * The settings menu currently provides access to the app version and server URL.
 * In the future, additional functionality may be added, such as switching between servers.
 */
class SettingsMenu extends BaseMenu {

    public function initialize() {
        // Initialize the base class
        BaseMenu.initialize( {
            :title => "Settings",
            :itemHeight => Config.UI_SETTINGS_ITEM_HEIGHT
        } );

        // Add entry for app version
        addItem( new LabelMenuItem(
            "App Version",
            Application.loadResource( Rez.Strings.AppVersion ) as String
        ) );

        // Add entry for server URL
        addItem( new LabelMenuItem(
            "Server",
            AppSettings.getUrl()
        ) );

        // Add entry for server URL
        addItem( new LabelMenuItem(
            "Sitemap",
            AppSettings.getSitemap()
        ) );

        // Add entry for server URL
        addItem( new LabelMenuItem(
            "Connect IQ Version",
            Lang.format( "$1$.$2$.$3$", System.getDeviceSettings().monkeyVersion )
        ) );

        // Add entry for connectivity mode
        addItem( new ConnectionModeMenuItem() );
        
        // Add entry for sitemap age
        addItem( new SitemapLastUpdatedMenuItem() );
        
        // Add entry for Wi-Fi sitemap refresh
        addItem( new SitemapRefreshMenuItem() );
    }
}