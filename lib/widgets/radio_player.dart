import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/apis/radio_api.dart';
import 'package:radio_app/providers/radio.provider.dart';
import 'package:radio_app/widgets/radio_list.dart';
import 'package:volume_controller/volume_controller.dart';

class RadioPlayer extends StatefulWidget {
  const RadioPlayer({super.key});

  @override
  State<RadioPlayer> createState() => _RadioPlayerState();
}

class _RadioPlayerState extends State<RadioPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late VolumeController volumeController;
  late Animation<Offset> radioOffSet;
  late Animation<Offset> radioListOffSet;
  bool listEnabled = false;
  bool isPlaying = true;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );

    radioListOffSet = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    radioOffSet = Tween(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    RadioApi.player.stateStream.listen((event) {
      setState(() {
        isPlaying = event;
      });
    });
    volumeController = VolumeController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SlideTransition(
            position: radioOffSet,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.transparent,
                  child: Consumer<RadioProvider>(
                      builder: ((context, value, child) {
                    return Image.network(
                      value.station.photoUrl,
                      fit: BoxFit.cover,
                    );
                  })),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            listEnabled = !listEnabled;
                          });
                          switch (animationController.status) {
                            case AnimationStatus.dismissed:
                              animationController.forward();
                              break;
                            case AnimationStatus.completed:
                              animationController.reverse();
                              break;
                            default:
                          }
                        },
                        iconSize: 30,
                        color: listEnabled ? Colors.amber : Colors.white,
                        icon: const Icon(
                          Icons.list,
                        )),
                    IconButton(
                        onPressed: () async {
                          isPlaying
                              ? RadioApi.player.stop()
                              : RadioApi.player.play();
                        },
                        iconSize: 30,
                        color: Colors.white,
                        icon: Icon(
                          isPlaying ? Icons.stop : Icons.play_arrow,
                        )),
                    IconButton(
                        onPressed: () async {
                          if (isMuted) {
                            volumeController.setVolume(0.5);
                          } else {
                            volumeController.muteVolume();
                          }
                          setState(() {
                            isMuted = !isMuted;
                          });
                        },
                        iconSize: 30,
                        color: Colors.white,
                        icon: Icon(
                          isMuted ? Icons.volume_off : Icons.volume_up,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
        SlideTransition(
          position: radioListOffSet,
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  40,
                ),
              ),
            ),
            child: Column(
              children: const [
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Radio List',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
                Divider(
                  color: Colors.black,
                  indent: 30,
                  endIndent: 30,
                ),
                Expanded(
                  child: RadioList(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
