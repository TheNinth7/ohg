import Toybox.Lang;

/*
 * Task queues serve two main purposes: 
 * 1. Breaking down processing into small tasks to allow user input to be handled in between.
 * 2. Iteratively processing recursive data structures to avoid stack overflow issues.
 * 
 * The AsyncTaskQueue addresses both purposes by implementing a global task queue and 
 * executing tasks asynchronously at timer-based intervals.
 *
 * The SyncTaskQueue is used when only the second purpose is needed. It is instantiated 
 * locally, collects tasks, and provides a method for executing them synchronously. 
 * Without the delay from timer-based intervals, tasks are executed more quickly.
 *
 * The sitemap classes support both asynchronous processing (for UI updates) and 
 * synchronous processing (when data is initially loaded). Therefore, an interface 
 * is defined below to allow passing either AsyncTaskQueue or SyncTaskQueue through 
 * the sitemap structure.
 */

typedef TaskQueue as AsyncTaskQueue or SyncTaskQueue;