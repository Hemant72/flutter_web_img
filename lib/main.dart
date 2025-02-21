import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

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
  String? _currentImageUrl;
  late final String _viewId;

  html.ImageElement? _imageElement;

  @override
  void initState() {
    super.initState();
    _viewId = 'imageElement-${DateTime.now().millisecondsSinceEpoch}';
    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final imageElement =
          html.ImageElement()
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.objectFit = 'contain'
            ..onDoubleClick.listen((_) => toggleFullscreen());

      _imageElement = imageElement;
      return imageElement;
    });
  }

  void toggleFullscreen() {
    final document = html.document;
    final element = document.documentElement;

    if (document.fullscreenElement == null) {
      element?.requestFullscreen();
    } else {
      document.exitFullscreen();
    }
  }

  void loadImage() {
    if (_urlController.text.isNotEmpty) {
      setState(() {
        _currentImageUrl = _urlController.text;
        _isImageVisible = true;
        if (_imageElement != null) {
          _imageElement!.src = _currentImageUrl!;
        }
      });
    }
  }

  void toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
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
                          _isImageVisible && _currentImageUrl != null
                              ? HtmlElementView(viewType: _viewId)
                              : const Center(child: Text('No image loaded')),
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
                      onPressed: loadImage,
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
            Positioned(
              right: 16,
              bottom: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      toggleFullscreen();
                      toggleMenu();
                    },
                    icon: const Icon(Icons.fullscreen),
                    label: const Text('Enter fullscreen'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      html.document.exitFullscreen();
                      toggleMenu();
                    },
                    icon: const Icon(Icons.fullscreen_exit),
                    label: const Text('Exit fullscreen'),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleMenu,
        child: Icon(Icons.add),
      ),
    );
  }
}
