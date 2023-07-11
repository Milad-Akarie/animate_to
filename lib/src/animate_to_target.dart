import 'dart:async';

import 'package:animate_to/src/animatable.dart';
import 'package:animate_to/src/animate_to_controller.dart';
import 'package:flutter/material.dart';

typedef AnimationBuilder = Widget Function(
  BuildContext context,
  Widget child,
  Animation<double> animation,
);

class AnimateToTarget<T> extends StatefulWidget {
  const AnimateToTarget({
    super.key,
    required this.child,
    required this.controller,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animatableAnimationDuration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    this.builder = _defaultBuilder,
    this.onArrival,
    this.useRootOverlay = true,
  });

  final Widget child;
  final AnimateToController controller;
  final Duration animationDuration;
  final Duration animatableAnimationDuration;
  final Curve curve;
  final AnimationBuilder builder;
  final ValueChanged<T>? onArrival;
  final bool useRootOverlay;

  static Widget _defaultBuilder(
    BuildContext context,
    Widget child,
    Animation<double> animation,
  ) {
    return child;
  }

  @override
  State<AnimateToTarget> createState() => _AnimateToTargetState<T>();
}

class _AnimateToTargetState<T> extends State<AnimateToTarget<T>> with TickerProviderStateMixin {
  AnimateToController get controller => widget.controller;
  StreamSubscription? _streamSubscription;
  late final _targetAnimationController = AnimationController(
    duration: widget.animationDuration,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    _streamSubscription = controller.stream.listen((key) {
      if (!mounted) return;
      _animateOverlaid(key);
    });
  }

  void _animateOverlaid(GlobalKey<AnimatableState> key) {
    final animatableState = key.currentState;
    final targetBox = context.findRenderObject() as RenderBox?;
    if (animatableState != null && targetBox != null) {
      final targetPosition = targetBox.localToGlobal(Offset.zero);
      final animatableBox = animatableState.context.findRenderObject() as RenderBox;
      final animatablePosition = animatableBox.localToGlobal(Offset.zero);
      assert(animatableState.mounted);
      final entryAnimationController = AnimationController(
        vsync: this,
        duration: widget.animatableAnimationDuration,
      );
      final entry = OverlayEntry(builder: (_) {
        final curvedAnimation = CurvedAnimation(
          parent: entryAnimationController,
          curve: widget.curve,
        );
        final posAnimation = Tween(
          begin: animatablePosition,
          end: targetPosition,
        ).evaluate(curvedAnimation);
        return Positioned(
          left: posAnimation.dx,
          top: posAnimation.dy,
          width: animatableBox.size.width,
          height: animatableBox.size.height,
          child: animatableState.buildAnimated(curvedAnimation),
        );
      });

      Overlay.of(
        context,
        rootOverlay: widget.useRootOverlay,
      ).insert(entry);

      void dispose() {
        entryAnimationController.dispose();
        entryAnimationController.removeListener(entry.markNeedsBuild);
        entry.remove();
      }

      entryAnimationController.addListener(entry.markNeedsBuild);

      entryAnimationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onArrival?.call(animatableState.value as T);
          _targetAnimationController.forward(from: 0);
          dispose();
        }
      });
      entryAnimationController.forward().orCancel.catchError((_) => dispose());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
    _targetAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _targetAnimationController,
      builder: (context, child) {
        return widget.builder(
          context,
          child!,
          _targetAnimationController,
        );
      },
      child: widget.child,
    );
  }
}
