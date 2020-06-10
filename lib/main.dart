import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sides/screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: HomeScreen(),
    theme: ThemeData(
      primarySwatch: Colors.teal,
      textTheme: GoogleFonts.latoTextTheme(),
    ),
  ));
}
