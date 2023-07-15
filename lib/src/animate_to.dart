import 'dart:async';

import 'package:animate_to/src/animate_to_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef AnimationBuilder = Widget Function(
  BuildContext context,
  Widget child,
  Animation<double> animation,
);

class AnimateTo<T> extends StatefulWidget {
  const AnimateTo({
    super.key,
    required this.child,
    required this.controller,
    this.arrivalAnimationDuration = const Duration(milliseconds: 300),
    this.arrivalAnimationCurve = Curves.easeInOut,
    this.builder = _defaultBuilder,
    this.onArrival,
    this.useRootOverlay = true,
  });

  final Widget child;
  final AnimateToController controller;
  final Duration arrivalAnimationDuration;
  final Curve arrivalAnimationCurve;
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
  State<AnimateTo> createState() => _AnimateToState<T>();
}

class _AnimateToState<T> extends State<AnimateTo<T>> with TickerProviderStateMixin {
  AnimateToController get controller => widget.controller;
  StreamSubscription? _streamSubscription;
  late final _targetAnimationController = AnimationController(
    duration: widget.arrivalAnimationDuration,
    vsync: this,
  );

  late final _targetAnimation = CurvedAnimation(
    parent: _targetAnimationController,
    curve: widget.arrivalAnimationCurve,
  );
  @override
  void initState() {
    super.initState();
    _streamSubscription = controller.stream.listen((key) {
      if (!mounted) return;
      _animateOverlaid(key);
    });
  }

  void _animateOverlaid(AnimateToInput input) {
    final animatableState = input.key.currentState;
    final targetBox = context.findRenderObject() as RenderBox?;
    if (animatableState != null && targetBox != null) {
      final animatableBox = animatableState.context.findRenderObject() as RenderBox;
      final targetPosition = targetBox.localToGlobal(Offset.zero).translate(
            (targetBox.size.width / 2) - animatableBox.size.width / 2,
            (targetBox.size.height / 2) - animatableBox.size.height / 2,
          );
      final animatablePosition = animatableBox.localToGlobal(Offset.zero);

      assert(animatableState.mounted);
      final entryAnimationController = AnimationController(
        vsync: this,
        duration: input.duration,
      );
      final entry = OverlayEntry(builder: (_) {
        final curvedAnimation = CurvedAnimation(
          parent: entryAnimationController,
          curve: input.curve,
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
    _streamSubscription?.cancel();
    _targetAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _targetAnimation,
      builder: (context, child) {
        return widget.builder(
          context,
          child!,
          _targetAnimation,
        );
      },
      child: widget.child,
    );
  }


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AnimateToController>('controller', controller));
    properties.add(DiagnosticsProperty<Duration>('arrivalAnimationDuration', widget.arrivalAnimationDuration));
    properties.add(DiagnosticsProperty<Curve>('arrivalAnimationCurve', widget.arrivalAnimationCurve));
    properties.add(DiagnosticsProperty<AnimationBuilder>('builder', widget.builder));
    properties.add(DiagnosticsProperty<bool>('useRootOverlay', widget.useRootOverlay));
  }
}
