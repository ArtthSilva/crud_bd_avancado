import 'dart:developer';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportHelper {
  static Future<void> exportToCSV(List<Map<String, dynamic>> data) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      List<List<dynamic>> rows = [];

      rows.add(["ID", "Title", "Category", "Value", "CreatedAt", "UpdatedAt"]);

      for (var item in data) {
        rows.add([
          item["id"],
          item["title"],
          item["category"],
          item["value"],
          item["createdAt"],
          item["updatedAt"]  
        ]);
      }
      String csv = const ListToCsvConverter().convert(rows);

      final directory = Directory('/storage/emulated/0/Download');
      final path = '${directory.path}/products_report.csv';
      final file = File(path);

      await file.writeAsString(csv);
      log("CSV file saved at: $path");
    } else {
      log("Permissão de gerenciamento de armazenamento externo negada");
    }
  }
}
