import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './Screens/Home/home_screen.dart';
import './constant.dart';
import './helpers/live_update.dart';
import './Screens/welcome/welcome_screen.dart';
import './helpers/http_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<bool> get jwtOrEmpty async {
    var jwt = await storage.read(key: "refreshToken");
    if (jwt == null) return false;
    // print('refresh token from storage is $jwt');
    return HttpService.getAccessToken(jwt);
  }

  Future<void> deleteAll() async {
    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LiveUpdate()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Healthy Being App',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: FutureBuilder(
            future: jwtOrEmpty,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              if (!snapshot.data) {
                return WelcomeScreen();
              } else {
                return HomeScreen();
              }
            }),
      ),
    );
  }
}
