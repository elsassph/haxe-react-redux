package redux.react;

/**
	Add this interface to ReactComponents which should be connected 
	to the Redux store.
	
	Default addition is to provide 'context.store', and 'this.dispatch'.
	
	And if the class has a 'mapState(state:AppState):LocalState' method (static or not):
	- in the constructor, 'mapState' is called to set the initial state,
	- the store is subscribed in order to call 'mapState' when the state
	  changes and if the new state is different (shallow comparison).
**/
@:autoBuild(redux.react.ConnectMacro.build())
interface IConnectedComponent 
{
}
