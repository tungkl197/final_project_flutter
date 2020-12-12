import 'package:final_project_flutter/ncovid_info/ncovid_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 10,
      navigateAfterSeconds: new AfterSplash(),
      title: new Text('Đeo khẩu trang thường xuyên và đúng cách \n Để phòng, chống dịch Covid-19 có hiệu quả',
      style: new TextStyle(
        fontFamily: "Poppins",
        fontSize: 14.2
      ),),
      image: Image.asset(
        'assets/images/splash_banner.png',
      ),
      photoSize: 200.0,
      backgroundColor: Colors.white,
      loaderColor: Colors.blueAccent,
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: Colors.white),
          )),
      home: NcovidInfoWidget(),
    );
  }
}
