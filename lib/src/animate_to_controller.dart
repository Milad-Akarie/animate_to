import 'dart:async';
import 'package:flutter/material.dart';
import 'animate_from.dart';

class AnimateToController {
  final _animationsController = StreamController<AnimateToInput>();
  final _generatedKeys = <Object, GlobalKey<AnimateFromState>>{};

  GlobalKey<AnimateFromState> tag(Object tag) {
    return _generatedKeys[tag] ??= GlobalKey<AnimateFromState>();
  }

  void animate(
    GlobalKey<AnimateFromState> key, {
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.easeInOut,
  }) {
    _animationsController.add(AnimateToInput(
      key: key,
      duration: duration,
      curve: curve,
    ));
  }

  void animateTag(
    Object targetTag, {
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.easeInOut,
  }) {
    _animationsController.add(
      AnimateToInput(
        key: tag(targetTag),
        duration: duration,
        curve: curve,
      ),
    );
  }

  Stream<AnimateToInput> get stream => _animationsController.stream.asBroadcastStream();

  void dispose() {
    _animationsController.close();
  }
}

class AnimateToInput {
  final GlobalKey<AnimateFromState> key;
  final Duration duration;
  final Curve curve;

  const AnimateToInput({
    required this.key,
    required this.duration,
    required this.curve,
  });

  AnimateToInput copyWith({
    GlobalKey<AnimateFromState>? key,
    Duration? duration,
    Curve? curve,
  }) {
    return AnimateToInput(
      key: key ?? this.key,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }


}
