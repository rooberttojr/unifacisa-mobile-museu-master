import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:device_id/device_id.dart';


import 'signup.dart';
import 'artes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
    
      debugShowCheckedModeBanner: false,
      title: 'Inova Museu',
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/login' : (BuildContext context) => new Galeria()
      },
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _info = "";

  Future<void> initDeviceId() async {
    String deviceid = await DeviceId.getID;
    print(deviceid);
    setState(() {
      _info = deviceid;
    });
  }

  Dio _dio;

  @override
  void initState() {
    super.initState();
    initDeviceId();

    BaseOptions options = new BaseOptions(
      baseUrl: 'http://192.168.15.15:3000',
      connectTimeout: 5000,
    );

    _dio = new Dio(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fotoMuseu.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child:
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 32, right: 32, bottom: 32),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Inova',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold
                          )
                        ),
                    ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                    child: Text('Museu',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold
                          )
                        ),
                     ),
                  ],
                )
              ),
            SizedBox(height: 50.0),
            Center(
              child:
              Container(
                margin: EdgeInsets.only(bottom: 8),
                height: 70,
                width: 370,
                child: RaisedButton(
              onPressed: () {
                login();
              },
              child: Text('Visite o Museu!',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                ),
              ),
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
              )
              
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Faça seu',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text(
                    'Cadastro',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline
                    ),
                  ),
                )
              ],
            ),
          ],
        )
        )
        
      );
  
  }
  

  void login() async {
    try {
      await _dio.post("/guestsessions", data: {"guest_id" : _info});
      Navigator.of(context).pushNamed('/login');

    } catch (err) {
      print(err);
      Navigator.of(context).pushNamed('/signup');
    }
  }
}