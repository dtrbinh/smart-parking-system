// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/src/data/provider/camera_provider.dart';
import 'package:smart_parking_system/src/data/provider/route_provider.dart';
import 'package:smart_parking_system/src/data/provider/upload_firestorage_provider.dart';
import 'package:smart_parking_system/src/modules/generate_QR/generate_QR.dart';
import 'package:smart_parking_system/src/modules/take_picture/display_picture_screen.dart';
import 'package:smart_parking_system/src/modules/take_picture/take_picture_screen.dart';

class TakePicture extends StatefulWidget {
  const TakePicture({Key? key}) : super(key: key);

  @override
  State<TakePicture> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Consumer(
      builder: (context, value, child) {
        return Provider.of<RouteProvider>(context, listen: false)
                .confirmGenerate
            ? GenerateQR(
                linkQR: Provider.of<FireStorageProvider>(context, listen: false)
                    .linkImageFireStorage,
              )
            : Provider.of<RouteProvider>(context, listen: false).takeSuccessful
                ? confirmPicture(context)
                : TakePictureScreen(
                    camera: Provider.of<CameraProvider>(context, listen: false)
                        .firstCamera);
      },
    ));
  }

  Widget confirmPicture(context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 600,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
          child: DisplayPictureScreen(
              imagePath:
                  Provider.of<FireStorageProvider>(context, listen: false)
                      .imagePath),
        ),
        Positioned(
            bottom: 20,
            child: Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: (() {
                      print(
                          'Deleting: ${Provider.of<FireStorageProvider>(context, listen: false).imagePath}');
                      Provider.of<FireStorageProvider>(context, listen: false)
                          .deleteFile(File(Provider.of<FireStorageProvider>(
                                  context,
                                  listen: false)
                              .imagePath));
                      Provider.of<RouteProvider>(context, listen: false)
                          .changeTakeSuccessfull();
                    }),
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15)),
                    child: const Icon(Icons.restart_alt)),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: (() {
                      //Gửi lên firebase thành công thì tự xoá ảnh trong local
                      Provider.of<FireStorageProvider>(context, listen: false)
                          .uploadtoFireStorage();
                      //Lấy link ảnh firebase dùng API gen link ảnh QR
                      //Xác nhận gen thành công, gửi link QR sang để hiển thị và in
                      Provider.of<RouteProvider>(context, listen: false)
                          .changeConfirmGenerate();
                    }),
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15)),
                    child: const Icon(Icons.check)),
              ]),
            ))
      ],
    );
  }
}
