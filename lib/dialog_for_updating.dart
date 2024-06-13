import 'package:flutter/material.dart';
import 'package:untitled1/database_helper.dart';

Future<void> showEditDialog(Map<String, dynamic> note,context) async {
  TextEditingController titleController = TextEditingController(text: note['title']);
  TextEditingController contentController = TextEditingController(text: note['content']);
  Map<String, dynamic> updatedNote = {
    'id': note['id'],
    'title': note['title'],
    'content': note['content'],
  };
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Update'),
            onPressed: () async {
              updatedNote['title'] = titleController.text;
              updatedNote['content'] = contentController.text;
              await DatabaseHelper.instance.update(updatedNote);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
