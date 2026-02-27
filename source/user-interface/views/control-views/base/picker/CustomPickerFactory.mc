import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Abstract factory class for supplying options to a CustomPicker.
 *
 * This class must be implemented when using a CustomPicker. It defines
 * the methods used by the CustomPickerDelegate to navigate through
 * the available picker options.
 *
 * Implementations must provide:
 * - up(): Move to the previous option.
 * - down(): Move to the next option.
 * - getCurrent(): Return the currently selected CustomPickable.
 */
class CustomPickerFactory {
    // Move up to the (higher) value
    function up() as Void {
        throw new AbstractMethodException( "CustomPickerFactory.up" );
    }
    // Move down to the (lower) value
    function down() as Void {
        throw new AbstractMethodException( "CustomPickerFactory.down" );
    }
    // Get the current value
    function getCurrent() as CustomPickable {
        throw new AbstractMethodException( "CustomPickerFactory.getCurrent" );
    }
}
