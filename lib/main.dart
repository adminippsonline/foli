import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:ippsonline/pages/HomePage.dart';
import 'package:ippsonline/pages/LoadingHomePage.dart';
import 'package:ippsonline/pages/LoginPage.dart';
import 'package:ippsonline/pages/WebviewUser.dart';
import 'package:ippsonline/providers/session.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
  try {
    await FlutterDisplayMode.setHighRefreshRate();
  }catch(_){}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Session()),
      ],
      child: MaterialApp(
        title: 'Foli',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0XFFF25058)),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data?.getBool('isRepartidor') == null){
              return LoginPage();
            }else{
             if(snapshot.data?.getBool('isRepartidor') == true){

               return LoadingHomePage(snapshot.data!.getString('email').toString(), snapshot.data!.getString('pass').toString());
             }else{
               return WebviewUser(correo: snapshot.data!.getString('email').toString(), pass: snapshot.data!.getString('pass').toString());
             }
            }

          }else if(snapshot.hasError){
             return const Center(child: Text("Error"));
          }else{
             return const Splash();
          }
        });
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive(),),
    );
  }
}

