package example.todo.view;

import example.todo.action.TodoAction;
import example.todo.model.TodoList;
import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.Redux.Dispatch;

typedef TodoListProps = {
	message: String,
	list: Array<TodoState>,
	filter: FilterOption,
	?dispatch: Dispatch
}

/**
 * View receives new lists and enough information to compute the visible items.
 * Also although this view needs `dispatch` we avoid connecting it and instead
 * pass `dispatch` in the props.
 */
class TodoListView
	extends ReactComponentOfProps<TodoListProps>
{
	override public function render()
	{
		return jsx('
			<div>
				<TodoStatsView message=${props.message} addNew=$addNew/>
				<hr/>
				<ul>
					${renderList()}
				</ul>
				<hr/>
				<TodoFilterView/>
				<Footer/>
			</div>
		');
	}

	function addNew()
	{
		props.dispatch(TodoAction.Add('A new task'));
	}

	function renderList()
	{
		var list = applyFilter(props.list, props.filter);

		return [for (todo in list)
			jsx('<TodoView key=${todo.id} todo=$todo/>')
		];
	}

	function applyFilter(entries:Array<TodoState>, filter:FilterOption)
	{
		return switch(filter) {
			case FilterOption.All: entries;
			case FilterOption.Completed:
				entries.filter(function(entry) return entry.done);
			case FilterOption.Remaining:
				entries.filter(function(entry) return !entry.done);
		}
	}
}
