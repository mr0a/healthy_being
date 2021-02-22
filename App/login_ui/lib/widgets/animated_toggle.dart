import 'package:flutter/material.dart';

class AnimatedLiveTracker extends StatefulWidget {
  final Function onClickHandler;

  const AnimatedLiveTracker(this.onClickHandler);

  @override
  _AnimatedLiveTrackerState createState() => _AnimatedLiveTrackerState();
}

class _AnimatedLiveTrackerState extends State<AnimatedLiveTracker> {
  bool toggleValue = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 30.0,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: toggleValue
            ? Colors.greenAccent[100]
            : Colors.redAccent[100].withOpacity(0.5),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            top: 2.5,
            left: toggleValue ? 30.0 : 0.0,
            right: toggleValue ? 0.0 : 30.0,
            child: InkWell(
              onTap: toggleButton,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    child: child,
                    scale: animation,
                  );
                },
                child: toggleValue
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 25.0,
                        key: UniqueKey(),
                      )
                    : Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                        size: 25.0,
                        key: UniqueKey(),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  toggleButton() {
    setState(() {
      widget.onClickHandler(context);
      toggleValue = !toggleValue;
    });
  }
}
