import Toybox.Lang;

/*
 * Many classes use SitemapSyncDelegate functions to determine whether a sync
 * is currently in progress or has previously been executed. Since this logic
 * is shared across all devices, it is also executed on devices that do not
 * support Wi-Fi.
 *
 * On some of those devices, SyncDelegate is available despite the lack of
 * Wi-Fi support (for example Forerunner 165 or fēnix 7X Pro Solar Edition),
 * so this was not an issue. However, on others (such as Forerunner 255 or
 * Edge MTB), SyncDelegate is not available. Accessing SitemapSyncDelegate
 * there caused a crash.
 *
 * To prevent this, all classes should use SafeSitemapSyncDelegate when
 * accessing sync-related functionality in code paths that may run on
 * non-Wi-Fi devices.
 *
 * Currently this wrapper provides access to:
 *   - SitemapSyncDelegate.isSyncInProgress()
 *   - SitemapSyncDelegate.consumeLastSyncResult()
 */
class SafeSitemapSyncDelegate {

    // The availability of SyncDelegate is determined once and cached for later use.
    private static var _hasSyncDelegate as Boolean = Toybox.Communications has :SyncDelegate;

    // Defaults to false if SyncDelegate is not available.
    public static function isSyncInProgress() as Boolean {
        return _hasSyncDelegate
               ? SitemapSyncDelegate.get().isSyncInProgress()
               : false;
    }

    // Defaults to [false, null] if SyncDelegate is not available,
    // meaning no sync is currently in progress and no previous result exists.
    public static function consumeLastSyncResult() as WifiSyncResult {
        return _hasSyncDelegate
               ? SitemapSyncDelegate.get().consumeLastSyncResult()
               : RESET_SYNC_STATE;
    }
}