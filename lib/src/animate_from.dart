import 'package:animate_to/animate_to.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Wraps the widget that's meant to be animated from
/// global position to the position of the [AnimateTo] widget.
class AnimateFrom<T> extends StatefulWidget {
  /// default constructor
  const AnimateFrom({
    required GlobalKey<AnimateFromState> key,
    required this.child,
    this.value,
    this.builder = _defaultBuilder,
  }) : super(key: key);

  /// A value to be passed to the [AnimateTo] widget on arrival.
  final T? value;

  static final _defaultSequence = TweenSequence<double>([
    TweenSequenceItem<double>(
      tween: Tween(begin: 1, end: 3),
      weight: 50,
    ),
    TweenSequenceItem<double>(
      tween: Tween(begin: 3, end: .2),
      weight: 50,
    ),
  ]);

  static Widget _defaultBuilder(
    BuildContext context,
    Widget child,
    Animation<double> animation,
  ) {
    return ScaleTransition(
      scale: _defaultSequence.animate(animation),
      child: child,
    );
  }

  /// The widget to be animated
  final Widget child;

  /// The animation builder
  final AnimationBuilder builder;

  @override
  State<AnimateFrom> createState() => AnimateFromState<T>();
}

/// The state of the [AnimateFrom] widget.
class AnimateFromState<T> extends State<AnimateFrom<T>> {
  @override
  Widget build(BuildContext context) => widget.child;

  /// The value passed to the [AnimateTo] widget on arrival.
  T? get value => widget.value;

  /// The animation builder
  Widget buildAnimated(BuildContext context, Animation<double> animation) {
    return ExcludeFocus(
      child: IgnorePointer(
        child: Material(
          color: Colors.transparent,
          child: widget.builder(context, widget.child, animation),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('value', value));
  }
}
