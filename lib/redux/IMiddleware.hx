package redux;

import redux.StoreMethods;

interface IMiddleware<TAction, TAppState>
{
	function middleware(store:StoreMethods<TAppState>, action:TAction, skip:Void -> Dynamic):Dynamic;
}
