import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Text("location screen");
  }
}

