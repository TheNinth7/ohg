import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This file contains the asynchronous tasks used to initialize the menu.
 * 
 * The HomepageMenu can be instantiated in two ways:
 * 
 * - With the first level created synchronously and all subsequent levels asynchronously.
 *   This is used when loading the sitemap from storage during startup, allowing the
 *   HomepageMenu to appear immediately while deeper levels are loaded in the background.
 * 
 * - With all levels created asynchronously. This mode is used during updates.
 *
 * For each asynchronous level, CreateMenuItemTasks is responsible for creating the menu items.
 * 
 * In the mixed sync/async mode, the first asynchronous level additionally executes the
 * SwitchIfVisibleTask, which applies a workaround for a Garmin bug that affects 
 * visible menus when the number of items changes.
 *
 * NOTE: When Garmin fixes the related bug, SwitchIfVisibleTask can be removed. 
 * However, it would still be necessary to refresh the UI if the user is currently 
 * viewing one of the updated menu items. The currently commented-out 
 * RequestWatchUiUpdateIfVisibleTask could be used for this purpose.
 */

// This task creates a menu item based on the provided sitemap widget
// and adds it to the given menu.
class CreateMenuItemTask extends BaseSitemapProcessorTask {
    private var _widget as SitemapWidget;
    private var _menu as BasePageMenu;

    // Constructor
    public function initialize( 
        widget as SitemapWidget,
        menu as BasePageMenu
    ) {
        BaseSitemapProcessorTask.initialize();
        _widget = widget;
        _menu = menu;
    }

    public function invoke() as Void {
        _menu.addItem( MenuItemFactory.createMenuItem( _widget, _menu, BasePageMenu.PROCESSING_ASYNC ) );
    }
}

/*
 * A bug in Garmin's native device implementation of CustomMenu/Menu2
 * affects updates to the currently displayed menu:
 * - Newly added menu items are not displayed.
 * - Even worse, deleting menu items can cause the app to crash.
 *
 * This issue can be avoided by replacing the current view with itself
 * using switchToView(). This appears to trigger the necessary refresh
 * inside CustomMenu to properly handle the updated number of items.
 *
 * A derivative of this class (SwitchViewIfVisibleAndItemCountChanged) is
 * also used during the update procedure.
 *
 * NOTE: When Garmin fixes the related bug, SwitchIfVisibleTask can be removed. 
 * However, it would still be necessary to refresh the UI during initialization 
 * if the user is currently viewing one of the updated menu items. The currently 
 * commented-out RequestWatchUiUpdateIfVisibleTask could be used for this purpose.
 */
class SwitchViewIfVisibleTask extends BaseSitemapProcessorTask {
    private var _pageMenu as BasePageMenu;

    // Constructor
    // The task needs to be created before any modification
    // of the BasePageMenu. It will record the current number
    // of items, and compare that with the number of items on
    // invokation.
    public function initialize( 
        pageMenu as BasePageMenu 
    ) {
        BaseSitemapProcessorTask.initialize();
        _pageMenu = pageMenu;
    }

    // Accessor for the page menu, to be used by sub classes
    protected function getPageMenu() as BasePageMenu {
        return _pageMenu;
    }
    
    // Perform the switch if the menu is visible
    public function invoke() as Void {
        // ... If this menu is the current view ...
        if( _pageMenu.equals( WatchUi.getCurrentView()[0] ) ) {
            // Logger.debug( "SwitchViewIfVisibleTask.invoke: switching the view!" );
            
            // ... we do the switch to itself
            WatchUi.switchToView(
                WatchUi.getCurrentView()[0] as View,
                WatchUi.getCurrentView()[1] as InputDelegate,
                WatchUi.SLIDE_IMMEDIATE
            );
        }            
    }
}

/*
// See the documentation of SwitchViewIfVisibleTask
class RequestWatchUiUpdateIfVisibleTask extends BaseSitemapProcessorTask {
    private var _pageMenu as BasePageMenu;

    // Constructor
    public function initialize( 
        pageMenu as BasePageMenu 
    ) {
        BaseSitemapProcessorTask.initialize();
        _pageMenu = pageMenu;
    }

    public function invoke() as Void {
        if( _pageMenu.equals( WatchUi.getCurrentView()[0] ) ) {
            // Logger.debug( "RequestWatchUiUpdateIfVisibleTask.invoke: requesting an update!" );
            WatchUi.requestUpdate();
        }            
    }
}
*/