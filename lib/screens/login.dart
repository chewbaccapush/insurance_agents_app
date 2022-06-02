import 'package:flutter/material.dart';
import 'package:msg/screens/history.dart';
import 'package:msg/validators/Validators.dart';
import 'package:msg/widgets/custom_text_form_field.dart';

import '../services/navigator_service.dart';
import '../services/storage_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset("assets/images/msg-logo.png")),
                ),
              ),
              const Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: CustomTextFormField(
                  type: TextInputType.text,
                  labelText: "Username",
                  width: 500,
                  suffix: Icon(Icons.person),
                )
              ),
              const Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 0, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: CustomTextFormField(
                  type: TextInputType.text,
                  labelText: "Password",
                  width: 500,
                  obscureText: true,
                  suffix: Icon(Icons.key),
                )
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.login),
                  label: const Text("Login"),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    primary: (StorageService.getAppThemeId() ==
                            false)
                        ? const Color.fromARGB(220, 112, 14, 46)
                        : const Color.fromARGB(
                            148, 112, 14, 46),
                  ),
                  onPressed: () => {
                    StorageService.setLoggedIn(true),
                    print(StorageService.isLoggedIn()),
                    NavigatorService.navigateTo(
                        context, const HistoryPage())
                  },
                ),
              SizedBox(
                height: 130,
              ),
            ],
          ),
        )),
      ),
    );
  }
}