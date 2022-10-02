// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/features/guard/GuardViewModel.dart';
import 'package:smart_parking_system/data/provider/storage_provider.dart';

class QRWidgetView extends StatefulWidget {
  const QRWidgetView({
    super.key,
  });

  @override
  State<QRWidgetView> createState() => _QRWidgetViewState();
}

class _QRWidgetViewState extends State<QRWidgetView> {
  @override
  Widget build(BuildContext context) {
    return (context.watch<StorageProvider>().isDetect)
        ? context.watch<StorageProvider>().isDetectSuccess
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                    child: Column(
                      children: context
                          .read<StorageProvider>()
                          .listNumplateText
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  (context.watch<StorageProvider>().linkQR != '')
                      ? Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Image.network(
                                context.read<StorageProvider>().linkQR,
                                height:
                                    MediaQuery.of(context).size.width * 3 / 4,
                                width:
                                    MediaQuery.of(context).size.width * 3 / 4,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              callbackButton(Icons.print, () {
                                context
                                    .read<GuardViewModel>()
                                    .changeConfirmGenerate();
                                context
                                    .read<GuardViewModel>()
                                    .changeTakeSuccessfull();
                                context.read<StorageProvider>().resetProvider();
                              }),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Generating QR...",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SpinKitFadingCircle(
                              color: Colors.black,
                              size: 70,
                            ),
                          ],
                        ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Cant detect numplate.\nPlease try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  callbackButton(Icons.arrow_back, () {
                    context.read<GuardViewModel>().changeConfirmGenerate();
                    context.read<GuardViewModel>().changeTakeSuccessfull();
                    context.read<StorageProvider>().resetProvider();
                  })
                ],
              )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Plate number detecting...",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              SpinKitFadingCircle(
                color: Colors.black,
                size: 70,
              ),
            ],
          );
  }

  Widget callbackButton(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(), padding: const EdgeInsets.all(20)),
        child: Icon(
          icon,
          // Icons.print,
        ));
  }
}
