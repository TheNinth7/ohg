import Toybox.Lang;

public class StateDescriptions extends BaseDescriptions {

    public function initialize( jsonStateDescriptions as JsonAdapterArray? ) {
        var stateDescriptions = new Array<StateDescription>[0];
        if( jsonStateDescriptions != null ) {
            for( var i = 0; i < jsonStateDescriptions.size(); i++ ) {
                var jsonStateDescription = jsonStateDescriptions[i];
                stateDescriptions.add( 
                    new StateDescription( 
                        jsonStateDescription.getString( "value", "Switch: value is missing from state description" ),
                        jsonStateDescription.getString( "label", "Switch: label is missing from state description" )
                ) );
            }
        }
        BaseDescriptions.initialize( stateDescriptions as Array<BaseDescription> );
    }
}