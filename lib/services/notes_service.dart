
import 'dart:convert';

import 'package:octdesign/modals/api_response.dart';
import 'package:octdesign/modals/note_for_listing.dart';
import 'package:octdesign/modals/note.dart';
import 'package:octdesign/modals/note_insert.dart';
import 'package:http/http.dart' as http;

class NotesServices {

  static const API = 'http://api.notes.programmingaddict.com';
  static const headers = {
    'apikey' : '4108a75f-d3ee-4c08-b2e1-e04baeb685f3',
    'Content-Type' : 'application/json'
  };

  Future<APIResponse<List<NoteForListing>>> getNotesList() {
    return http.get(API + '/notes', headers: headers)
        .then((data) {
          if ( data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            final notes = <NoteForListing>[];
            for ( var item in jsonData) {
              notes.add(NoteForListing.fromJson(item));
            }
            return APIResponse<List<NoteForListing>>(data: notes,);
          }
          return APIResponse<List<NoteForListing>>(error: true, errorMessage: 'An Error occured');
    }).catchError((_) => APIResponse<List<NoteForListing>>(error: true, errorMessage: 'An Error occured'));
  }

  Future<APIResponse<Note>> getNote(String noteId) {
    return http.get(API + '/notes/' + noteId, headers: headers)
        .then((data) {
      if ( data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        return APIResponse<Note>(data: Note.fromJson(jsonData),);
      }
      return APIResponse<Note>(error: true, errorMessage: 'An Error occured');
    }).catchError((_) => APIResponse<Note>(error: true, errorMessage: 'An Error occured'));
  }

  Future<APIResponse<bool>> createNote(NoteInsert item) {
    return http.post(API + '/notes', headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if ( data.statusCode == 201) {
        return APIResponse<bool>(data: true,);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An Error occured');
    }).catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An Error occured'));
  }

  Future<APIResponse<bool>> updateNote( String noteId,NoteInsert item) {
    return http.put(API + '/notes/' + noteId, headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if ( data.statusCode == 204) {
        return APIResponse<bool>(data: true,);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An Error occured');
    }).catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An Error occured'));
  }

  Future<APIResponse<bool>> deleteNote( String noteId) {
    return http.delete(API + '/notes/' + noteId, headers: headers)
        .then((data) {
      if ( data.statusCode == 204) {
        return APIResponse<bool>(data: true,);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An Error occured');
    }).catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An Error occured'));
  }
}