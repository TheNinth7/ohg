import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

/*
 * The `CommandMenu` presents the user with a list of commands that can be sent
 * to an item. It used only on Edge devices, where the `ActionMenu` is not available.
 *
 * Currently, it inherits all required functionality from `BasePageMenu` and
 * does not require any additional behavior.
 */
(:exclForActionMenu)
class CommandMenu extends BaseMenu {
    public function initialize( title as String ) {
        BaseMenu.initialize( {
                :title => title,
                :itemHeight => Config.UI_MENU_ITEM_HEIGHT
            } );
    }
}