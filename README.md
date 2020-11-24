# todo_list

A new Flutter project.

## Getting Started

The functioning of code is as following:

## About the UI

When the app opens, then the main() function of the "main.dart" file is invoked in which the light and dark themes are enabled, and the MyApp class as Stateful Widget is defined representing the list view showing the list of todos loaded from the Firebase FireStore collection named as "MyTodos" in the order of creation (DateTime) of the tasks by the users. 

Then, in the list view, each item is represented as a custom card widget defined in the file "todo_card.dart" containing various nested widgets in itself like each card is containing a row which is having 2 columns as its children (each of which is enclosed inside Expanded widgets in order to avoid infinite width all over the row and also providing the control over expanding first column child using flex 10 as 10:1 ratio of column 1 to column2 over the screen) in which again the first column is containing 3 children rows referring to title of the task, creation datetime showing created at "how much time ago" and time left or the deadline for the completion of the task. 

Now, comes the second column that is containing two icon buttons as edit and delete which invoke the functionality of updating a particular todo task and deleting a task respectively, both from the list view and the FireStore db.

There is a FloatingActionButton which is used for adding task into the list view and the FireStore db by presenting an alert dialog to the user enabling him to enter the todo task title and the deadline date and time.


## About the Database

In "todo_db.dart" file, the TodoDb class containing the variables todoTitle as String and deadline as DateTime, and the functions createTodos(), deleteTodos() and updateTodos() that are used for adding, deleting and updating or editing the respective todo tasks from the UI and reflecting the particular changes into the FireStore db.

These functions are called on the particular actions taken by the user involving:

1. Pressing FloatingActionButton that in turn presents the AlertDialog that enables the user to enter the title of the new todo task and also a date picker to choose the date and time referring to the deadline for that created task, and after that pressing the "ADD" button will add that task into the FireStore collection "MyTodos" by calling the createTodos() function mentioned above, that creates the new task as a document entitled as Todo followed by a unique id that is created and stored in the id variable, and its further used for referring the document snapshots wherever needed. Thus, each "Todo" document inside the "MyTodos" collection contains the 3 fields named as todoTitle, createdAt and deadline.

2. Pressing the pencil icon on any of the todo card in the list view opens up the alert dialog with the textfield containing the default text as the todoTitle of that particular task and the datepicker containing the deadline datetime of that particular task, thereby allowing user to edit the respective fields, and then by pressing the "EDIT" button reflecting those changes to the FireStore db by invoking the updateTodos() function passing the particular todo as document snapshot as argument and thereby getting the todo as document reference using the id and making the required changes into the same and showing those changes back into the list view.

3. Pressing the bin icon on any of the todo card in the list view or sliding any list item or the Dismissible in any direction allows the user to delete that particular task from the list view and also from the FireStore db by invoking the function deleteTodos() for that particular todo task using the document snapshot as argument and getting the document reference referring to the particular todo task using the id, and thereby deleting it from the FireStore and reflecting those changes back to the list view.










## Demo Videos (Screen Recordings):

TodoApp Light Theme (Android Screen Recording): https://drive.google.com/file/d/10h6-cCMXc6OKUbR0OEqjVtfIfY2zSlNl/view?usp=sharing

TodoApp Dark Theme (Android Screen Recording): https://drive.google.com/file/d/1kIFON3xxycE2Ao5hpBq9oVW8oj77FcvU/view?usp=sharing



## APK file:

https://drive.google.com/file/d/1y0LYXViU_5t6HADDTiPLBIhqHKeT3y7T/view?usp=sharing




