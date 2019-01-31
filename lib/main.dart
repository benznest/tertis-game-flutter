import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tertis_game_flutter/area_unit.dart';
import 'package:tertis_game_flutter/block.dart';
import 'package:tertis_game_flutter/block/block_l.dart';
import 'package:tertis_game_flutter/block/block_s.dart';
import 'package:tertis_game_flutter/block_provider.dart';
import 'package:tertis_game_flutter/coordinate.dart';
import 'package:tertis_game_flutter/game_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tertis Game',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Tertis Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const int COUNT_ROW = 18;
const int COUNT_COL = 10;
const double SIZE_AREA_UNIT = 26;
const double SIZE_AREA_UNIT_NEXT_BLOCK = 18;

class _MyHomePageState extends State<MyHomePage> {
  List<List<AreaUnit>> gameArea;
  List<List<AreaUnit>> gameAreaTemp;
  List<List<AreaUnit>> gameAreaNextBlock;

  Timer timer;

  int speed = 1000;
  int delayDrag = 200;
  Block block;
  Block blockNext;
  bool draging = false;

  int countLine = 0;
  bool gameRunning = true;

  @override
  void initState() {
    initGameArea();
    initGameAreaTemp();
    initGameAreaNextBlock();
    block = createBlock();
    blockNext = createBlock();

    timer =
        Timer.periodic(Duration(milliseconds: speed), (Timer t) => process());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void process() {
    if(gameRunning) {
      setState(() {
        initGameAreaTemp(); // clear game area temp
        moveBlockDown(block);
        copyBlockToGameAreaTemp(block); //copy block to game area temp.

        if (isBlockCrashOnGround(block)) {
          onBlockToGround();
        }

        initGameAreaNextBlock();
        copyBlockToGameAreaNextBlock(blockNext);
      });
    }
  }

  void onBlockToGround() {
    bool moveBlockSuccess = copyBlockToGameArea(block);
    if(moveBlockSuccess) {
      initGameAreaTemp();
      clearCompleteLine();
      block = blockNext;
      blockNext = createBlock();
    }else{
      gameRunning = false;
      showGameOverDialog();
    }
  }

  void clearCompleteLine() {
    int row = 0;
    while (row < COUNT_ROW) {
      print("check complete line row = $row");
      int countBlock = 0;
      for (int col = 0; col < COUNT_COL; col++) {
        if (!gameArea[row][col].available) {
          countBlock++;
        } else {
          break;
        }
      }

      if (countBlock == COUNT_COL) {
        print("remove complete line row = $row");
        removeLineOnGameArea(row);
        row--;
      }

      row++;
    }
  }

  void removeLineOnGameArea(int row) {
    List<AreaUnit> list = List.of(gameArea.first);
    gameArea.removeAt(row);
    gameArea.insert(0, list);
    countLine++;
  }

  bool moveBlockDown(Block block) {
    for (Coordinate c in block.currentCoordinatesOnGameArea) {
      if (c.row + 1 >= COUNT_ROW || !gameArea[c.row + 1][c.col].available) {
        return false;
      }
    }

    block.coordinatesBlockAreaStart.row++;

    for (Coordinate c in block.currentCoordinatesOnGameArea) {
      c.row = c.row + 1;
    }

    return true;
  }

  bool moveBlockRight(Block block) {
    for (Coordinate c in block.currentCoordinatesOnGameArea) {
      if (c.col + 1 >= COUNT_COL || !gameArea[c.row][c.col + 1].available) {
        return false;
      }
    }

    block.coordinatesBlockAreaStart.col++;

    for (Coordinate c in block.currentCoordinatesOnGameArea) {
      c.col = c.col + 1;
    }

    return true;
  }

  bool moveBlockLeft(Block block) {
    for (Coordinate c in block.currentCoordinatesOnGameArea) {
      if (c.col - 1 < 0 || !gameArea[c.row][c.col - 1].available) {
        return false;
      }
    }

    block.coordinatesBlockAreaStart.col--;

    for (Coordinate c in block.currentCoordinatesOnGameArea) {
      c.col = c.col - 1;
    }

    return true;
  }

  void moveGameAreaTempDown() {
    List<AreaUnit> list = List.of(gameAreaTemp[COUNT_ROW - 1]);
    gameAreaTemp.removeAt(COUNT_ROW - 1);
    gameAreaTemp.insert(0, list);
  }

  void copyBlockToGameAreaTemp(Block block) {
    for (Coordinate c in block.currentCoordinatesOnGameArea) {
      gameAreaTemp[c.row][c.col] =
          AreaUnit(color: block.color, available: false);
    }
  }

  bool copyBlockToGameArea(Block block) {
    for (Coordinate c in block.currentCoordinatesOnGameArea) {
      if( gameArea[c.row][c.col].available) {
        gameArea[c.row][c.col] = AreaUnit(color: block.color, available: false);
      }else{
        return false;
      }
    }
    return true;
  }

  void copyBlockToGameAreaNextBlock(Block block) {
    for (Coordinate c in block.coordinates.first) {
      gameAreaNextBlock[c.row][c.col] =
          AreaUnit(color: block.color, available: false);
    }
  }

  void initGameAreaTemp() {
    gameAreaTemp = List();
    for (int i = 0; i < COUNT_ROW; i++) {
      List<AreaUnit> listAreaTemp = List();
      for (int j = 0; j < COUNT_COL; j++) {
        listAreaTemp.add(AreaUnit());
      }
      gameAreaTemp.add(listAreaTemp);
    }
  }

  void initGameAreaNextBlock() {
    gameAreaNextBlock = List();
    for (int i = 0; i < 4; i++) {
      List<AreaUnit> listAreaTemp = List();
      for (int j = 0; j < 4; j++) {
        listAreaTemp.add(AreaUnit());
      }
      gameAreaNextBlock.add(listAreaTemp);
    }
  }

  void initGameArea() {
    gameArea = List();
    for (int i = 0; i < COUNT_ROW; i++) {
      List<AreaUnit> listArea = List();
      for (int j = 0; j < COUNT_COL; j++) {
        listArea.add(AreaUnit());
      }
      gameArea.add(listArea);
    }

//    gameArea[COUNT_ROW - 2][2] = AreaUnit(available: false, color: Colors.red);
//    gameArea[COUNT_ROW - 1][1] = AreaUnit(available: false, color: Colors.red);
//    gameArea[COUNT_ROW - 1][2] = AreaUnit(available: false, color: Colors.red);
//    gameArea[COUNT_ROW - 1][1] = AreaUnit(available: false, color: Colors.red);
//    gameArea[COUNT_ROW - 1][6] = AreaUnit(available: false, color: Colors.red);
//    gameArea[COUNT_ROW - 2][6] = AreaUnit(available: false, color: Colors.red);
//    gameArea[COUNT_ROW - 3][6] = AreaUnit(available: false, color: Colors.red);
//    gameArea[COUNT_ROW - 4][6] = AreaUnit(available: false, color: Colors.red);
//    gameArea[COUNT_ROW - 5][6] = AreaUnit(available: false, color: Colors.red);
//    gameArea[COUNT_ROW - 6][6] = AreaUnit(available: false, color: Colors.red);
  }

  Block createBlock() {
    return BlockProvider.randomBlock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: colorBackgroundApp,
          child: Column(children: <Widget>[
            buildMenu(),
            buildGameAreaContainer(),
            buildTabController()
          ])),
    );
  }

  Container buildTabController() {
    return Container(
        decoration: BoxDecoration(
            color: colorBorderGameArea,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        margin: EdgeInsets.only(left: 32, right: 32, bottom: 16),
        padding: EdgeInsets.all(6),
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          buildButtonControl(Icons.keyboard_arrow_left, () {
            moveBlockLeft(block);
          }),
          buildButtonControl(Icons.keyboard_arrow_down, () {
            moveBlockToGround(block);
          }),
          buildButtonControl(Icons.keyboard_arrow_right, () {
            moveBlockRight(block);
          }),
        ]));
  }

  Expanded buildGameAreaContainer() {
    return Expanded(
        child: Center(
            child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
          GestureDetector(
              onTap: () {
                rotateBlock(block);
              },
              onVerticalDragEnd: (details) {
                moveBlockToGround(block);
              },
              onHorizontalDragUpdate: (detail) {
                if (!draging) {
                  draging = true;
                  moveBlockHorizontal(detail);
                  Future.delayed(Duration(milliseconds: delayDrag), () {
                    draging = false;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 12, color: colorBorderGameArea),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildGameArea()),
              )),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[500],
                      border: Border.all(width: 12, color: colorBorderGameArea),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Text(
                      "Lines",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6)),
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "$countLine",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                      color: Colors.blue[500],
                      border: Border.all(width: 12, color: colorBorderGameArea),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child:
                      Column(mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                    Text(
                      "Next",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6)),
                        padding: EdgeInsets.all(8),
                        child: Column(children: nextBlockContainer()))
                  ]),
                )
              ])
        ])));
  }

  Expanded buildButtonControl(IconData icon, Function() onTap) {
    return Expanded(
        child: GestureDetector(
            onTap: onTap,
            child: Container(
              child: Icon(icon, size: 36, color: Colors.white),
            )));
  }

  void moveBlockHorizontal(DragUpdateDetails detail) {
    setState(() {
      bool isMove = false;
      if (detail.primaryDelta > 0) {
        // right
        isMove = moveBlockRight(block);
      } else {
        // left
        isMove = moveBlockLeft(block);
      }

      if (isMove) {
        initGameAreaTemp();
        copyBlockToGameAreaTemp(block);
      }
    });
  }

  void moveBlockToGround(Block block) {
    setState(() {
      while (moveBlockDown(block)) {
        initGameAreaTemp();
        copyBlockToGameAreaTemp(block);
      }
      onBlockToGround();
    });
  }

  List<Widget> buildGameArea() {
    List<Widget> list = List();
    for (int i = 0; i < COUNT_ROW; i++) {
      list.add(buildRow(i));
    }
    return list;
  }

  Row buildRow(int row) {
    List<Widget> list = List();
    for (int i = 0; i < COUNT_COL; i++) {
      list.add(buildAreaUnit(row, i));
    }
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: list);
  }

  Widget buildAreaUnit(int row, int col) {
    AreaUnit areaUnit = gameArea[row][col];
    AreaUnit areaUnitTemp = gameAreaTemp[row][col];

    if (areaUnit.available) {
      if (areaUnitTemp.available) {
        return buildAreaUnitView(SIZE_AREA_UNIT, colorBackgroundGameArea);
      } else {
        return buildAreaUnitView(SIZE_AREA_UNIT, areaUnitTemp.color);
      }
    } else {
      return buildAreaUnitView(SIZE_AREA_UNIT, areaUnit.color);
    }
  }

  Container buildAreaUnitView(double size, Color color) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: color,
            border: Border.all(width: 1, color: colorBorderAreaUnit)));
  }

  bool isBlockCrashOnGround(Block block) {
    for (Coordinate c in block.currentCoordinatesOnGameArea) {
      if (c.row + 1 < COUNT_ROW) {
        if (!gameArea[c.row + 1][c.col].available) {
          return true;
        }
      } else {
        return true;
      }
    }

    return false;
  }

  void rotateBlock(Block block) {
    setState(() {
      block.rotate();
      initGameAreaTemp();
      copyBlockToGameAreaTemp(block);
    });
  }

  Container buildMenu() {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 6, right: 16, left: 16),
      color: Colors.blue[500],
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("TERTIS",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            Expanded(child: Container()),
            FlatButton(
              color: Colors.white,
              child: Text("New Game",
                  style: TextStyle(color: Colors.blue[500], fontSize: 18)),
              onPressed: () {
                restart();
              },
            )
          ]),
    );
  }

  List<Widget> nextBlockContainer() {
    List<Widget> listRow = List();
    for (int row = 0; row < 4; row++) {
      List<Widget> listCol = List();
      for (int col = 0; col < 4; col++) {
        listCol.add(buildAreaUnitNextBlock(row, col));
      }
      listRow.add(Row(children: listCol));
    }
    return listRow;
  }

  Widget buildAreaUnitNextBlock(int row, int col) {
    AreaUnit areaUnit = gameAreaNextBlock[row][col];

    if (areaUnit.available) {
      return buildAreaUnitView(
          SIZE_AREA_UNIT_NEXT_BLOCK, colorBackgroundGameArea);
    } else {
      return buildAreaUnitView(SIZE_AREA_UNIT_NEXT_BLOCK, areaUnit.color);
    }
  }

  void restart(){
    setState(() {
      gameRunning = true;
      initGameArea();
      initGameAreaTemp();
      initGameAreaNextBlock();
      block = createBlock();
      blockNext = createBlock();
      countLine = 0;
    });
  }

  void showGameOverDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text("Game Over ):",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.pink[800],
                      fontWeight: FontWeight.bold)),
              RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                color: Colors.blue[500],
                child: Text("Play again",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                  restart();
                },
              )
            ]));
      },
    );
  }

}
