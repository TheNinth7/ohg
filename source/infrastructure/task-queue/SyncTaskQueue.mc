import Toybox.Lang;
import Toybox.Timer;

/*
 * CIQ apps have a relatively small stack size, and recursive processing can easily
 * cause a stack overflow. For example, building sitemap classes for a sitemap with
 * just three levels of hierarchy can already trigger an overflow.
 *
 * To avoid this, recursive processing is replaced by iterative task-based processing.
 * This task queue facilitates that approach. For each level in a hierarchical structure,
 * new tasks are created for its sub-levels, resulting in a flat, one-dimensional list of
 * tasks that can be safely executed without risking stack overflow.
 */
class SyncTaskQueue {

    // Interface that has to be fullfiled by tasks
    typedef Task as interface {
        function invoke() as Void;
    };

    // Array for storing tasks. In this class, index 0 represents the back of the queue,
    // and the last index represents the front, which is executed first.
    // Since tasks are always added to the front, this layout improves performance and efficiency.
    private var _tasks as Array<Task> = [];
    
    // Adds a task to the front of the queue. Each new task will be executed
    // before any tasks already in the queue. This preserves the execution
    // order that would naturally occur with recursive processing.
    //
    // In recursive processing, each hierarchy level generates tasks,
    // and as each task executes, it creates new tasks for its sub-levels.
    // By inserting tasks at the front, this behavior is replicated:
    // child-level tasks are processed before the remaining sibling-level tasks
    // of their parent.
    public function addToFront( task as Task ) as Void {
        _tasks.add( task );
    }

    // Execute the tasks
    public function executeTasks() as Void {
        // The last index is considered the front of the queue,
        // from where we'll execute till we reach index 0.
        // See the _tasks definition
        for( var i = _tasks.size() - 1; i >= 0; i = _tasks.size() - 1 ) {
            var task = _tasks[i];
            task.invoke();
            _tasks.remove( task );
        }
        _tasks = new Array<Task>[0];
    }
}