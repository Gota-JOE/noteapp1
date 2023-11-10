import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../local/note_local.dart';
import '../../model/note_model.dart';
import '../note_list_screen/note_list_screen.dart';

class AddNotePage extends StatefulWidget {
  final Note? note;

  AddNotePage({Key? key, this.note}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final DatabaseProvider databaseProvider = DatabaseProvider();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Text(
          'Add Note',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Deletion'),
                      content:
                          Text('Are you sure you want to delete this note?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            databaseProvider.deleteNote(widget.note?.id ?? 0);
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => NotesList(),
                            ));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16), // Add some spacing
            TextField(
              controller: contentController,
              maxLines: null, // Allow multiple lines
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 60,
              child: FloatingActionButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                backgroundColor: Colors.white10,
                elevation: 2.0,
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                onPressed: () {
                  final title = titleController.text;
                  final content = contentController.text;
                  if (title.isNotEmpty || content.isNotEmpty) {
                    final note = Note(
                      title: title,
                      content: content,
                    );
                    if (widget.note == null) {
                      databaseProvider.createNote(note);
                    } else {
                      note.id = widget.note!.id;
                      databaseProvider.updateNote(note);
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => NotesList(),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/***import 'package:flutter/material.dart';

    import '../../local/note_local.dart';

    class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
    }

    class _HomeScreenState extends State<HomeScreen> {
    getNotes()async{
    final notes = await NoteDatabase.db.getNotes();
    return notes;
    }
    @override
    Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Text('Note'),
    ),
    body: FutureBuilder(
    future: getNotes(),
    builder: (context,noteData) {
    if (noteData.connectionState == ConnectionState.waiting ) {
    return Center(child: CircularProgressIndicator(),);
    }
    else if( ConnectionState.done == true){
    if(noteData.data == Null){
    return Center(child: Text('you dont have any notes yet'),);
    }else{}
    }
    },
    ),
    );
    }
    }**/
