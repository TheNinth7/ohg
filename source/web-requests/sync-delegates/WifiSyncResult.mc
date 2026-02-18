import Toybox.Lang;

// The sync result tuple indicates in its first field whether a sync was performed
// (true) or not (false), regardless of success. The second field is null if the
// request was successful; otherwise, it contains the exception describing the error.
// Defined outside of the SyncDelegate implementations to make it accessible to 
// SafeSitemapSyncDelegate on devices without SyncDelegate support.
// See SafeSitemapSyncDelegate for details.
typedef WifiSyncResult as [Boolean,Exception?];
const RESET_SYNC_STATE = [false, null];