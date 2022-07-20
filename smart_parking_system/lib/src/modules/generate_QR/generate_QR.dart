import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/src/data/provider/qr_scanner_provider.dart';
import 'package:smart_parking_system/src/data/provider/route_provider.dart';
import 'package:smart_parking_system/src/data/provider/upload_firestorage_provider.dart';

class GenerateQR extends StatefulWidget {
  final String linkQR;
  const GenerateQR({
    super.key,
    required this.linkQR,
  });
  @override
  State<GenerateQR> createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 600,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: Consumer(
            builder: (context, value, child) {
              return Container(
                  child: Provider.of<FireStorageProvider>(context, listen: true)
                              .linkQR !=
                          ""
                      ? Image.network(Provider.of<FireStorageProvider>(context,
                              listen: false)
                          .linkQR)
                      : const Center(
                          child: CircularProgressIndicator(),
                        ));
            },
          ),
        ),
        Positioned(
            bottom: 20,
            child: Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: (() {
                      Provider.of<RouteProvider>(context, listen: false)
                          .changeConfirmGenerate();
                      Provider.of<RouteProvider>(context, listen: false)
                          .changeTakeSuccessfull();
                      Provider.of<FireStorageProvider>(context, listen: false)
                          .resetProvider();
                    }),
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15)),
                    child: const Icon(
                      Icons.print,
                    )),
              ]),
            ))
      ],
    );
  }
}
