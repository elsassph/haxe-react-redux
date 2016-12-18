package router;

typedef RouterLocation = {
	pathname:String,
	search:String,
	state:Dynamic,
	action:RouterAction,
}

@:enum
abstract RouterAction(String) 
{
	var PUSH = 'PUSH';
	var REPLACE = 'REPLACE';
	var POP = 'POP';
}
