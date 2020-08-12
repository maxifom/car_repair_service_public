import 'package:car_repair_service/pages/bonus.dart';
import 'package:car_repair_service/pages/change_password.dart';
import 'package:car_repair_service/pages/help.dart';
import 'package:car_repair_service/pages/history.dart';
import 'package:car_repair_service/pages/info.dart';
import 'package:car_repair_service/pages/loader.dart';
import 'package:car_repair_service/pages/login.dart';
import 'package:car_repair_service/pages/menu.dart';
import 'package:car_repair_service/pages/order.dart';
import 'package:car_repair_service/pages/profile.dart';
import 'package:car_repair_service/pages/sale.dart';
import 'package:car_repair_service/pages/settings.dart';
import 'package:car_repair_service/pages/signup.dart';
import 'package:car_repair_service/state/state.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import 'login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store =
      Store<AppState>(counterReducer, initialState: AppState(new Auth()));
  Intl.defaultLocale = 'ru_RU';
//  initializeDateFormatting(Intl.defaultLocale);
  var user = await store.state.auth.getCurrentUser();
  print(user);
  store.dispatch(ChangeAuthStatus(
      user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN));
  store.dispatch(UpdateUser(user));
  if (user != null) {
    store.state.db
        .child("users/${user.uid}")
        .once()
        .then((DataSnapshot snapshot) {
      store.dispatch(UpdateUserInfo(UserInfo.fromSnapshot(snapshot)));
    });
  }
  Widget homeRoute = new LoginPage();
  if (store.state.authStatus == AuthStatus.LOGGED_IN) {
    homeRoute = new MenuPage();
  }
  runApp(FlutterReduxApp(
    store: store,
    homeRoute: homeRoute,
  ));
}

class FlutterReduxApp extends StatelessWidget {
  final Store<AppState> store;
  final Widget homeRoute;
  final analytics = FirebaseAnalytics();

  FlutterReduxApp({Key key, this.store, this.homeRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
        theme: ThemeData(
          fontFamily: 'Montserrat',
//          primaryColor: Colors.green.shade600,
          primaryColor: Color(0xFF4797F4),
          secondaryHeaderColor: Color(0xFFE8E8E8),
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w100,
              fontFamily: 'Montserrat',
              fontSize: 24.0,
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Theme.of(context).primaryColor,
          ),
          backgroundColor: Colors.grey.shade200,
        ),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => new LoginPage(),
          '/signup': (BuildContext context) => new SignUpPage(),
          '/menu': (BuildContext context) => new MenuPage(),
          '/settings': (BuildContext context) => new SettingsPage(),
          '/help': (BuildContext context) => new HelpPage(),
          '/info': (BuildContext context) => new InfoPage(),
          '/sale': (BuildContext context) => new SalePage(),
          '/bonus': (BuildContext context) => new BonusPage(),
          '/profile': (BuildContext context) => new ProfilePage(),
          '/change-password': (BuildContext context) =>
              new ChangePasswordPage(),
          '/order': (BuildContext context) => new OrderPage(),
          '/history': (BuildContext context) => new HistoryPage(),
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale("ru"),
        ],
        home: LoaderPage(),
        debugShowCheckedModeBanner: false,
//        home: homeRoute,
      ),
    );
  }
}
