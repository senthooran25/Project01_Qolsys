import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/constants/svg_constants.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/providers/user_model.dart';
import 'package:qolsys_app/widget/circular_indicator.dart';
import 'package:qolsys_app/widget/scaled_image.dart';

class LoginPage extends StatefulWidget {
  static const id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _unC; //username controller
  TextEditingController _pwC; //password controller
  StreamSubscription _errorSubscription;
  @override
  void initState() {
    _unC = TextEditingController();
    _pwC = TextEditingController();
    _subscribeForErrors();
    super.initState();
  }

  _subscribeForErrors() {
    _errorSubscription = context.read<UserModel>().errorStream.listen(
          (status) => showDialog(
            context: context,
            builder: (context) => LoginErrorDialog(text: '$status'),
          ),
        );
  }

  @override
  void dispose() {
    _unC.dispose();
    _pwC.dispose();
    _errorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel>();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.9, -.9),
                end: Alignment(0.5, 0.5),
                colors: [kGray, jciBlue],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex: 6),
                ScaledImage(svgAsset: ICON_JCI_LOGO, width: 200.0),
                Spacer(flex: 5),
                UsernameTextField(controller: _unC, key: Key('username field')),
                SizedBox(height: 2.0),
                PasswordTextField(controller: _pwC, key: Key('password field')),
                Spacer(
                  flex: 2,
                ),
                SignOnButton(
                  onPressed: () {
                    if (_unC.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => LoginErrorDialog(
                          text: LocaleKeys.warning_empty_username.tr(),
                        ),
                      );
                      return;
                    } else if (_pwC.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => LoginErrorDialog(
                          text: LocaleKeys.warning_empty_password.tr(),
                        ),
                      );
                      return;
                    } else {
                      FocusScope.of(context).unfocus();
                      userModel.login(_unC.value.text, _pwC.value.text);
                    }
                  },
                ),
                Spacer(flex: 1),
                ForgotRow(),
                Spacer(flex: 4),
                FingerprintCircularAvatar(),
                Divider(
                  thickness: 0.5,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                Footer(),
                Container(
                  color: jciBlue,
                  height: 20.0,
                )
              ],
            ),
          ),
          if (userModel.loading) Center(child: CircularIndicator()),
        ],
      ),
    );
  }
}

class LoginErrorDialog extends StatelessWidget {
  const LoginErrorDialog({@required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: AlertDialog(title: Text(text)));
  }
}

class LoginTextField extends StatelessWidget {
  final String hintText;
  final Widget suffixIcon;
  final TextEditingController controller;
  final bool obscureText;

  LoginTextField({
    this.hintText,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = 20.0;
    return Container(
      color: kBlack.withOpacity(0.1),
      constraints: BoxConstraints(maxWidth: 600.0),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10.0),
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        enableSuggestions: false,
        autocorrect: false,
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(height: 2.3, fontSize: fontSize),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: kLight.withOpacity(0.5),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [suffixIcon]),
          ),
        ),
      ),
    );
  }
}

class UsernameTextField extends StatelessWidget {
  final TextEditingController controller;

  UsernameTextField({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return LoginTextField(
      hintText: LocaleKeys.usernameText.tr(),
      suffixIcon: GestureDetector(
        onTap: () => controller.clear(),
        child: CircleAvatar(
          backgroundColor: kLight.withOpacity(0.5),
          radius: width / 40,
          child: Icon(
            Icons.close,
            color: kBlack.withOpacity(0.5),
            size: width / 25,
          ),
        ),
      ),
      controller: controller,
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;

  PasswordTextField({Key key, this.controller}) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _hidden = true;

  void toggle() {
    setState(() {
      _hidden = !_hidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final suffixText = _hidden
        ? LocaleKeys.txt_password_show.tr()
        : LocaleKeys.txt_password_hide.tr();
    final fontSize = 22.0;
    return LoginTextField(
      hintText: LocaleKeys.passwordText.tr(),
      suffixIcon: GestureDetector(
          onTap: toggle,
          child: Text(
            suffixText,
            style: TextStyle(
              fontSize: fontSize,
              color: kLight.withOpacity(0.5),
            ),
          )),
      obscureText: _hidden,
      controller: widget.controller,
    );
  }
}

class SignOnButton extends StatelessWidget {
  final Function onPressed;

  SignOnButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    final fontSize = 30.0;
    return FlatButton(
      onPressed: onPressed,
      child: Container(
        child: Text(
          LocaleKeys.btn_sing_on.tr(),
          style: TextStyle(fontSize: fontSize, color: kWhite),
        ),
      ),
    );
  }
}

class ForgotRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fontSize = 17.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FlatButton(
          child: Text(
            LocaleKeys.btn_forgot_user_id.tr(),
            style: TextStyle(
              color: kWhite,
              fontSize: fontSize,
            ),
          ),
          onPressed: () {},
        ),
        FlatButton(
          child: Text(
            LocaleKeys.btn_forgot_password.tr(),
            style: TextStyle(
              color: kWhite,
              fontSize: fontSize,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class FingerprintCircularAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 12;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: kWhite,
          width: 1.0,
        ),
      ),
      child: Icon(Icons.fingerprint, color: kWhite, size: size),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fontSize = 18.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FlatButton(
          onPressed: () {},
          child: Text(
            'Qolsys.com',
            style: TextStyle(color: kWhite, fontSize: fontSize),
          ),
        ),
        FlatButton(
          onPressed: () {},
          child: Text(
            LocaleKeys.btn_register_activate.tr(),
            style: TextStyle(color: kWhite, fontSize: fontSize),
          ),
        ),
        FlatButton(
          onPressed: () {},
          child: Text(
            LocaleKeys.btn_support.tr(),
            style: TextStyle(color: kWhite, fontSize: fontSize),
          ),
        ),
      ],
    );
  }
}
