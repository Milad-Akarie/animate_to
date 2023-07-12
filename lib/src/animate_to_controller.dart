import 'dart:async';
import 'package:flutter/material.dart';
import 'animate_from.dart';

class AnimateToController {
  final _animationsController = StreamController<GlobalKey<AnimateFromState>>();
  final _generatedKeys = <Object, GlobalKey<AnimateFromState>>{};

  GlobalKey<AnimateFromState> tag(Object key) {
    return _generatedKeys[key] ??= GlobalKey<AnimateFromState>();
  }

  void animate(GlobalKey<AnimateFromState> tag) {
    _animationsController.add(tag);
  }

  void animateTag(Object targetTag) {
    _animationsController.add(tag(targetTag));
  }

  Stream<GlobalKey<AnimateFromState>> get stream => _animationsController.stream.asBroadcastStream();

  void dispose() {
    _animationsController.close();
  }
}