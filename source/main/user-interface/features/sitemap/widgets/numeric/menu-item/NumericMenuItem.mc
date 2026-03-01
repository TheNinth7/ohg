import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This menu item represents the Setpoint and Slider widget in the app.
 * It displays the current item value and, when selected,
 * opens a separate view (a DynamicPicker implementation) that allows
 * the user to adjust the value.
 *
 * The widgets respects sitemap settings for minValue, maxValue, and step.
 * It also supports 'releaseOnly' mode: if enabled, the item state is updated
 * only after the user confirms their selection. If disabled, the state updates
 * continuously as the user scrolls through values.
 */
class NumericMenuItem extends CommandMenuItem {

    // Returns true if the given widget matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return sitemapWidget instanceof SitemapNumeric;
    }

    // Constructor
    // Initializes the BaseCommandRequest used for changing the state,
    // the Drawable for the displayed state and the base class
    public function initialize( 
        sitemapNumeric as SitemapNumeric,
        parent as BasePageMenu,
        processingMode as BasePageMenu.ProcessingMode
    ) {
        CommandMenuItem.initialize( {
                :sitemapWidget => sitemapNumeric,
                :stateTextResponsive => sitemapNumeric.getDisplayState(),
                :isActionable => true,
                :parent => parent,
                :processingMode => processingMode
            }
        );
    }

    // This function is called during a command request to identify
    // the target item that the command should be sent to.
    public function getItemName() as String {
        return getSitemapNumeric().getNumericItem().getName();
    }

    // Returns the underlying `SitemapWidget`, ensuring it is a
    // `SitemapNumeric`. Throws an exception if the type does not match.
    public function getSitemapNumeric() as SitemapNumeric {
        var sitemapWidget = getSitemapWidget();
        if( ! ( sitemapWidget instanceof SitemapNumeric ) ) {
            throw new GeneralException( "NumericMenuItem supports only SitemapNumeric." );
        }
        return sitemapWidget;
    }

    // When the menu item is selected, the DynamicPicker is initialized
    // and pushed to the view stack
    public function onSelect() as Boolean {
        if( ! CommandMenuItem.onSelect() ) {
            if( hasCommandsEnabled() ) {
                ViewStack.pushView(
                    new DynamicPicker( 
                        getLabel(),
                        new NumericPickerDataSource( self )
                    ),
                    new NumericPickerDelegate( self ),
                    WatchUi.SLIDE_LEFT
                );
            }
        }
        return true;
    }

    // Called by the base class when the state changes, either due to
    // a sitemap update from the server or a local change after a
    // command was sent.
    // Updates the state text.
    // Calling WatchUi.requestUpdate() is handled by the base class.
    public function onStateChanged() as Void {
        setStateTextResponsive( getSitemapNumeric().getDisplayState() );
    }

}