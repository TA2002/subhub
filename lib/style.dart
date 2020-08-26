import 'package:flutter/material.dart';
import 'size_config.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const myOrangeColor = const Color(0xFFED3731);

  static const Color appBackgroundColor = Color(0xFFFFF7EC);
  static const Color topBarBackgroundColor = Color(0xFFFFD974);
  static const Color selectedTabBackgroundColor = Color(0xFFFFC442);
  static const Color unSelectedTabBackgroundColor = Color(0xFFFFFFFC);
  static const Color subTitleTextColor = Color(0xFF9F988F);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    textTheme: darkTextTheme,
  );

  static final TextTheme lightTextTheme = TextTheme(
    title: _titleLight,
    subtitle: _subTitleLight,
    button: _buttonLight,
    display1: _greetingLight,
    display2: _searchLight,
    body1: _selectedTabLight,
    body2: _unSelectedTabLight,
  );

  static final TextTheme darkTextTheme = TextTheme(
    title: _titleDark,
    subtitle: _subTitleDark,
    button: _buttonDark,
    display1: _greetingDark,
    display2: _searchDark,
    body1: _selectedTabDark,
    body2: _unSelectedTabDark,
  );

  static final TextStyle _titleLight = TextStyle(
    color: Colors.black,
    fontSize: 3.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle _subTitleLight = TextStyle(
    color: subTitleTextColor,
    fontSize: 2 * SizeConfig.textMultiplier,
    height: 1.5,
  );

  static final TextStyle _buttonLight = TextStyle(
    color: Colors.black,
    fontSize: 2.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle _greetingLight = TextStyle(
    color: Colors.black,
    fontSize: 2.0 * SizeConfig.textMultiplier,
  );

  static final TextStyle _searchLight = TextStyle(
    color: Colors.black,
    fontSize: 2.3 * SizeConfig.textMultiplier,
  );

  static final TextStyle _selectedTabLight = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle _unSelectedTabLight = TextStyle(
    color: Colors.grey,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle feedTabbar = GoogleFonts.notoSans(
      fontSize: 1.8 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.bold,
      color: Colors.deepOrange
  );

  static final TextStyle horizontalListView = GoogleFonts.notoSans(
      fontSize: 1.6 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.w800,
      color: Colors.white
  );
  static final TextStyle bottomNavigationBar = GoogleFonts.notoSans(
      //color: Colors.deepOrange,
    color: Colors.deepOrange,
      fontWeight: FontWeight.w700,
  );
  static final TextStyle tabBar = GoogleFonts.notoSans(
    fontWeight: FontWeight.w800,
    color: myOrangeColor
  );

  static final TextStyle dropdownMenu = GoogleFonts.notoSans(
      fontWeight: FontWeight.w800,
      color: myOrangeColor,
    //brightness: Brightness.dark
  );

  static final TextStyle settingsLight = GoogleFonts.notoSans(
    color: Colors.black
  );

  static final TextStyle settingsDark = GoogleFonts.notoSans(
    color: Colors.white.withOpacity(0.9)
  );


  static final TextStyle subtitleTile = GoogleFonts.notoSans(
    fontWeight: FontWeight.w600,
  );

  static final TextStyle appBar = GoogleFonts.notoSans(
      //fontSize: 1.6 * SizeConfig.textMultiplier,
      fontWeight: FontWeight.w700,
      color: Colors.deepOrange
  );

  static final TextStyle videoTitleLight = GoogleFonts.notoSans(
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontSize: 1.7 * SizeConfig.textMultiplier,
  );

  static final TextStyle videoInfoLight = GoogleFonts.notoSans(
    color: Colors.black54,
    fontSize: 1.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle videoTitleDark = GoogleFonts.notoSans(
    color: Colors.white,
    fontWeight: FontWeight.normal,
    fontSize: 1.7 * SizeConfig.textMultiplier,
  );

  static final TextStyle videoInfoDark = GoogleFonts.notoSans(
    color: Colors.white70,
    fontSize: 1.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle suggestions = GoogleFonts.notoSans(
  );



  static final TextStyle _titleDark = _titleLight.copyWith(color: Colors.white);

  static final TextStyle _subTitleDark = _subTitleLight.copyWith(color: Colors.white70);

  static final TextStyle _buttonDark = _buttonLight.copyWith(color: Colors.black);

  static final TextStyle _greetingDark = _greetingLight.copyWith(color: Colors.black);

  static final TextStyle _searchDark = _searchDark.copyWith(color: Colors.black);

  static final TextStyle _selectedTabDark = _selectedTabDark.copyWith(color: Colors.white);

  static final TextStyle _unSelectedTabDark = _selectedTabDark.copyWith(color: Colors.white70);
}