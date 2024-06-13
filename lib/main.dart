import 'package:flutter/material.dart';
import 'package:untitled1/dialog_for_updating.dart';

import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQFlite Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: _contentController, decoration: const InputDecoration(labelText: 'Content')),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.insert({
                  'title': _titleController.text,
                  'content': _contentController.text,
                });
                setState(() {});
                _titleController.clear();
                _contentController.clear();
              },
              child: const Text('Add Note'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper.instance.queryAll(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          showEditDialog(snapshot.data![index], context).then((value) {
                            setState(() {});
                          });
                        },
                        title: Text(snapshot.data![index]['title']),
                        subtitle: Text(snapshot.data![index]['content']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await DatabaseHelper.instance.delete(snapshot.data![index]['id']);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
