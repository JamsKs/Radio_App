import 'package:radio_app/models/radio_station.dart';
import 'package:radio_app/utils/radio_stations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefApi {
  static const _key = 'radio-station';
  static Future<RadioStation> getInitialRadioStation() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final stationName = sharedPrefs.getString(_key);

    if (stationName == null) return RadioStations.allStations[0];
    return RadioStations.allStations
        .firstWhere((element) => element.name == stationName);
  }

  static Future<void> setRadioStation(RadioStation station) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(_key, station.name);
  }
}
