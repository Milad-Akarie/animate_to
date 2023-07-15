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
      home: const MyHomeScreen(title: 'Animate-to demo'),
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
          // Badge(
          //   label: Text(
          //     "$_itemsCount",
          //     style: const TextStyle(fontSize: 10),
          //   ),
          //   largeSize: 14,
          //   alignment: AlignmentDirectional.bottomStart,
          //   child: AnimateTo<int>(
          //     controller: _animateToController,
          //     animationDuration: const Duration(milliseconds: 400),
          //     animateFromAnimationDuration: const Duration(milliseconds: 1000),
          //     onArrival: (value) {
          //       setState(() {
          //         _itemsCount++;
          //       });
          //     },
          //     builder: (context, child, animation) {
          //       return Transform.translate(
          //         offset: Offset(sin(animation.value * 3 * pi) * 3, 0),
          //         child: child,
          //       );
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.all(6.0),
          //       child: Icon(
          //         Icons.shopping_bag,
          //         color: Theme.of(context).primaryColor,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      body: SizedBox(
        height: 600,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimateTo(
                      controller: _animateToController,
                      child: const Text('Target'),
                    ),
                    const SizedBox(height: 160),
                    AnimateFrom(
                      key: _animateToController.tag('Animatable'),
                      child: const Text('Animatable'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Text('Animate'),
                      onPressed: () {
                        _animateToController.animateTag('Animatable');
                      },
                    ),



                    if (false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int i = 0; i < 3; i++)
                            AnimateFrom<Color>(
                              value: [Colors.red, Colors.green, Colors.orange][i],
                              key: _animateToController.tag(i),
                              builder: (context, child, animation) {
                                return Opacity(
                                  opacity: .8,
                                  child: ScaleTransition(
                                    scale: _circleAnimationSequence.animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: InkWell(
                                onTap: () {
                                  _animateToController.animateTag(i);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: [Colors.red, Colors.green, Colors.orange][i],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            // if (false)
            //   ListView.builder(
            //     itemCount: 20,
            //     itemBuilder: (context, index) {
            //       return Card(
            //         child: ListTile(
            //           title: Text("Item $index"),
            //           subtitle: Text("Subtitle $index"),
            //           leading: AnimateFrom<int>(
            //               value: index,
            //               key: _animateToController.tag(index),
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(8),
            //                 child: Image.network(
            //                   'https://picsum.photos/100/100?random=$index',
            //                 ),
            //               ),
            //               builder: (_, child, animation) {
            //                 return Opacity(
            //                   opacity: .7,
            //                   child: Transform.translate(
            //                     offset: animation.evaluate(begin: Offset.zero, end: const Offset(-10, -10)),
            //                     child: ScaleTransition(
            //                       alignment: Alignment.center,
            //                       scale: animation
            //                           .sequence<double>()
            //                           .add(begin: 1, end: 2, weight: 50)
            //                           .add(begin: 2, end: .3, weight: 50)
            //                           .animate(),
            //                       child: ClipRRect(
            //                         borderRadius: BorderRadiusTween(
            //                           begin: BorderRadius.circular(8),
            //                           end: BorderRadius.circular(50),
            //                         ).evaluate(animation),
            //                         child: child,
            //                       ),
            //                     ),
            //                   ),
            //                 );
            //               }),
            //           trailing: IconButton(
            //             icon: const Icon(
            //               Icons.add_shopping_cart_outlined,
            //             ),
            //             onPressed: () {
            //               _animateToController.animateTag(index);
            //             },
            //           ),
            //         ),
            //       );
            //     },
            //   ),
          ],
        ),
      ),
    );
  }
}
