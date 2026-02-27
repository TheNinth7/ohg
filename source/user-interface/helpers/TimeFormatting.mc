import Toybox.Lang;
import Toybox.Time;

/*
 * Helper functions for formatting date and time values.
 */
class TimeFormatting {

    public static function twoDigits( value as Number ) as String {
        return value < 10 ? "0" + value : value.toString();
    }    

    /* Formats a Duration as Xd Xh Xm.
    *
    * @param d        The duration to format.
    * @param maxParts The maximum number of time units to include.
    *                 For example, if maxParts is 3, seconds are omitted.
    *
    public static function formatDuration( d as Duration, maxParts as Number ) as String {
        var s = d.value();

        var days = s / 86400;
        s = s % 86400;

        var hours = s / 3600;
        s = s % 3600;

        var mins = s / 60;
        s = s % 60;

        // Collect only the parts we want to show
        var parts = [] as Array<String>;

        if (days > 0) { parts.add(days + "d"); }
        if (hours > 0 || days > 0) { parts.add(hours + "h"); }
        if (mins > 0 || hours > 0 || days > 0) { parts.add(mins + "m"); }
        parts.add(s + "s");

        // Join with spaces
        var out = "";
        for (var i = 0; i < CustomMath.min( maxParts, parts.size() ); i++) {
            if (i > 0) { out += " "; }
            out += parts[i];
        }
        return out;
    }
    */
}
