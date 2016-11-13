package example.todo.action;

import example.todo.model.TodoList;

/**
	Redux actions to dispatch from views and match in reducer/middleware
**/
enum TodoAction
{
	Add(text:String);
	Toggle(id:String);
	Load;
	SetEntries(entries:Array<TodoState>);
}
