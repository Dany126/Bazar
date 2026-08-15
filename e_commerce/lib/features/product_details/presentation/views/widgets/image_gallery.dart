import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

class ProductImageGallery extends StatefulWidget {
  const ProductImageGallery({super.key, required this.images});

  final List<String> images;

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int currentPage = 0;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: widget.images.isEmpty ? 1 : widget.images.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      if (widget.images.isEmpty) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return CachedNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          );
                        },
                      );
                    },
                  ),

                  if (widget.images.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.images.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: currentPage == index ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
