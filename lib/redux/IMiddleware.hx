package redux;

import redux.StoreMethods;

/**
	Implement this interface to create a model providing a Redux middleware
	and its initial state.
**/
interface IMiddleware<TAction, TAppState>
{
	function middleware(store:StoreMethods<TAppState>, action:TAction, next:Void -> Dynamic):Dynamic;
}
