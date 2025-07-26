import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/api.dart';

class NetworkImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  const NetworkImageWidget({
    super.key,
    required this.image,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${Api.baseAudioPath}$image",
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(height: height, width: width, color: Colors.white),
      ),
      errorWidget: (context, url, error) => Container(
        height: height,
        width: width,
        color: Colors.grey,
        child: const Icon(Icons.broken_image, color: Colors.white),
      ),
    );
  }
}
