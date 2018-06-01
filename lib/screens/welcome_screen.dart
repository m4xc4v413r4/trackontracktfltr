import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trackontraktfltr/authorization.dart';
import 'package:trackontraktfltr/routes.dart';
import 'package:trackontraktfltr/strings.dart';
import 'package:trackontraktfltr/style.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _checkingIfAlreadyLoggedIn = true;
  Authorization _authorization = Authorization();

  @override
  void initState() {
    super.initState();
    _checkAuthorization();
  }

  _onLoginButtonPressed() async {
    Navigator.of(context).pushNamed(Routes.login);
  }

  _launchTraktWebsite() async {
    const url = Strings.traktTvUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var parentTheme = Theme.of(context);

    var theme = parentTheme.copyWith(
        primaryColor: AppStyle.welcomePrimaryColor,
        primaryColorBrightness: Brightness.dark,
        scaffoldBackgroundColor: AppStyle.welcomePrimaryColor,
        buttonColor: parentTheme.accentColor,
        buttonTheme: parentTheme.buttonTheme
            .copyWith(textTheme: ButtonTextTheme.primary),
        textTheme: parentTheme.textTheme.copyWith(
            display1: parentTheme.textTheme.display1.copyWith(
                color: AppStyle.welcomeTitleColor,
                fontFamily: AppStyle.fontRobotoSlab)));

    var defaultTextStyle = Theme.of(context).primaryTextTheme.body1;
    var underlinedStyle = defaultTextStyle.copyWith(
        decoration: TextDecoration.underline, color: theme.accentColor);

    return Theme(
        data: theme,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/ic_big.png'),
                      Text(Strings.appName, style: theme.textTheme.display1)
                    ]),
              ),
              _buildWelcomeText(defaultTextStyle, underlinedStyle),
              Row(children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 32.0),
                        child: _checkingIfAlreadyLoggedIn
                            ? Row(
                                children: <Widget>[CircularProgressIndicator()],
                                mainAxisAlignment: MainAxisAlignment.center,
                              )
                            : RaisedButton(
                                onPressed: () => _onLoginButtonPressed(),
                                child: Text(Strings.traktTvUrl))))
              ])
            ],
          ),
        ));
  }

  Container _buildWelcomeText(
      TextStyle defaultTextStyle, TextStyle underlinedStyle) {
    return Container(
      width: 304.0,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: Strings.welcomeMessagePartA,
            style: defaultTextStyle,
            children: <TextSpan>[
              TextSpan(
                  text: Strings.welcomeMessageTraktTv,
                  style: underlinedStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchTraktWebsite();
                    }),
              TextSpan(
                  style: defaultTextStyle, text: Strings.welcomeMessagePartB)
            ]),
      ),
    );
  }

  void _checkAuthorization() async {
    bool loggedIn = await _authorization.isAuthorized();
    if (loggedIn) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.history, (Route<dynamic> route) => false);
    } else {
      setState(() {
        _checkingIfAlreadyLoggedIn = false;
      });
    }
  }
}
