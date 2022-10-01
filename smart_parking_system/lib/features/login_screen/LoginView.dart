import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/architecture/BaseView.dart';
import 'package:smart_parking_system/architecture/BaseViewModel.dart';
import 'package:smart_parking_system/data/provider/camera_provider.dart';
import 'package:smart_parking_system/features/guard/GuardView.dart';
import 'package:smart_parking_system/features/login_screen/LoginViewModel.dart';
import 'package:smart_parking_system/features/manager/ManagerView.dart';

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
        appBar: AppBar(title: const Text("Smart Parking System")),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Username")),
              ),
              const SizedBox(
                height: 20,
              ),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Password")),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<CameraProvider>(context, listen: false)
                        .initCamera();
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: ((context) => const GuardView())));
                  },
                  child: const Text("Login Guard")),
              // const SizedBox(
              //   height: 20,
              // ),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<CameraProvider>(context, listen: false)
                        .initCamera();
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: ((context) => const ManagerView())));
                  },
                  child: const Text("Login Manager")),
            ],
          ),
        )));
  }

  @override
  LoginViewModel getViewModel() {
    return LoginViewModel();
  }

  @override
  void onViewModelReady() {}
}
