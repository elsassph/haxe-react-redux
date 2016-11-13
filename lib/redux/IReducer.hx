package redux;

/**
	Implement this interface to create a model providing a Redux reducer
	and its initial state.
**/
interface IReducer<TAction, TState>
{
	var initState:TState;
	function reduce(state:TState, action:TAction):TState;
}
