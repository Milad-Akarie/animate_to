import 'package:animate_to/src/animate_to_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// a signature for the animation builder.
typedef AnimationBuilder = Widget Function(
  BuildContext context,
  Widget child,
  Animation<double> animation,
);

/// The target widget to be animated to.
class AnimateTo<T> extends StatefulWidget {
  /// default constructor
   AnimateTo({
     Key? key,
    required this.child,
    required this.controller,
    this.arrivalAnimationDuration = const Duration(milliseconds: 300),
    this.arrivalAnimationCurve = Curves.easeInOut,
    this.builder = _defaultBuilder,
    this.onArrival,
    this.useRootOverlay = true,
  }):super(key: key ?? GlobalObjectKey(controller));

  /// The widget to be animated to
  final Widget child;

  /// The animation trigger controller
  final AnimateToController controller;

  /// When the animation is triggered, the [AnimateTo] widget will animate on
  /// the end of animated widget's animation. This is the duration of that animation.
  final Duration arrivalAnimationDuration;

  /// When the animation is triggered, the [AnimateTo] widget will animate on
  /// the end of animated widget's animation. This is the curve of that animation.
  final Curve arrivalAnimationCurve;

  /// The animation builder
  final AnimationBuilder builder;

  /// A callback that's called when the animated widget's animation
  /// is done.
  final ValueChanged<T>? onArrival;

  /// Whether to use the root overlay or the local overlay.
  final bool useRootOverlay;

  static Widget _defaultBuilder(
    BuildContext context,
    Widget child,
    Animation<double> animation,
  ) {
    return child;
  }

  @override
  State<AnimateTo> createState() => AnimateToState<T>();
}

/// The state of the [AnimateTo] widget.
class AnimateToState<T> extends State<AnimateTo<T>> with TickerProviderStateMixin {
  AnimateToController get _controller => widget.controller;
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
    _controller.listen(this, (input) {
      if (!mounted) return;
      _animateOverlaid(input);
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
          child: animatableState.buildAnimated(context, curvedAnimation),
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
    _targetAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _targetAnimation,
      builder: (context, _) {
        return widget.builder(
          context,
          widget.child,
          _targetAnimation,
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AnimateToController>('controller', _controller));
    properties.add(DiagnosticsProperty<Duration>('arrivalAnimationDuration', widget.arrivalAnimationDuration));
    properties.add(DiagnosticsProperty<Curve>('arrivalAnimationCurve', widget.arrivalAnimationCurve));
    properties.add(DiagnosticsProperty<AnimationBuilder>('builder', widget.builder));
    properties.add(DiagnosticsProperty<bool>('useRootOverlay', widget.useRootOverlay));
  }
}
