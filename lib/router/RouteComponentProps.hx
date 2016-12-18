package router;

import router.ReactRouter;

/** 
 * Props received by a component in a route
 * https://github.com/ReactTraining/react-router/blob/master/docs/API.md#injected-props
 */
typedef RouteComponentProps = {
	location:RouterLocation,
	params:Dynamic,
	route:Route,
	router:Router,
	routeParams:Dynamic,
	children:Dynamic
}
