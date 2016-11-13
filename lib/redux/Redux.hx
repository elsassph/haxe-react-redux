package redux;

import js.Promise;

#if redux_global
@:native('Redux')
#else
@:jsRequire('redux')
#end
extern class Redux
{
	/**
		http://redux.js.org/docs/api/createStore.html
	**/
	static public function createStore<TState>(rootReducer:Reducer<TState>, ?initialState:TState, ?enhancer:Dynamic):Store<TState>;
	
	/**
		http://redux.js.org/docs/api/combineReducers.html
	**/
	static public function combineReducers<TState>(reducers:Dynamic):Reducer<TState>;
	
	/**
		http://redux.js.org/docs/api/applyMiddleware.html
	**/
	static public function applyMiddleware(middlewares:haxe.extern.Rest<Middleware>):Enhancer;
	
	/**
		http://redux.js.org/docs/api/bindActionCreators.html
	**/
	//static public function bindActionCreators(actionCreators:Dynamic, dispatch:ActionPayload -> Dynamic):Dynamic;
}

typedef Dispatch = Action -> Dynamic;
typedef Enhancer = Dynamic;
typedef Middleware = Dynamic;
typedef StoreListener = Void -> Void;
typedef Unsubscribe = Void -> Void;

typedef ActionPayload = {
	type:String,
	?value:Dynamic
}

@:forward(type, value)
abstract Action(ActionPayload)
{
	inline function new(a:ActionPayload)
	{
		this = a;
	}
	
	@:from static public function map(ev:EnumValue)
	{
		var e = Type.getEnum(ev);
		return new Action({
			type:e.getName(),
			value:ev
		});
	}
}
