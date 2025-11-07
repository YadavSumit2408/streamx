import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[700]!,
      child: ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.all(12),
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
