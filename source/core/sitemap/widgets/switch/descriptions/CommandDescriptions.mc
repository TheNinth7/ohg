import Toybox.Lang;

public class CommandDescriptions extends BaseDescriptions {

    public function initialize( jsonCommandDescriptions as JsonAdapterArray? ) {
        var commandDescriptions = new Array<CommandDescription>[0];
        if( jsonCommandDescriptions != null ) {
            for( var i = 0; i < jsonCommandDescriptions.size(); i++ ) {
                var jsonCommandDescription = jsonCommandDescriptions[i];
                commandDescriptions.add( 
                    new CommandDescription( 
                        jsonCommandDescription.getString( "command", "Switch: command is missing from mapping/command description" ),
                        jsonCommandDescription.getOptionalString( "label" )
                    )
                );
            }
        }
        BaseDescriptions.initialize( commandDescriptions as Array<BaseDescription> );
    }

    public function getCommandDescription( i as Number ) as CommandDescription {
        return get( i ) as CommandDescription;
    }

}