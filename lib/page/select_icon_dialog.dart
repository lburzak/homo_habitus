import 'package:flutter/material.dart';
import 'package:homo_habitus/model/icon_asset.dart';
import 'package:homo_habitus/repository/icon_asset_repository.dart';
import 'package:homo_habitus/widget/frame_tile.dart';
import 'package:provider/provider.dart';

class SelectIconDialog extends StatelessWidget {
  final ValueChanged<IconAsset>? onIconSelected;

  const SelectIconDialog({Key? key, this.onIconSelected}) : super(key: key);

  static void show(
      BuildContext context, ValueChanged<IconAsset>? onIconSelected) {
    showModalBottomSheet(
        context: context,
        builder: (context) => SelectIconDialog(
              onIconSelected: onIconSelected,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Provider<IconAssetRepository>(
      create: (context) => IconAssetRepository(),
      builder: (context, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          _IconsGrid(onIconSelected: onIconSelected),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text("Choose icon", style: Theme.of(context).textTheme.subtitle1),
    );
  }
}

class _IconsGrid extends StatelessWidget {
  const _IconsGrid({
    Key? key,
    required this.onIconSelected,
  }) : super(key: key);

  final ValueChanged<IconAsset>? onIconSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<IconAsset>>(
        future: context.read<IconAssetRepository>().findAllIcons(),
        builder: (context, snapshot) => snapshot.hasData
            ? GridView.builder(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) => FrameTile(
                    child: snapshot.data![index].asSvgPicture(context),
                    onTap: () {
                      onIconSelected!(snapshot.data![index]);
                      Navigator.pop(context);
                    }),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
