import 'package:flutter/material.dart';
import '../../local/note_local.dart';
import '../../model/note_model.dart';
import '../note_screen/note_screen.dart';

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final DatabaseProvider databaseProvider = DatabaseProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Text(
          'Notes',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: FutureBuilder<List<Note>>(
        future: databaseProvider.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddNotePage(note: note),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Text('No notes found.');
          }
        },
      ),
      floatingActionButton: Container(
        height: 40,
        width: 100,
        child: FloatingActionButton(
          backgroundColor: Colors.white10,
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddNotePage(),
              ),
            );
          },
          elevation: 2.0,
          child: Text('ADD NOTE',style: TextStyle(color: Colors.black),),
          //backgroundColor: Colors.brown[200],
        ),
      ),
    );
  }
}