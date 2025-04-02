import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/sub_category/sub_category_controller.dart';
import 'package:kusel/screens/sub_category/sub_category_screen_parameter.dart';

class SubCategoryScreen extends ConsumerStatefulWidget {
  final SubCategoryScreenParameters subCategoryScreenParameters;

  const SubCategoryScreen(
      {super.key, required this.subCategoryScreenParameters});

  @override
  ConsumerState<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends ConsumerState<SubCategoryScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(subCategoryProvider.notifier)
          .getAllSubCategory(categoryId: widget.subCategoryScreenParameters.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Stack(
      children: [],
    );
  }
}
