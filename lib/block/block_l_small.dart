import 'package:flutter/material.dart';
import 'package:tertis_game_flutter/block.dart';
import 'package:tertis_game_flutter/coordinate.dart';
import 'package:tertis_game_flutter/main.dart';

class BlockLs {
  static Block create() {
    Block block = Block();
    block.color = Colors.purple;
    block.coordinatesBlockAreaStart = Coordinate(row: 0, col: COUNT_COL ~/ 2);
    block.currentCoordinatesOnGameArea = getCoordinateRotate1();
    block.updateCurrentCoordinateOnGameAreaWithStart();

    //coordinate about rotation in area 4x4
    block.coordinates.add(getCoordinateRotate1());
    block.coordinates.add(getCoordinateRotate2());

    return block;
  }

  static List<Coordinate> getCoordinateRotate1() {
    List<Coordinate> list = List();
    list.add(Coordinate(row: 0, col: 0));
    list.add(Coordinate(row: 1, col: 0));
    list.add(Coordinate(row: 2, col: 0));
    list.add(Coordinate(row: 3, col: 0));
    return list;
  }

  static List<Coordinate> getCoordinateRotate2() {
    List<Coordinate> list = List();
    list.add(Coordinate(row: 2, col: 0));
    list.add(Coordinate(row: 2, col: 1));
    list.add(Coordinate(row: 2, col: 2));
    list.add(Coordinate(row: 2, col: 3));
    return list;
  }

}
