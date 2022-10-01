import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/architecture/BaseView.dart';
import 'package:smart_parking_system/architecture/BaseViewModel.dart';
import 'package:smart_parking_system/features/guard/GuardViewModel.dart';

class GuardView extends BaseView {
  const GuardView({Key? key}) : super(key: key);

  @override
  BaseViewState<BaseView, BaseViewModel> getViewState() {
    return _GuardViewState();
  }
}

class _GuardViewState extends BaseViewState<GuardView, GuardViewModel> {
  @override
  Widget getView() {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("System Manager"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  viewModel.logout(context);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: viewModel.selectedIndex,
            onTap: (int index) {
              viewModel.changeSelectedIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.input), label: "Check in"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.output), label: "Check out"),
            ]),
        body: Consumer(
          builder: (context, value, child) => viewModel.getBody(context),
        ));
  }

  @override
  GuardViewModel getViewModel() {
    return GuardViewModel();
  }

  @override
  void onViewModelReady() {}
}
