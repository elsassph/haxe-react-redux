package redux;

import js.Promise;
import redux.Redux;

/**
	Reduced Store API when provided in the React context
	http://redux.js.org/docs/api/Store.html
**/
typedef StoreMethods<TState> = {
	function getState():TState;
	function dispatch(action:Action):Promise<Dynamic>;
}
