import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random number',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Random JK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _num = 0;
  int min = 0;
  int max = 10;
  var random = new Random();
  void changes() async {
    final sp = await SharedPreferences.getInstance();
    min = sp.getInt('min') ?? 0;
    max = (sp.getInt('max') - sp.getInt('min')) ?? 10;
  }

  void _incrementCounter() {
    setState(() {
      changes();
      _num = random.nextInt(max) + min;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.menu),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Setting()),
            );
          },
        ),
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: '$_num',
                  style: TextStyle(color: Colors.white, fontSize: 70.0),
                ),
              ),
//              RichText(
//                text: TextSpan(text: 'min is $_min'),
//              ),
            ],
          ),
          onTap: _incrementCounter,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'get random',
        child: Icon(Icons.cached),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// ignore: must_be_immutable
class Setting extends StatelessWidget {
  final form_key = GlobalKey<FormState>();
  int mi, mx;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Form(
        key: form_key,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                style: TextStyle(color: Colors.white, fontSize: 25.0),
                decoration: const InputDecoration(
                  labelText: 'Min:',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  contentPadding: EdgeInsets.symmetric(
//                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(),
                onChanged: (value) => mi = int.parse(value),
              ),
              TextFormField(
                style: TextStyle(color: Colors.white, fontSize: 25.0),
                decoration: const InputDecoration(
                  labelText: 'Max:',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  contentPadding: EdgeInsets.symmetric(
//                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(),
                onChanged: (value) => mx = int.parse(value),
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                onPressed: () async {
                  final sp = await SharedPreferences.getInstance();
                  sp.setInt('min', mi);
                  sp.setInt('max', mx);
                  Navigator.pop(context);
                },
                child: Text('Set'),
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
