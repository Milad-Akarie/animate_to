import 'package:flutter/material.dart';

extension AnimationX on Animation<double> {
  Animation<T> animate<T>({
    required T begin,
    required T end,
    double intervalBegin = 0.0,
    double intervalEnd = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return animateTween<T>(
      tween: Tween<T>(begin: begin, end: end),
      intervalBegin: intervalBegin,
      intervalEnd: intervalEnd,
      curve: curve,
    );
  }

  Animation<T> animateTween<T>({
    required Tween<T> tween,
    double intervalBegin = 0.0,
    double intervalEnd = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return tween.animate(
      CurvedAnimation(
        parent: this,
        curve: Interval(
          intervalBegin,
          intervalEnd,
          curve: curve,
        ),
      ),
    );
  }

  /// adds a sequence to the builder
  TweenSequenceBuilder<T> sequence<T>() {
    return TweenSequenceBuilder<T>(this);
  }

  T evaluate<T>({
    required T begin,
    required T end,
    double intervalBegin = 0.0,
    double intervalEnd = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return evaluateTween<T>(
      tween: Tween<T>(begin: begin, end: end),
      intervalBegin: intervalBegin,
      intervalEnd: intervalEnd,
      curve: curve,
    );
  }

  T evaluateTween<T>({
    required Tween<T> tween,
    double intervalBegin = 0.0,
    double intervalEnd = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return tween.evaluate(
      CurvedAnimation(
        parent: this,
        curve: Interval(
          intervalBegin,
          intervalEnd,
          curve: curve,
        ),
      ),
    );
  }
}

class TweenSequenceBuilder<T> {
  final Animation<double> animation;
  final List<TweenSequenceItem<T>> items = [];

  TweenSequenceBuilder(this.animation);

  TweenSequenceBuilder<T> addTween({
    required Tween<T> tween,
    required double weight,
  }) {
    items.add(TweenSequenceItem<T>(tween: tween, weight: weight));
    return this;
  }

  /// adds a sequence to the builder
  TweenSequenceBuilder<T> add({
    required T begin,
    required T end,
    required double weight,
  }) {
    return addTween(
      tween: Tween<T>(begin: begin, end: end),
      weight: weight,
    );
  }

  /// reverses last sequences if exists
  TweenSequenceBuilder<T> reverse() {
    if (items.isNotEmpty) {
      final last = items.last;
      assert(last.tween is Tween<T>);
      final Tween<T> l = last.tween as Tween<T>;
      return addTween(
        tween: Tween<T>(begin: l.end, end: l.begin),
        weight: last.weight,
      );
    }
    return this;
  }

  /// builds and animates the sequence
  Animation<T> animate() {
    return TweenSequence<T>(items).animate(animation);
  }
}
