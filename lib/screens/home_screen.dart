import 'package:flutter/material.dart';
import 'package:radio_app/apis/radio_api.dart';
import 'package:radio_app/widgets/gradiant_background.dart';
import 'package:radio_app/widgets/radio_player.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradiantBackground(
        child: FutureBuilder(
          future: RadioApi.initPlayer(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ),
              );
            }
            return const RadioPlayer();
          },
        ),
      ),
    );
  }
}
