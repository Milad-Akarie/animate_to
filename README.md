
<p align="center">                    
<a href="https://img.shields.io/badge/License-MIT-green"><img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License"></a>                    
<a href="https://github.com/Milad-Akarie/animate_to/stargazers"><img src="https://img.shields.io/github/stars/Milad-Akarie/animate_to?style=flat&logo=github&colorB=green&label=stars" alt="stars"></a>                    
<a href="https://pub.dev/packages/animate_to"><img src="https://img.shields.io/pub/v/animate_to.svg?label=pub&color=orange" alt="pub version"></a>                    
</p>                    

<p align="center">                  
<a href="https://www.buymeacoffee.com/miladakarie" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="30px" width= "108px"></a>                  
</p>                  
---

## Basic usage
1- Create an `AnimateToController`
```dart
final _animateToController = AnimateToController();
 ``` 
2- Wrap the target widget ( the one to animate to) with an `AnimateTo` widget and pass it the controller
```dart
AnimateTo(
    controller: _animateToController,
    child: const Text('Target'),
 ),
```
3- Wrap the widgets you wish to animate with `AnimateFrom` widget.
The `AnimateFrom` widget requires a global key which you can create an pass the normal way or have the `AnimateToController` generate it for you from a given tag.
 ```dart
 AnimateFrom(
    key: _animateToController.tag('animate1'), // regularGlobalKey
    child: const Text('Animatable'),
  ),
```
now trigger the animation by calling
  ```dart
 _animateToController.animateTag('animate1');
  // or by key 
 _animateToController.animate(regularGlobalKey);
  ```
#### complete code
 ```dart
Scaffold(
  body: SizedBox(
    height: 300,
    child: Column(
      children: [
        AnimateTo(
          controller: _animateToController,
          child: const Text('Target'),
        ),
        const SizedBox(height: 100),
        AnimateFrom(
          key: _animateToController.tag('animate1'),
          child: const Text('Animatable'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            _animateToController.animateTag('animate1');
          },
          child: const Text('Animate'),
        ),
      ],
    ),
  ),
)
```

#### Result
![](https://github.com/Milad-Akarie/animate_to/blob/main/art/demo_1.gif?raw=true)

### Animating The target widget (the child of AnimateTo)
AnimateTo provides a builder property to animate it's child on new arrivals (On Single animation completion)
 ```dart
AnimateTo(
    controller: _animateToController,
    child: MyCartIcon(),
    builder: (context, child, animation) {
      return Transform.translate(
        offset: Offset(sin(animation.value * 3 * pi) * 3, 0),
        child: child,
      );
    }
),
 ```
![](https://github.com/Milad-Akarie/animate_to/blob/main/art/demo_2.gif?raw=true)

### Transporting data along with the animation
It's possible to have `AnimateFrom` widget carry data to the target widget by assigning the data you need to transport to the `AnimateFrom.value` property and receive it inside `AnimateTo.onArrival` callback
 ```dart
SizedBox(
    height: 320,
    width: 240,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimateTo<Color>(
          controller: _animateToController,
          child: Circle(size: 100, color: targetColor),
          onArrival: (color) { // called on animation complete
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
               /// whatever is passed here is received inside of `AnimateTo.onArrival`
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
  )
 ```
![](https://github.com/Milad-Akarie/animate_to/blob/main/art/demo_3.gif?raw=true)

### Support animate_to

You can support animate_to by liking it on Pub and staring it on Github, sharing ideas on how we
can enhance a certain functionality or by reporting any problems you encounter and of course buying
a couple coffees will help speed up the development process.