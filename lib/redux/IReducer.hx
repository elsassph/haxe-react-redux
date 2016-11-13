package redux;

interface IReducer<TAction, TState>
{
	var initState:TState;
	function reduce(state:TState, action:TAction):TState;
}
