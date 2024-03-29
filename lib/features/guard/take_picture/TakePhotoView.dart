import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_system/data/provider/CameraProvider.dart';
import 'package:smart_parking_system/features/guard/GuardViewModel.dart';
import 'package:smart_parking_system/data/provider/GuardProvider.dart';
import 'package:smart_parking_system/features/guard/generate_QR/QRWidgetView.dart';
import 'package:smart_parking_system/features/guard/take_picture/widget/CameraWidgetView.dart';
import 'package:smart_parking_system/features/guard/take_picture/widget/PhotoWidgetView.dart';

class TakePhotoView extends StatefulWidget {
  const TakePhotoView({Key? key}) : super(key: key);

  @override
  State<TakePhotoView> createState() => _TakePhotoViewState();
}

class _TakePhotoViewState extends State<TakePhotoView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
          child: context.watch<GuardViewModel>().confirmGenerate
              ? const QRWidgetView()
              : context.watch<GuardViewModel>().takeSuccessful
                  ? _confirmPicture(context)
                  : CameraWidgetView(
                      camera: context.read<CameraProvider>().firstCamera!)),
    );
  }

  Widget _confirmPicture(context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
          child: PhotoWidgetView(
              imagePath: Provider.of<GuardProvider>(context, listen: false)
                  .guardRepository
                  .imagePath),
        ),
        Positioned(
            bottom: 20,
            child: Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: (() {
                      Provider.of<GuardProvider>(context, listen: false)
                          .deleteImageCache(File(Provider.of<GuardProvider>(
                                  context,
                                  listen: false)
                              .guardRepository
                              .imagePath));
                      Provider.of<GuardViewModel>(context, listen: false)
                          .changeTakeSuccessfull();
                    }),
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20)),
                    child: const Icon(Icons.restart_alt)),
                const SizedBox(
                  width: 60,
                ),
                ElevatedButton(
                    onPressed: (() {
                      //Gửi lên firebase thành công thì tự xoá ảnh trong local
                      Provider.of<GuardProvider>(context, listen: false)
                          .uploadImage();
                      //Lấy link ảnh firebase dùng API generate link ảnh QR và nhận dạng biển số xe
                      //Xác nhận gen thành công, gửi link QR sang để hiển thị và in
                      Provider.of<GuardViewModel>(context, listen: false)
                          .changeConfirmGenerate();
                    }),
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20)),
                    child: const Icon(Icons.check)),
              ]),
            ))
      ],
    );
  }
}
