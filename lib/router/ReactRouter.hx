package router;

import react.ReactComponent;

typedef RouterHistory = Dynamic;

/**
 * React-router API
 * https://github.com/ReactTraining/react-router/blob/master/docs/API.md
 */
@:jsRequire('react-router')
extern class ReactRouter 
{
	/** HTML5 history */
	static public var browserHistory:RouterHistory;
	/** URL #history */
	static public var hashHistory:RouterHistory;
}


typedef RouterProps = {
	?children:Dynamic,
	?routes:Dynamic,
	?history:ReactRouter.RouterHistory,
	?createElement:Dynamic->Dynamic->ReactElement,
	?onError:Dynamic->Void,
	?onUpdate:Dynamic->Void,
	?render:Dynamic->ReactElement //<RouterContext>
}

@:jsRequire('react-router', 'Router')
extern class Router extends ReactComponentOfProps<RouterProps>
{
	public var location:RouterLocation;
	public var params:Dynamic;
	
	public function createHref(location:RouterLocation):String;
	public function createLocation(location:RouterLocation):RouterLocation;
	public function createPath(location:RouterLocation):String;
	
	public function go(n:Int):Void;
	public function goBack():Void;
	public function goForward():Void;
	public function isActive(location:RouterLocation, indexOnly:Bool):Bool;
	public function push(location:RouterLocation):Void;
	public function replace(location:RouterLocation):Void;
	public function transitionTo(nextLocation:RouterLocation):Void;
}


typedef BaseRouteProps = {
	?children:Dynamic,
	?component:Class<ReactComponent>,
	?components:Dynamic, // {a:A, b:B} -> <App a={<A/>} b={<B/>}/>
	?getComponent:Dynamic, // async 'compponent'
	?getComponents:Dynamic, // async 'components'
	?onEnter:Dynamic,
	?onChange:Dynamic,
	?onLeave:Dynamic
}

typedef RouteProps = {>BaseRouteProps,
	path:String
}

@:jsRequire('react-router', 'Route')
extern class Route extends ReactComponentOfProps<RouteProps>
{
}


@:jsRequire('react-router', 'IndexRoute')
extern class IndexRoute extends ReactComponentOfProps<BaseRouteProps>
{
}


typedef RedirectProps = {
	from:String,
	to:Dynamic
}

@:jsRequire('react-router', 'Redirect')
extern class Redirect extends ReactComponentOfProps<RedirectProps>
{
}


typedef IndexRedirectProps = {
	to:Dynamic
}

@:jsRequire('react-router', 'IndexRedirect')
extern class IndexRedirect extends ReactComponentOfProps<IndexRedirectProps>
{
}

