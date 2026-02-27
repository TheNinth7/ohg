import Toybox.Lang;

/*
 * Represents a command along with its description.
 * Used to handle both widget mappings and item command descriptions.
 */

class CommandDescription extends BaseDescription {
    
    private var _command as String;

    public function initialize( command as String, label as String ) {
        BaseDescription.initialize( command, label );
        _command = command;
    }

    public function getCommand() as String {
        return _command;
    }
}