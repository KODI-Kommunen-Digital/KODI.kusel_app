import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Text("Search");
  }
}

