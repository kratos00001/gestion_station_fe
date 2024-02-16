import 'package:flutter/material.dart';
import 'views/stations_list_view.dart'; // Import the stations list view
import 'views/map_view.dart'; // Import the map view

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Station Finder',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange, // Updated primary swatch color
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.deepOrangeAccent, // Custom button color
        ),
        textTheme: TextTheme(
          headline6: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          button: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Station Finder'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Optional: Add a logo or branding element here
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Welcome to Station Finder',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StationsListView()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: theme.primaryColor, // Button color
                onPrimary: Colors.white, // Text color
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('View Stations List'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapView()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: theme.primaryColor, // Button color
                onPrimary: Colors.white, // Text color
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('View Stations on Map'),
            ),
          ],
        ),
      ),
    );
  }
}
