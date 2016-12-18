package router;

import react.ReactComponent;

typedef LinkLocation = {
	pathname:String,
	query:Dynamic, // { a:b, c:d } -> ?a=b&c=d
	hash:String,
	state:Dynamic
}

typedef LinkProps = {
	to:haxe.extern.EitherType<String, LinkLocation>,
	?activeClassName:String,
	?onClick:Dynamic->Void,
	?onlyActiveOnIndex:Bool,
	?className:String,
	?alt:String,
	?rel:String
}

@:jsRequire('react-router', 'Link')
extern class Link extends ReactComponentOfProps<LinkProps>
{
}
