import 'package:ceres_locker_app/domain/models/block.dart';

class BlockList {
  final List<Block>? _blocks;

  const BlockList(this._blocks);

  List<Block>? get blocks => _blocks?.reversed.toList();

  factory BlockList.fromJson(List<dynamic> json) {
    return BlockList(
      json.map((e) => Block.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
