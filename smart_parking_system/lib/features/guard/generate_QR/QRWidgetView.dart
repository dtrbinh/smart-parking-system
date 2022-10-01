// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/features/guard/GuardViewModel.dart';
import 'package:smart_parking_system/data/provider/storage_provider.dart';

class QRWidgetView extends StatefulWidget {
  final String linkQR;
  const QRWidgetView({
    super.key,
    required this.linkQR,
  });
  @override
  State<QRWidgetView> createState() => _QRWidgetViewState();
}

class _QRWidgetViewState extends State<QRWidgetView> {
  @override
  Widget build(BuildContext context) {
    return (context.watch<StorageProvider>().linkQR != "")
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              context.watch<StorageProvider>().isDetect
                  ? context.watch<StorageProvider>().isDetectSuccess
                      ? Container(
                          width: MediaQuery.of(context).size.width * 3 / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: context
                                .read<StorageProvider>()
                                .listNumplate
                                .map((e) => Image.file(
                                      e,
                                      height: 150,
                                      width: 0.75 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .width -
                                          50,
                                      fit: BoxFit.scaleDown,
                                    ))
                                .toList(),
                          ),
                        )
                      : const Center(
                          child: Text("Cant detect numplate."),
                        )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Numplate detecting"),
                        SizedBox(
                          height: 10,
                        ),
                        SpinKitFadingCircle(
                          color: Colors.black,
                          size: 70,
                        ),
                      ],
                    ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent),
                child: Consumer(
                  builder: (context, value, child) {
                    return Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 3 / 4,
                      child:
                          Image.network(context.read<StorageProvider>().linkQR),
                    );
                  },
                ),
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: (() {
                    context.read<GuardViewModel>().changeConfirmGenerate();
                    context.read<GuardViewModel>().changeTakeSuccessfull();
                    context.read<StorageProvider>().resetProvider();
                  }),
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20)),
                  child: const Icon(
                    Icons.print,
                  )),
              const SizedBox(
                height: 20,
              )
            ],
          )
        : const Center(
            child: SpinKitSpinningLines(
            color: Colors.black,
            itemCount: 10,
            lineWidth: 3,
            size: 100,
          ));
  }
}
