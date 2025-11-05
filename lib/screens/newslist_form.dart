import 'package:flutter/material.dart';

class NewsFormPage extends StatefulWidget {
  const NewsFormPage({super.key});

  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Form field variables
  String _title = '';
  String _content = '';
  String _category = '';
  String _thumbnail = '';
  bool _isFeatured = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add News',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) => setState(() => _title = value),
                validator: (value) =>
                value == null || value.isEmpty ? 'Title cannot be empty!' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Content'),
                onChanged: (value) => setState(() => _content = value),
                validator: (value) =>
                value == null || value.isEmpty ? 'Content cannot be empty!' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (value) => setState(() => _category = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Thumbnail URL'),
                onChanged: (value) => setState(() => _thumbnail = value),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Featured News?'),
                value: _isFeatured,
                onChanged: (value) => setState(() => _isFeatured = value),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  WidgetStateProperty.all(Colors.indigo),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('News Saved!'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Title: $_title'),
                                Text('Content: $_content'),
                                Text('Category: $_category'),
                                Text('Thumbnail: $_thumbnail'),
                                Text('Featured: ${_isFeatured ? "Yes" : "No"}'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    _formKey.currentState!.reset();
                    setState(() {
                      _title = '';
                      _content = '';
                      _category = '';
                      _thumbnail = '';
                      _isFeatured = false;
                    });
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
