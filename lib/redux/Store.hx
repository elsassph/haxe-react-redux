package redux;

import js.Promise;
import redux.Redux;

interface Store<TState> 
{
	function getState():TState;
	function dispatch(action:Action):Promise<Dynamic>;
	function subscribe(listener:StoreListener):Unsubscribe;
	function replaceReducer<TState>(rootReducer:Reducer<TState>):Void;
}
