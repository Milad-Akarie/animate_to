
import 'package:animate_to/src/extensions.dart';
import 'package:flutter/material.dart';

class Animatable<T> extends StatefulWidget {
  const Animatable({
    required GlobalKey<AnimatableState> key,
    required this.child,
    this.value,
    this.builder = _defaultBuilder,
  }) : super(key: key);

  final T? value;

  static Widget _defaultBuilder(Widget child, Animation<double> animation) {
    return ScaleTransition(
      scale: animation
          .sequence<double>()
          .add(
        begin: 1,
        end: 3,
        weight: 50,
      )
          .add(
        begin: 3,
        end: .2,
        weight: 50,
      )
          .animate(),
      child: child,
    );
  }

  final Widget child;
  final Widget Function(Widget child, Animation<double> animation) builder;

  @override
  State<Animatable> createState() => AnimatableState<T>();
}

class AnimatableState<T> extends State<Animatable<T>> {
  @override
  Widget build(BuildContext context) => widget.child;

  T? get value => widget.value;

  Widget buildAnimated(Animation<double> animation) {
    return Material(
      color: Colors.transparent,
      child: widget.builder(widget.child, animation),
    );
  }
}