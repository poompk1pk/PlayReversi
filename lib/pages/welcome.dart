import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:playreversi/pages/home.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  final logo = Image.asset('assets/images/PlayReversiLogo.png');

  @override
  void didChangeDependencies() {
    precacheImage(logo.image, context);
    super.didChangeDependencies();
  }
  @override
  void initState() {



    super.initState();
    AudioCache audioPlayer = AudioCache();

    var result = audioPlayer.play('sounds/welcome.wav',volume: 0.5);
    result.then((value) {
      Future.delayed(const Duration(milliseconds: 6000), () {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
    });


      });

  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.green.withBlue(250),
      child:
        Align(
          alignment: Alignment.center,
          child: FadeTransition(
              opacity: _animation,
              child: Container(
                  margin: EdgeInsets.all(50),
                  child: logo)
          ),
        )
    );
  }
}
