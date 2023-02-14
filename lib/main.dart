import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/apis/shared_prefs_api.dart';
import 'package:radio_app/models/radio_station.dart';
import 'package:radio_app/providers/radio.provider.dart';
import 'package:radio_app/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final radioStation = await SharedPrefApi.getInitialRadioStation();
  runApp(MyApp(
    initialStation: radioStation,
  ));
}

class MyApp extends StatelessWidget {
  final RadioStation initialStation;
  const MyApp({required this.initialStation, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: ((context) => RadioProvider(initialStation)))
      ],
      child: MaterialApp(
        title: 'RadioApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
