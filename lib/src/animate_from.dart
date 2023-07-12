import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';

class AnimateFrom<T> extends StatefulWidget {
  const AnimateFrom({
    required GlobalKey<AnimateFromState> key,
    required this.child,
    this.value,
    this.builder = _defaultBuilder,
  }) : super(key: key);

  final T? value;

  static Widget _defaultBuilder(BuildContext context, Widget child, Animation<double> animation) {
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
  final AnimationBuilder builder;

  @override
  State<AnimateFrom> createState() => AnimateFromState<T>();
}

class AnimateFromState<T> extends State<AnimateFrom<T>> {
  @override
  Widget build(BuildContext context) => widget.child;

  T? get value => widget.value;

  Widget buildAnimated(Animation<double> animation) {
    return ExcludeFocus(
      child: IgnorePointer(
        child: Material(
          color: Colors.transparent,
          child: widget.builder(context, widget.child, animation),
        ),
      ),
    );
  }
}
