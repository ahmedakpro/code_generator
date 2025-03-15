import 'package:barcode_widget/barcode_widget.dart' as bar;
import 'package:code_generator/widgets/MyCustomBtn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../services/providers/code_type.dart';
import '../services/save_barcode.dart';
import 'myText.dart';

class MyDialogs {
  static showSnackBar(BuildContext context, String txt) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: MyText(
      txt: txt,
      size: 16,
    )));
  }

  static tasksDialog({
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: CupertinoAlertDialog(
            title: const MyText(txt: 'تأكيد الحذف'),
            content: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyCustomBtn(
                          width: 50,
                          fontSize: 16,
                          color: borderColor,
                          onTap: () {
                            onPressed();
                          },
                          btnText: 'حـذف'),
                      MyCustomBtn(
                          width: 50,
                          fontSize: 16,
                          color: primaryColor,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          btnText: 'إلغاء'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static saveDailog({
    required GlobalKey globalKey,
    required BuildContext cnx,
    required String itemName,
    required String itemType,
    required dynamic itemNum,
    required bool isQr, // NEW: Indicate whether saving QR or barcode
  }) {
    showDialog(
      context: cnx,
      builder: (context) => ChangeNotifierProvider(
          create: (_) => CodeTypeProvider()..isQr = isQr,
          child: Consumer<CodeTypeProvider>(
              builder: (context, codeTypeProvider, _) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: CupertinoAlertDialog(
                title: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  tooltip: 'حفظ مفرد',
                                  icon: const Icon(Icons.save_alt, size: 30),
                                  onPressed: () async {
                                    await SaveBarcode().saveAsPdfDirectly(
                                      cnx: cnx,
                                      codeName: isQr || codeTypeProvider.isQr
                                          ? itemName
                                          : '$itemName - $itemType',
                                      data:
                                          isQr ? itemType : itemNum.toString(),
                                      isQr: isQr,
                                      fileName: isQr
                                          ? '${itemName}_QR_one_$itemNum'
                                          : '${itemName}_${codeTypeProvider.isQr ? 'qr_one' : ''}_one_$itemType',
                                    );
                                    Navigator.pop(context);
                                  }),
                              !isQr
                                  ? IconButton(
                                      tooltip: codeTypeProvider.isQr
                                          ? 'تغيير إلى باركود'
                                          : 'تغيير إلى QR',
                                      icon: Icon(
                                        codeTypeProvider.isQr
                                            ? Icons.qr_code
                                            : Icons.barcode_reader,
                                        size: 30,
                                      ),
                                      onPressed:
                                          codeTypeProvider.toggleCodeType,
                                    )
                                  : const SizedBox.shrink(),
                              !isQr
                                  ? IconButton(
                                      tooltip: 'حفظ متعدد',
                                      icon: const Icon(
                                        Icons.picture_as_pdf_outlined,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        await SaveBarcode().saveAsA4Pdf(
                                          codeName: '${itemName}_$itemType',
                                          isQr: codeTypeProvider.isQr,
                                          context: cnx,
                                          barcodes: List.generate(
                                              24,
                                              (index) =>
                                                  isQr ? itemType : itemNum),
                                          fileName: isQr
                                              ? '${itemName}_QR'
                                              : '${itemName}_${codeTypeProvider.isQr ? 'qr' : ''}_$itemType',
                                        );
                                      })
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        RepaintBoundary(
                          key: globalKey,
                          child: Container(
                            color: primaryFontColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: isQr
                                      ? bar.BarcodeWidget(
                                          barcode: bar.Barcode.qrCode(),
                                          data: itemType.toString(),
                                          width: 200,
                                          height: 80,
                                          padding: const EdgeInsets.only(
                                              top: 8, right: 8, left: 8),
                                          // backgroundColor: primaryFontColor,
                                        )
                                      : bar.BarcodeWidget(
                                          barcode: codeTypeProvider.isQr
                                              ? bar.Barcode.qrCode()
                                              : bar.Barcode.code39(),
                                          data: itemNum.toString(),
                                          width: 200,
                                          height:
                                              codeTypeProvider.isQr ? 80 : 60,
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          // backgroundColor: primaryFontColor,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 10.5),
                                        ),
                                ),
                                const SizedBox(height: 10),
                                MyText(
                                  txt:
                                      isQr ? itemName : '$itemName - $itemType',
                                  family: boldFont,
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          })),
    );
  }
}
