import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_ui/Screens/Login/login_screen.dart';
import 'package:login_ui/Screens/SignUp/signup_screen.dart';
import '../../../components/rounded_button.dart';
import './background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to Healthy Being App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          SvgPicture.asset(
            'assets/icons/chat.svg',
            height: size.height * 0.4,
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          RoundedButton(
            text: 'Login',
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
          RoundedButton(
            text: 'SignUp',
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SignupScreen();
                }),
              );
            },
            textcolor: Colors.black,
          ),
        ],
      ),
    );
  }
}
