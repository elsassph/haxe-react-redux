package redux;

import js.Promise;
import redux.Redux;

typedef StoreMethods<TState> = {
	function getState():TState;
	function dispatch(action:Action):Promise<Dynamic>;
}
