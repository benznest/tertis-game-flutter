import 'package:flutter/material.dart';
import 'package:tertis_game_flutter/coordinate.dart';

class Block {
  Color color;
  Coordinate coordinatesBlockAreaStart;
  List<Coordinate> currentCoordinatesOnGameArea = List();
  List<List<Coordinate>> coordinates = List();
  int currentRotateIndex = 0;

  List<Coordinate> getBlockCurrentRotate() {
    return coordinates[currentRotateIndex];
  }

  List<Coordinate> getBlockNextRotate() {
    if (currentRotateIndex + 1 < coordinates.length) {
      return coordinates[currentRotateIndex + 1];
    }
    return coordinates[0];
  }

   rotate() {
    List<Coordinate> coordinatesNextBlock = getBlockNextRotate();
    List<Coordinate> listNewCoordinateOnGameArea = List();
    for (Coordinate c in coordinatesNextBlock) {
      Coordinate newCoordinate = Coordinate(
          row: coordinatesBlockAreaStart.row + c.row,
          col: coordinatesBlockAreaStart.row + c.col);
      listNewCoordinateOnGameArea.add(newCoordinate);
    }

    currentCoordinatesOnGameArea = listNewCoordinateOnGameArea;
    if(currentRotateIndex+1 < coordinates.length) {
      currentRotateIndex++;
    }else{
      currentRotateIndex = 0;
    }
  }
}
