import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

/*
 * The settings menu currently provides access to the app version and server URL.
 * In the future, additional functionality may be added, such as switching between servers.
 */
class SettingsMenu extends BaseMenu {

    public function initialize() {
        // Initialize the super class
        BaseMenu.initialize( {
            :title => "Settings",
            :itemHeight => Constants.UI_SETTINGS_ITEM_HEIGHT
        } );

        // Add entry for app version
        addItem( new SettingsTextMenuItem(
            "App Version",
            Application.loadResource( Rez.Strings.AppVersion ) as String
        ) );

        // Add entry for server URL
        addItem( new SettingsTextMenuItem(
            "Server",
            AppSettings.getUrl()
        ) );

        // Add entry for connectivity mode
        addItem( new SettingsConnectivityMenuItem() );
        
        // Add entry for sitemap age
        addItem( new SettingsSitemapAgeMenuItem() );
        
        // Add entry for Wi-Fi sitemap refresh
        addItem( new SettingsSitemapRefreshMenuItem() );
    }
}