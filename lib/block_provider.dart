import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tertis_game_flutter/block.dart';
import 'package:tertis_game_flutter/block/block_l.dart';
import 'package:tertis_game_flutter/block/block_l_small.dart';
import 'package:tertis_game_flutter/block/block_o.dart';
import 'package:tertis_game_flutter/block/block_s.dart';
import 'package:tertis_game_flutter/block/block_t.dart';
import 'package:tertis_game_flutter/coordinate.dart';

class BlockProvider {

  static const int COUNT_BLOCK_TYPE = 5;
  static const int BLOCK_S = 0;
  static const int BLOCK_T = 1;
  static const int BLOCK_L = 2;
  static const int BLOCK_O = 3;
  static const int BLOCK_LS = 4;

  static Block randomBlock() {
    Random random = Random();
    int id = random.nextInt(COUNT_BLOCK_TYPE);
    if (id == BLOCK_S) {
      return BlockS.create();
    } else if (id == BLOCK_T) {
      return BlockT.create();
    } else if (id == BLOCK_L) {
      return BlockL.create();
    }else if (id == BLOCK_O) {
      return BlockO.create();
    }else if (id == BLOCK_LS) {
      return BlockLs.create();
    }
    return BlockS.create();
  }

}