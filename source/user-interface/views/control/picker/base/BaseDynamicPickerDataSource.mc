import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Abstract class for supplying options to a DynamicPicker.
 *
 * This class must be implemented when using a DynamicPicker. It defines
 * the methods used by the BaseDynamicPickerDelegate to navigate through
 * the available picker options.
 *
 * Implementations must provide:
 * - up(): Move to the previous option.
 * - down(): Move to the next option.
 * - getCurrent(): Return the currently selected DynamicPickOption.
 */
class BaseDynamicPickerDataSource {
    // Move up to the (higher) value
    function up() as Void {
        throw new AbstractMethodException( "BaseDynamicPickerDataSource.up" );
    }
    // Move down to the (lower) value
    function down() as Void {
        throw new AbstractMethodException( "BaseDynamicPickerDataSource.down" );
    }
    // Get the current value
    function getCurrent() as DynamicPickOption {
        throw new AbstractMethodException( "BaseDynamicPickerDataSource.getCurrent" );
    }
}
