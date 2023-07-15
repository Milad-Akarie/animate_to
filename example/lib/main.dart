import 'dart:math';

import 'package:animate_to/animate_to.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomeScreen(title: 'Animate-to'),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key, required this.title});

  final String title;

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final _animateToController = AnimateToController();

  final _circleAnimationSequence = TweenSequence<double>([
    TweenSequenceItem<double>(
      tween: Tween(begin: 1, end: 3),
      weight: 40,
    ),
    TweenSequenceItem<double>(
      tween: Tween(begin: 3, end: .2),
      weight: 40,
    ),
    TweenSequenceItem<double>(
      tween: Tween(begin: .2, end: 1),
      weight: 20,
    ),
  ]);

  static final _scaleTransactionSequence = TweenSequence<double>([
    TweenSequenceItem<double>(
      tween: Tween(begin: 1, end: 3),
      weight: 50,
    ),
    TweenSequenceItem<double>(
      tween: Tween(begin: 3, end: .2),
      weight: 50,
    ),
  ]);

  @override
  void dispose() {
    _animateToController.dispose();
    super.dispose();
  }

  int _itemsCount = 0;
  Color targetColor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (false)
            Badge(
              label: Text(
                "$_itemsCount",
                style: const TextStyle(fontSize: 10),
              ),
              largeSize: 14,
              isLabelVisible: _itemsCount > 0,
              alignment: AlignmentDirectional.bottomStart,
              child: AnimateTo<int>(
                controller: _animateToController,
                onArrival: (value) {
                  setState(() {
                    _itemsCount++;
                  });
                },
                builder: (context, child, animation) {
                  return Transform.translate(
                    offset: Offset(sin(animation.value * 3 * pi) * 3, 0),
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.shopping_bag,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          AnimateTo(
            controller: _animateToController,
            child: // cart icon,
            builder: (context, child, animation) {
              return Transform.scale(
                scale: _circleAnimationSequence.animate(animation).value,
                child: child,
              );
            }
          ),
          const SizedBox(height: 100),
          AnimateFrom(
            key: _animateToController.tag('animate1'),
            child: const Text('Animatable'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Animate'),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 320,
                width: 240,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimateTo<Color>(
                      controller: _animateToController,
                      child: Circle(size: 100, color: targetColor),
                      onArrival: (color) {
                        setState(() {
                          targetColor = Color.lerp(targetColor, color, .5)!;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < 3; i++)
                          AnimateFrom<Color>(
                            value: [Colors.red, Colors.green, Colors.orange][i],
                            key: _animateToController.tag(i),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => _animateToController.animateTag(i),
                              child: Circle(
                                size: 50,
                                color: [Colors.red, Colors.green, Colors.orange][i].withOpacity(.85),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (false)
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text("Item $index"),
                      subtitle: Text("Subtitle $index"),
                      leading: AnimateFrom<int>(
                          value: index,
                          key: _animateToController.tag(index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://picsum.photos/100/100?random=$index',
                            ),
                          ),
                          builder: (_, child, animation) {
                            return Opacity(
                              opacity: .85,
                              child: ScaleTransition(
                                scale: _scaleTransactionSequence.animate(animation),
                                child: ClipRRect(
                                  borderRadius: BorderRadiusTween(
                                    begin: BorderRadius.circular(8),
                                    end: BorderRadius.circular(50),
                                  ).evaluate(animation),
                                  child: child,
                                ),
                              ),
                            );
                          }),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.add_shopping_cart_outlined,
                        ),
                        onPressed: () {
                          _animateToController.animateTag(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class Circle extends StatelessWidget {
  const Circle({super.key, required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}


