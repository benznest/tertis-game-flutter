import 'package:flutter/material.dart';
import 'package:tertis_game_flutter/block.dart';
import 'package:tertis_game_flutter/coordinate.dart';

class BlockL {
  static Block create() {
    Block block = Block();
    block.color = Colors.red;
//    block.coordinates.add(Coordinate(row: 0, col: 3));
//    block.coordinates.add(Coordinate(row: 1, col: 3));
//    block.coordinates.add(Coordinate(row: 2, col: 3));
//    block.coordinates.add(Coordinate(row: 2, col: 4));
    return block;
  }
}
