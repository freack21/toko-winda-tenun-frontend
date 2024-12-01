import 'package:flutter/material.dart';
import 'package:frontend/components/card_component.dart';
import 'package:photo_view/photo_view.dart';

class ImageFullscreenPage extends StatelessWidget {
  final String imageUrl;

  const ImageFullscreenPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PhotoView(
        imageProvider: cachedNetworkImageProvider(imageUrl),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
      ),
    );
  }
}
