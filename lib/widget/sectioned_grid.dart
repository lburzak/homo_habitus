import 'package:flutter/cupertino.dart';

class SectionedGrid extends StatelessWidget {
  const SectionedGrid({Key? key, required this.sections}) : super(key: key);

  final List<Section> sections;

  @override
  Widget build(BuildContext context) => CustomScrollView(
      slivers: sections
          .map(_buildSectionSlivers)
          .expand((widgets) => widgets)
          .toList());

  List<Widget> _buildSectionSlivers(Section section) {
    return [section.buildHeader(), section.buildGrid()];
  }
}

class Section {
  Section(
      {required this.headerBuilder,
      required this.childBuilder,
      required this.childCount});

  final Widget Function(BuildContext context) headerBuilder;
  final Widget Function(BuildContext context, int index) childBuilder;
  final int childCount;
}

extension _SectionBuilder on Section {
  Widget buildHeader() => SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        sliver: SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => headerBuilder(context),
                childCount: 1),
            itemExtent: 30),
      );

  Widget buildGrid() => SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
              (context, index) => childBuilder(context, index),
              childCount: childCount),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12)));
}
