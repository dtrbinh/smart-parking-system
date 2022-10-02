import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/architecture/BaseView.dart';
import 'package:smart_parking_system/architecture/BaseViewModel.dart';
import 'package:smart_parking_system/data/provider/CameraProvider.dart';
import 'package:smart_parking_system/data/provider/GuardProvider.dart';
import 'package:smart_parking_system/features/guard/GuardView.dart';
import 'package:smart_parking_system/features/login_screen/LoginViewModel.dart';

class LoginView extends BaseView {
  const LoginView({Key? key}) : super(key: key);

  @override
  BaseViewState<BaseView, BaseViewModel> getViewState() {
    return _LoginViewState();
  }
}

class _LoginViewState extends BaseViewState<LoginView, LoginViewModel> {
  @override
  Widget getView() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "SMART PARKING SYSTEM",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelStyle: const TextStyle(color: Colors.black),
                  label: Row(
                    children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Text("Email"),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelStyle: const TextStyle(color: Colors.black),
                    label: Row(
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Password"),
                      ],
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: () {},
                  child: const Text('Sign in')),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Don't have an account?"),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Sign up")
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin:
                        const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                    height: 1.0,
                    width: 100,
                    color: Colors.black12,
                  ),
                  const Text('  Or  '),
                  Container(
                    margin:
                        const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                    height: 1.0,
                    width: 100,
                    color: Colors.black12,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              _loginCard(() {
                context
                    .read<GuardProvider>()
                    .accountRepository
                    .handleSignIn()
                    .then((value) {
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(microseconds: 800),
                        content: Text("Login successfully!")));
                    Future.delayed(const Duration(milliseconds: 800), () {
                      Provider.of<CameraProvider>(context, listen: false)
                          .initCamera();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GuardView()));
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Login failed, please try again.")));
                  }
                });
              }, 'Sign in with Google', "assets/images/ic_google.png"),
              _loginCard(() {}, 'Sign in with Phone Number',
                  'assets/images/ic_phone.png'),
            ],
          ),
        ));
  }

  @override
  LoginViewModel getViewModel() {
    return LoginViewModel();
  }

  @override
  void onViewModelReady() {}

  Widget _loginCard(VoidCallback onTap, String title, String imageAsset) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 00, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5))
                ],
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const SizedBox(
                  width: 50,
                ),
                Image.asset(
                  imageAsset,
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }
}
