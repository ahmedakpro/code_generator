import 'dart:io';
import 'package:code_generator/db/storage_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import '../widgets/my_dialogs.dart';

class SaveBarcode {
  Future<void> saveAsPdfDirectly({
    required BuildContext cnx,
    required String fileName,
    required bool isQr,
    required String data,
    required String codeName,
  }) async {
    await ItemStorage.requestBackupPermissions();
    final ttf2 = await fontFromAssetBundle('assets/fonts/Cairo-Bold.ttf');
    try {
      // Create a PDF document
      final pdf = pw.Document();
      const double barcodeWidth = 150;
      const double barcodeHeight = 50;
      // Convert the Flutter widget to PDF format
      final pdfPage = pw.Page(
        pageFormat: PdfPageFormat.letter.copyWith(
          width: double.infinity, // Expand width dynamically
          height: double.infinity, // Expand height dynamically
        ),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.BarcodeWidget(
                barcode: isQr ? Barcode.qrCode() : Barcode.code39(),
                data: data,
                width: isQr ? 200 : barcodeWidth,
                height: isQr ? 80 : barcodeHeight,
                padding: const pw.EdgeInsets.only(top: 8),
                textStyle: const pw.TextStyle(
                  fontSize: 16,
                  letterSpacing: 10.5,
                ),
              ),
              pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Text(
                  codeName,
                  style: pw.TextStyle(fontSize: 12, font: ttf2),
                  textAlign: pw.TextAlign.end,
                ),
              ),
              pw.SizedBox(height: 10),
            ],
          );
        },
      );

      // Add page to PDF
      pdf.addPage(pdfPage);
      final outputDirectory = await ItemStorage.getBackupDirectory();
      // Save the PDF to a temporary file
      final String tempPath =
          '$outputDirectory/code_generator_Backups/$fileName.pdf';

      final File pdfFile = File(tempPath);
      await pdfFile.writeAsBytes(await pdf.save());

      if (cnx.mounted) {
        MyDialogs.showSnackBar(cnx, '✅ تم الحفظ كـ PDF بنجاح: $tempPath');
      }
    } catch (e) {
      if (cnx.mounted) {
        MyDialogs.showSnackBar(cnx, '❌ خطأ غير متوقع في حفظ PDF: $e');
      }
    }
  }

  /// Saves multiple barcodes in an A4 PDF file
  Future<void> saveAsA4Pdf({
    required BuildContext context,
    required List<int> barcodes,
    required String fileName,
    required bool isQr,
    required String codeName,
  }) async {
    await ItemStorage.requestBackupPermissions();
    final ttf2 = await fontFromAssetBundle('assets/fonts/Cairo-Bold.ttf');
    try {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      if (!await Permission.storage.isGranted) {
        MyDialogs.showSnackBar(context, 'تم رفض إذن التخزين!');
        return;
      }

      final pdf = pw.Document();
      // Define barcode layout settings
      const int rows = 10;
      const int columns = 3;
      const double barcodeWidth = 150;
      const double barcodeHeight = 50;

      // PDF Page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(15),
          build: (pw.Context context) {
            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: List.generate(rows, (rowIndex) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: List.generate(columns, (colIndex) {
                    int index = rowIndex * columns + colIndex;
                    if (index >= barcodes.length) {
                      return pw.SizedBox();
                    }

                    return pw.Column(
                      children: [
                        pw.BarcodeWidget(
                          barcode: isQr ? Barcode.qrCode() : Barcode.code39(),
                          data: barcodes[index].toString(),
                          width: isQr ? 200 : barcodeWidth,
                          height: isQr ? 80 : barcodeHeight,
                          padding: const pw.EdgeInsets.only(top: 8),
                          textStyle: const pw.TextStyle(
                            fontSize: 16,
                            letterSpacing: 10.5,
                          ),
                        ),
                        pw.Directionality(
                          textDirection: pw.TextDirection.rtl,
                          child: pw.Text(
                            codeName,
                            style: pw.TextStyle(fontSize: 12, font: ttf2),
                            textAlign: pw.TextAlign.end,
                          ),
                        ),
                        pw.SizedBox(height: 10),
                      ],
                    );
                  }),
                );
              }),
            );
          },
        ),
      );
      // Save to device
      final outputDirectory = await ItemStorage.getBackupDirectory();

      final filePath = "$outputDirectory/code_generator_Backups/$fileName.pdf";
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      Navigator.pop(context);
      // Show success message
      MyDialogs.showSnackBar(context, '✅ تم حفظ ملف PDF: $filePath');
    } catch (e) {
      MyDialogs.showSnackBar(context, '❌ خطأ أثناء حفظ الملف: $e');
    }
  }
}
