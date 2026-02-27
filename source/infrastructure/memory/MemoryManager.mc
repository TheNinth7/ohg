import Toybox.Lang;
import Toybox.System;

/*
 * Helper functions for managing app memory limits.
 */
class MemoryManager {

    // Ensure at least 10 kB of free memory is available.
    // If not, throw a catchable exception.
    // This threshold is intentionally generous but reasonable,
    // considering we only support devices with 500 kB or more of app memory.
    public static function ensureMemory() as Void {
        if( System.getSystemStats().freeMemory < 10240 ) {
            throw new OutOfMemoryException();
        }
    }
}