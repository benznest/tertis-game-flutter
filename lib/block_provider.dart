import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tertis_game_flutter/block.dart';
import 'package:tertis_game_flutter/coordinate.dart';

class BlockProvider {

  static const int BLOCK_S = 0;
  static const int BLOCK_T = 1;
  static const int BLOCK_L = 2;
  static const int BLOCK_O = 3;
  static const int COUNT_BLOCK_TYPE = 4;


  static Block randomBlock() {
    Random random = Random();
    int id = random.nextInt(COUNT_BLOCK_TYPE);
    if (id == BLOCK_S) {
      return createS();
    } else if (id == BLOCK_T) {
      return createT();
    } else if (id == BLOCK_L) {
      return createL();
    }else if (id == BLOCK_O) {
      return createO();
    }
    return createS();
  }

  static Block createS() {
    Block block = Block();
    block.color = Colors.yellow;
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 0, col: 1));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 1, col: 1));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 1, col: 2));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 2, col: 2));
    return block;
  }

  static Block createT() {
    Block block = Block();
    block.color = Colors.green;
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 0, col: 3));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 0, col: 4));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 0, col: 5));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 1, col: 4));
    return block;
  }

  static Block createL() {
    Block block = Block();
    block.color = Colors.red;
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 0, col: 3));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 1, col: 3));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 2, col: 3));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 2, col: 4));
    return block;
  }

  static Block createO() {
    Block block = Block();
    block.color = Colors.blue;
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 0, col: 3));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 0, col: 4));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 1, col: 3));
    block.currentCoordinatesOnGameArea.add(Coordinate(row: 1, col: 4));
    return block;
  }
}