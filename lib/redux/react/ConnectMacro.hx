package redux.react;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ClassType;

/**
	Modify classes implementing IConnectedComponent to inject the connection logic
**/
class ConnectMacro
{
	static public function build() 
	{
		var type:ClassType = Context.getLocalClass().get();
		type.meta.add(':expose', [], Context.currentPos());
		
		var fields = Context.getBuildFields();
		
		// wire 'store' in context
		addContextTypes(fields);
		// add 'dispatch' method 
		addDispatch(fields);
		
		// if class has 'mapState' method
		if (hasMapState(fields))
		{
			// subscribe to state changes and call 'mapState' to update the view state
			addUnsub(fields);
			addCache(fields);
			addConnect(fields);
			if (!updateMount(fields)) addMount(fields);
			if (!updateUnmount(fields)) addUnmount(fields);
			// set initial state in constructor
			updateCtor(fields);
		}
		return fields;
	}
	
	/* BASIC CONNECTION: store and dispatch */
	
	static function hasMapState(fields:Array<Field>) 
	{
		for (field in fields)
			if (field.name == 'mapState') return true;
		return false;
	}
	
	static function addContextTypes(fields:Array<Field>) 
	{
		var contextTypes = macro {
			store: react.React.PropTypes.object.isRequired
		};
		fields.push({
			name: 'contextTypes',
			access: [APublic, AStatic],
			kind: FVar(null, contextTypes),
			pos: Context.currentPos()
		});
	}
	
	static function addDispatch(fields:Array<Field>) 
	{
		fields.push({
			name: 'dispatch',
			access: [APublic],
			kind: FFun({
				args:[{ name:'action', type: macro: redux.Redux.Action }],
				ret: macro :Void,
				expr: macro {
					context.store.dispatch(action);
				}
			}),
			pos: Context.currentPos()
		});
	}
	
	/* MAP STATE */
	
	static function exprUnmount()
	{
		return macro {
			if (__unsubscribe != null) __unsubscribe();
			__state = null;
		}
	}
	
	static function exprMount()
	{
		return macro __unsubscribe = context.store.subscribe(__connect);
	}
	
	static function addUnmount(fields:Array<Field>) 
	{
		var componentWillUnmount = {
			args: [],
			ret: macro :Void,
			expr: exprUnmount()
		}
		
		fields.push({
			name: 'componentWillUnmount',
			access: [APublic, AOverride],
			kind: FFun(componentWillUnmount),
			pos: Context.currentPos()
		});
	}
	
	static function updateUnmount(fields:Array<Field>) 
	{
		for (field in fields)
		{
			if (field.name == 'componentWillUnmount')
			{
				switch (field.kind) {
					case FFun(f):
						f.expr = macro {
							${exprUnmount()}
							${f.expr}
						};
						return true;
					default:
				}
			}
		}
		return false;
	}
	
	static function addMount(fields:Array<Field>) 
	{
		var componentDidMount = {
			args: [],
			ret: macro :Void,
			expr: exprMount()
		}
		
		fields.push({
			name: 'componentDidMount',
			access: [APublic, AOverride],
			kind: FFun(componentDidMount),
			pos: Context.currentPos()
		});
	}
	
	static function updateMount(fields:Array<Field>) 
	{
		for (field in fields)
		{
			if (field.name == 'componentDidMount')
			{
				switch (field.kind) {
					case FFun(f):
						f.expr = macro {
							${f.expr}
							${exprMount()}
						};
						return true;
					default:
				}
			}
		}
		return false;
	}
	
	static function addConnect(fields:Array<Field>) 
	{
		fields.push({
			name: '__connect',
			access: [APrivate],
			kind: FFun({
				args:[],
				ret: macro :Void,
				expr: macro {
					var state = mapState(context.store.getState());
					if (__state == null || !react.ReactUtil.shallowCompare(__state, state))
					{
						__state = state;
						setState(state);
					}
				}
			}),
			pos: Context.currentPos()
		});
	}
	
	static function addCache(fields:Array<Field>) 
	{
		fields.push({
			name: '__state',
			access: [APrivate],
			kind: FVar(macro :Dynamic),
			pos: Context.currentPos()
		});
	}
	
	static function addUnsub(fields:Array<Field>) 
	{
		fields.push({
			name: '__unsubscribe',
			access: [APrivate],
			kind: FVar(macro :Void -> Void),
			pos: Context.currentPos()
		});
	}
	
	static function updateCtor(fields:Array<Field>) 
	{
		for (field in fields)
			if (field.name == 'new')
			{
				switch (field.kind)
				{
					case FFun(f):
						if (f.args.length < 1) f.args.push({ name:'props', type: macro: Dynamic });
						if (f.args.length < 2) f.args.push({ name:'context', type: macro: Dynamic });
						f.expr = macro {
							${f.expr}
							state = __state = mapState(context.store.getState());
						};
					default:
				}
				return;
			}
	}
}
#end
