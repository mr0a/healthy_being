import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import './background.dart';
import '../../../components/rounded_input_field.dart';
import '../../../components/rounded_password_field.dart';
import '../../../components/rounded_button.dart';
import 'package:login_ui/Screens/Login/login_screen.dart';
import 'package:login_ui/components/already_have_an_account.dart';
import '../../../helpers/data_pass_controller.dart';
import '../../../helpers/http_service.dart';

import 'or_divider.dart';
import 'social_icon.dart';

class Body extends StatelessWidget {
  final Widget child;

  const Body({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            SvgPicture.asset(
              'assets/icons/signup.svg',
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: 'Email',
              controller: MyController.dataController,
            ),
            RoundedPasswordField(
              controller: MyController.passController,
            ),
            // RoundedPasswordField(),
            RoundedButton(
              text: 'SignUp',
              press: () {
                if (MyController.username.isEmpty ||
                    MyController.password.isEmpty) {
                  SnackBar snackBar = SnackBar(
                      content:
                          Text('Both email and password fields are required!'));
                  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(MyController.username);
                if (!emailValid) {
                  return MyController.showError(
                      context, "Please enter a valid email address!");
                }
                if (MyController.password.length < 8) {
                  return MyController.showError(
                      context, 'Password must contain more than 7 characters!');
                }
                var user = HttpService();
                var resp = user.createUser(
                    MyController.username, MyController.password);
                resp.then((value) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        value['error']
                            ? 'Error in creating the account'
                            : 'Successful',
                        textAlign: TextAlign.center,
                      ),
                      content: Container(
                        height: size.height * 0.18,
                        child: Column(
                          children: [
                            Text(value['msg']),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Ok')),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                return Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialIcon(
                  iconSrc: 'assets/icons/google-plus.svg',
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
