import 'dart:async';
import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';

/// A controller for the [AnimateTo] widget.
/// it triggers the animation from the [AnimateFrom] widget.
///
/// it can be used to generate and hold [GlobalKey]s for the [AnimateFrom] widget.
class AnimateToController {
  final _streamController = StreamController<AnimateToInput>();
  final _generatedKeys = <Object, GlobalKey<AnimateFromState>>{};

  /// Creates a new [GlobalKey] from the given tag or returns the existing one
  GlobalKey<AnimateFromState> tag(Object tag) {
    return _generatedKeys[tag] ??= GlobalKey<AnimateFromState>();
  }

  /// Triggers the animation from the [AnimateFrom] widget by key.
  void animate(
    GlobalKey<AnimateFromState> key, {
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.easeInOut,
  }) {
    _streamController.add(AnimateToInput(
      key: key,
      duration: duration,
      curve: curve,
    ));
  }

  /// Triggers the animation from the [AnimateFrom] widget by tag.
  void animateTag(
    Object targetTag, {
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.easeInOut,
  }) {
    final key = _generatedKeys[targetTag];
    if (key == null) {
      throw FlutterError('No key found for the tag: $targetTag');
    }
    animate(key, duration: duration, curve: curve);
  }

  StreamSubscription? _subscription;

  AnimateToState? _debugOwner;

  /// creates a disposable listener for [stream].
  void listen(AnimateToState owner, ValueChanged<AnimateToInput> callback) {
    assert(
      _debugOwner == null || _debugOwner == owner,
      'AnimateToController can be used by only one AnimateTo widget.',
    );
    _debugOwner = owner;
    _subscription = _streamController.stream.listen((event) {
      callback(event);
    });
  }

  /// disposes the stream controller.
  void dispose() {
    _subscription?.cancel();
    _streamController.close();
  }
}

/// The input for the [AnimateToController.animate] method.
class AnimateToInput {
  /// The key of the [AnimateFrom] widget.
  final GlobalKey<AnimateFromState> key;

  /// The duration of the animation.
  final Duration duration;

  /// The curve of the animation.
  final Curve curve;

  /// Creates an [AnimateToInput] with the given parameters.
  const AnimateToInput({
    required this.key,
    required this.duration,
    required this.curve,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimateToInput &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          duration == other.duration &&
          curve == other.curve;

  @override
  int get hashCode => key.hashCode ^ duration.hashCode ^ curve.hashCode;
}
