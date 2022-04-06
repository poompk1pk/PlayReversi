import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:playreversi/pages/game.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final logoImage = Image.asset('assets/images/PlayReversiLogo.png', width: 200,);
  final playImage = Image.asset('assets/images/PlayButton.png');
  @override
  void didChangeDependencies() {
    precacheImage(logoImage.image, context);
    precacheImage(playImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green.withBlue(250),
        child: Column(

          children: [
            Expanded(child: Container(
                margin: EdgeInsets.only(top: 50),
                child: logoImage)),
            Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: FlatButton(
              onPressed: (){
                AudioCache audioPlayer = AudioCache();

                var result = audioPlayer.play('sounds/clickplay.wav',volume: 0.5);
                result.then((value) {
                  Future.delayed(const Duration(milliseconds: 20), () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BoardGame()),
                    );
                  });


                });


              },
              padding: EdgeInsets.all(0.0),
              child: Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: playImage)),
            )),

          ],
        )
    );
  }
}
