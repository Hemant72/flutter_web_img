import 'dart:js' as js;

import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

/// [Widget] displaying the home page consisting of an image the the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  bool _isImageVisible = false;
  bool _isMenuOpen = false;

  void _loadImage() {
    final url = _urlController.text;
    if (url.isNotEmpty) {
      js.context.callMethod('setImageSource', ['image', url]);
      setState(() {
        _isImageVisible = true;
      });
    }
  }

  void _toggleFullscreen() {
    js.context.callMethod('toggleFullscreen', ['image']);
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _closeMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          _isImageVisible
                              ? GestureDetector(
                                onDoubleTap: _toggleFullscreen,
                                child: HtmlElementView(viewType: 'image'),
                              )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _urlController,
                        decoration: InputDecoration(hintText: 'Image URL'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _loadImage,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),

          if (_isMenuOpen)
            GestureDetector(
              onTap: _closeMenu,
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          if (_isMenuOpen)
            Positioned(
              right: 16,
              bottom: 80,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _toggleFullscreen();
                      _closeMenu();
                    },
                    child: Text('Enter Fullscreen'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Exit fullscreen logic
                      _closeMenu();
                    },
                    child: Text('Exit Fullscreen'),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleMenu,
        child: Icon(Icons.add),
      ),
    );
  }
}
