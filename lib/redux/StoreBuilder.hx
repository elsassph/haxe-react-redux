package redux;

import redux.Redux;

class StoreBuilder
{
	/**
		Enum-based reducer: 
		- action type is matched to the enum name, 
		- reducer function receives the enum value instead of the whole action
	**/
	static public function mapReducer<TAction, TState>(of:Enum<Dynamic>, service:IReducer<TAction, TState>):Reducer<TState>
	{
		var type = of.getName();
		return function(state:Dynamic, action:ActionPayload) {
			if (state == null) state = service.initState;
			if (action.type == type) return service.reduce(state, action.value);
			else return state;
		}
	}
	
	/**
		Enum-based middleware: 
		- action type is matched to the enum name, 
		- action is always dispatched next
		- middleware function receives the enum value instead of the whole action
		- middleware function can return a Promise for async operations
	**/
	static public function mapMiddleware<TAction, TAppState>(of:Enum<Dynamic>, service:IMiddleware<TAction, TAppState>)
	{
		var type = of.getName();
		return function (store:StoreMethods<TAppState>) {
			return function (next:Dispatch):Dynamic {
				return function (action:Action):Dynamic {
					if (action.type == type)
					{
						var skip = function() return next(action);
						return service.middleware(store, action.value, skip);
					}
					return next(action);
				}
			}
		}
	}
	
	/**
		Assemble store with a (safe) initial state 
		and wires Redux devtools in debug mode
	**/
	static public function createStore<TState>(rootReducer:Reducer<TState>, initState:TState = null, enhancer:Enhancer = null)
	{
		if (initState == null) initState = cast {};
		
		#if debug
		if (untyped window.__REDUX_DEVTOOLS_EXTENSION__)
		{
			if (enhancer == null) enhancer = untyped window.__REDUX_DEVTOOLS_EXTENSION__();
			else enhancer = untyped window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__(enhancer);
		}
		#end
		
		return Redux.createStore(rootReducer, initState, enhancer);
	}
}
