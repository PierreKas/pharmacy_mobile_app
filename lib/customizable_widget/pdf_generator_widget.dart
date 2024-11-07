import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGeneratorWidget {
  final String fileName;
  final List<Map<String, dynamic>> transactions;
  final List<String> headers;
  PdfGeneratorWidget({
    required this.fileName,
    required this.transactions,
    required this.headers,
  });
  Future<void> downloadPDF() async {
    var status = await Permission.storage.request();
    print('Permission Status: $status');
    if (status.isGranted) {
      var pdf = pw.Document();

      List<pw.TableRow> tableRows = [
        pw.TableRow(
          children: headers.map((header) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(16),
              child: pw.Text(
                header,
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
              ),
            );
          }).toList(),
        ),
        for (var transaction in transactions)
          pw.TableRow(
            children: transaction.values.map((value) {
              return pw.Padding(
                padding: const pw.EdgeInsets.all(16),
                child: pw.Text(
                  value,
                  style:
                      const pw.TextStyle(fontSize: 10, color: PdfColors.black),
                ),
              );
            }).toList(),
          )
      ];
      pdf.addPage(pw.Page(
          build: (pw.Context context) => pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black),
              children: tableRows)));
      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        String outputFile = '${directory.path}/Download/$fileName.pdf';
        File file = File(outputFile);
        await file.create(recursive: true);
        await file.writeAsBytes(await pdf.save());
        Fluttertoast.showToast(msg: 'PDF downloaded');
      } else {
        Fluttertoast.showToast(msg: 'Failed to store');
      }
    } else {
      Fluttertoast.showToast(msg: 'Download failed');
    }
  }
}
