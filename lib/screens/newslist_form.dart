import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:football_news/screens/menu.dart';

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
    final request = context.watch<CookieRequest>(); // Add CookieRequest

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
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // POST request to local Django backend
                    final response = await request.postJson(
                      "http://localhost:8000/create-flutter/", // <-- Localhost URL
                      jsonEncode({
                        "title": _title,
                        "content": _content,
                        "thumbnail": _thumbnail,
                        "category": _category,
                        "is_featured": _isFeatured,
                      }),
                    );

                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("News successfully saved!"),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Something went wrong, please try again."),
                        ));
                      }
                    }

                    // Reset form
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
