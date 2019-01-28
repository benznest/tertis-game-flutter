import 'package:flutter/material.dart';
import 'package:tertis_game_flutter/block.dart';
import 'package:tertis_game_flutter/coordinate.dart';

class BlockO {
  static Block create() {
    Block block = Block();
    block.color = Colors.blue;
//    block.coordinates.add(Coordinate(row: 0, col: 3));
//    block.coordinates.add(Coordinate(row: 0, col: 4));
//    block.coordinates.add(Coordinate(row: 1, col: 3));
//    block.coordinates.add(Coordinate(row: 1, col: 4));
    return block;
  }
}
