import 'dart:async';
import 'package:flutter/material.dart';
import 'animatable.dart';

class AnimateToController {
  final _animationsController = StreamController<GlobalKey<AnimatableState>>();
  final _generatedKeys = <Object, GlobalKey<AnimatableState>>{};

  GlobalKey<AnimatableState> tag(Object key) {
    return _generatedKeys[key] ??= GlobalKey<AnimatableState>();
  }

  void animate(GlobalKey<AnimatableState> tag) {
    _animationsController.add(tag);
  }

  void animateTag(Object targetTag) {
    _animationsController.add(tag(targetTag));
  }

  Stream<GlobalKey<AnimatableState>> get stream => _animationsController.stream;

  void dispose() {
    _animationsController.close();
  }
}