import example.todo.view.AboutScreen;
import example.todo.view.TodoListScreen;
import js.Browser;
import js.html.DivElement;
import react.ReactDOM;
import react.ReactMacro.jsx;
import redux.Store;
import redux.react.Provider;
import router.Link;
import router.ReactRouter;
import router.RouteComponentProps;

class Main
{
	/**
		Entry point:
		- setup redux store
		- setup react rendering
		- send a few test messages
	**/
	public static function main()
	{
		var store = ApplicationStore.create();
		var root = createRoot();
		render(root, store);

		ApplicationStore.startup(store);
	}

	static function createRoot()
	{
		var root = Browser.document.createDivElement();
		Browser.document.body.appendChild(root);
		return root;
	}

	static function render(root:DivElement, store:Store<ApplicationState>)
	{
		var history = ReactRouter.browserHistory;

		var app = ReactDOM.render(jsx('

			<Provider store=$store>
				<Router history=$history>
					<Route path="/" component=$pageWrapper>
						<IndexRoute getComponent=${RouteBundle.load(TodoListScreen)}/>
						<Route path="about" getComponent=${RouteBundle.load(AboutScreen)}/>
					</Route>
				</Router>
			</Provider>

		'), root);

		#if (debug && react_hot)
		ReactHMR.autoRefresh(app);
		#end
	}

	static function pageWrapper(props:RouteComponentProps)
	{
		return jsx('
			<div>
				<nav>
					<Link to="/">Todo</Link> | <Link to="/about">About</Link>
				</nav>
				${props.children}
			</div>
		');
	}
}
