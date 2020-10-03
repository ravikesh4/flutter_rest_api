import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:octdesign/services/notes_service.dart';
import 'package:octdesign/modals/note.dart';
import 'package:octdesign/modals/note_insert.dart';

class NoteModify extends StatefulWidget {

  final String noteId;
  NoteModify({this.noteId});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteId != null;

  NotesServices get notesService => GetIt.instance<NotesServices>();

  String errorMessage;
  Note note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    if(isEditing) {
      notesService.getNote(widget.noteId)
          .then((response) {
        setState(() {
          _isLoading = false;
        });
        if(response.error) {
          errorMessage = response.errorMessage ?? 'An error ocured';
        }
        note = response.data;
        _titleController.text = note.noteTitle;
        _contentController.text = note.noteContent;
      });
    }
    if(!isEditing) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( isEditing? 'Edit Note' : 'Create note'),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Note Title',
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Note Content',
              ),
            ),
            SizedBox(height: 30,),
            SizedBox(
              width: double.infinity,
              height: 35,
              child: RaisedButton(onPressed: () async {
                if (isEditing) {
                  //update
                  setState(() {
                    _isLoading = true;
                  });
                  final note = NoteInsert(
                    noteTitle: _titleController.text,
                    noteContent: _contentController.text,
                  );
                  final result = await notesService.updateNote(widget.noteId, note);
                  setState(() {
                    _isLoading = false;
                  });

                  final title = "Done";
                  final text = result.error ? (result.errorMessage ?? 'An error occured' ):
                  'Your note was updated';

                  showDialog(context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, child: Text('Ok')),
                        ],
                      )
                  )
                      .then((data) {
                    if(result.data) {
                      Navigator.of(context).pop();
                    }
                  });
                } else {
//                  insert
                  setState(() {
                    _isLoading = true;
                  });
                  final note = NoteInsert(
                    noteTitle: _titleController.text,
                    noteContent: _contentController.text,
                  );
                  final result = await notesService.createNote(note);
                  setState(() {
                    _isLoading = false;
                  });

                  final title = "Done";
                  final text = result.error ? (result.errorMessage ?? 'An error occured' ):
                  'Your note was created';

                  showDialog(context: context,
                    builder: (_) => AlertDialog(
                      title: Text(title),
                      content: Text(text),
                      actions: <Widget>[
                        FlatButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: Text('Ok')),
                      ],
                    )
                  )
                  .then((data) {
                    if(result.data) {
                      Navigator.of(context).pop();
                    }
                  });
                }
              },
              child: Text('Submit', style: TextStyle(
                color: Colors.white
              ),),
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
