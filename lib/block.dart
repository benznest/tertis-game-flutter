import 'package:flutter/material.dart';
import 'package:tertis_game_flutter/coordinate.dart';
import 'package:tertis_game_flutter/main.dart';

class Block {
  Color color;
  Coordinate coordinatesBlockAreaStart;
  List<Coordinate> currentCoordinatesOnGameArea = List();
  List<List<Coordinate>> coordinates = List();
  int currentRotateIndex = 0;
  Function(int) onRotateOverRight;
  Function(int) onRotateOverLeft;

  List<Coordinate> getBlockCurrentRotate() {
    return coordinates[currentRotateIndex];
  }

  List<Coordinate> getBlockNextRotate() {
    if (currentRotateIndex + 1 < coordinates.length) {
      return coordinates[currentRotateIndex + 1];
    }
    return coordinates[0];
  }

  updateCurrentCoordinateOnGameAreaWithStart(){
    for(Coordinate c in currentCoordinatesOnGameArea){
      c.row += coordinatesBlockAreaStart.row;
      c.col += coordinatesBlockAreaStart.col;
    }
  }

  rotate() {
    List<Coordinate> coordinatesNextBlock = getBlockNextRotate();
    List<Coordinate> listNewCoordinateOnGameArea = List();
    for (Coordinate c in coordinatesNextBlock) {
      if (coordinatesBlockAreaStart.col + c.col >= COUNT_COL) {
        coordinatesBlockAreaStart.col = COUNT_COL - 4;
      } else if (coordinatesBlockAreaStart.col - c.col < 0) {
        coordinatesBlockAreaStart.col = 0;
      }
    }

    for (Coordinate c in coordinatesNextBlock) {

      print("rotate = ("+(coordinatesBlockAreaStart.row + c.row).toString()+","+(coordinatesBlockAreaStart.col + c.col).toString()+")");
      Coordinate newCoordinate = Coordinate(
          row: coordinatesBlockAreaStart.row + c.row,
          col: coordinatesBlockAreaStart.col + c.col);
      listNewCoordinateOnGameArea.add(newCoordinate);


    }

    currentCoordinatesOnGameArea = listNewCoordinateOnGameArea;
    if (currentRotateIndex + 1 < coordinates.length) {
      currentRotateIndex++;
    } else {
      currentRotateIndex = 0;
    }
  }
}
