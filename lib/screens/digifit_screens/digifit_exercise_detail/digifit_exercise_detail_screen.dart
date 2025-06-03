import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DigifitExerciseDetailScreen extends ConsumerStatefulWidget {
  const DigifitExerciseDetailScreen({super.key});

  @override
  ConsumerState<DigifitExerciseDetailScreen> createState() =>
      _DigifitExerciseDetailScreenState();
}

class _DigifitExerciseDetailScreenState
    extends ConsumerState<DigifitExerciseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [],
        ),
      )),
    );
  }
}
