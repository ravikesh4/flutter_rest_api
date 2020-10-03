import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:octdesign/services/notes_service.dart';
import 'package:octdesign/views/note_list.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => NotesServices());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NoteList(),
    );
  }
}
