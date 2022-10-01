// ignore_for_file: file_names
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_parking_system/data/provider/qr_scanner_provider.dart';

class ScanQRView extends StatefulWidget {
  const ScanQRView({Key? key}) : super(key: key);

  @override
  State<ScanQRView> createState() => _ScanQRViewState();
}

class _ScanQRViewState extends State<ScanQRView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.resumeCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, value, child) {
        return Provider.of<ScannerProvider>(context, listen: true).isScanning
            ? _scanStep(context)
            : Provider.of<ScannerProvider>(context, listen: true).isFetching
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _checkStep(context);
      },
    );
  }

  Widget _checkStep(context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Consumer(
                    builder: (context, value, child) {
                      return Provider.of<ScannerProvider>(context, listen: true)
                              .isCheckOut
                          ? Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Xe này đã checkout!"),
                                    Text(
                                        "Thời gian checkout: ${Provider.of<ScannerProvider>(context, listen: false).checkOutTime.toDate().toString()}")
                                  ]),
                            )
                          : Image.network(Provider.of<ScannerProvider>(context,
                                  listen: false)
                              .imageURL);
                    },
                  ))),
          const SizedBox(
            height: 20,
          ),
          Consumer(
            builder: (context, value, child) {
              return Provider.of<ScannerProvider>(context, listen: true)
                          .isCheckOut ==
                      false
                  ? ElevatedButton(
                      onPressed: () {
                        Provider.of<ScannerProvider>(context, listen: false)
                            .completeCheckout();
                      },
                      child: const Text("OK"))
                  : ElevatedButton(
                      onPressed: () {
                        Provider.of<ScannerProvider>(context, listen: false)
                            .resetProvider();
                      },
                      child: const Text("Cancel"));
            },
          )
        ],
      ),
    );
  }

  Widget _scanStep(context) {
    return Stack(
      children: [
        Expanded(flex: 4, child: _buildQrView(context)),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), padding: const EdgeInsets.all(20)),
                onPressed: () async {
                  await controller?.resumeCamera();
                },
                child: const Icon(Icons.qr_code_scanner)),
          ),
        ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? MediaQuery.of(context).size.width - 100
        : MediaQuery.of(context).size.width - 100;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      Provider.of<ScannerProvider>(context, listen: false).readResult(scanData);
      Provider.of<ScannerProvider>(context, listen: false).scanSuccess();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
