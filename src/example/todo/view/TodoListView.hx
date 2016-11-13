/*
Copyright (c) 2016 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

package example.todo.view;

import example.todo.action.TodoAction;
import example.todo.model.TodoList;
import react.ReactComponent;
import react.ReactMacro.jsx;
import redux.react.IConnectedComponent;

typedef TodoListState = {
	?message: String,
	?list: Array<TodoState>
}

class TodoListView extends ReactComponentOfState<TodoListState> implements IConnectedComponent
{
	public function new()
	{
		super();
	}
	
	function mapState(state:ApplicationState)
	{
		var todoList = state.todoList;
		var entries = todoList.entries;
		var message = 
			todoList.loading 
			? 'Loading...'
			: entries.length == 0
			  ? 'No items'
			  : '${getRemaining(entries)} remaining of ${entries.length} items completed';
		
		return {
			message: message,
			list: entries
		}
	}
	
	function getRemaining(entries:Array<TodoState>)
	{
		return entries.filter(function(todo) return !todo.done).length;
	}
	
	override public function render():ReactElement 
	{
		return jsx('
			<div>
				<TodoStatsView message=${state.message} addNew=${addNew}/>
				<hr/>
				<ul>
					${mapList()}
				</ul>
			</div>
		');
	}
	
	function addNew() 
	{
		dispatch(TodoAction.Add('A new task'));
	}
	
	function mapList()
	{
		return [for (todo in state.list)
			jsx('<TodoView key=${todo.id} todo=$todo/>')
		];
	}
}
