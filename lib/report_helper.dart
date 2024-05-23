import 'dart:io';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportHelper {
  static Future<void> exportToCSV(List<Map<String, dynamic>> data) async {
    // Verifica se a permissão de gerenciamento de armazenamento externo foi concedida
    if (await Permission.manageExternalStorage.request().isGranted) {
      List<List<dynamic>> rows = [];

      // Add headers
      rows.add(["ID", "Title", "Category", "Value", "CreatedAt"]);

      // Add data
      for (var item in data) {
        rows.add([
          item["id"],
          item["title"],
          item["category"],
          item["value"],
          item["createdAt"]
        ]);
      }

      String csv = const ListToCsvConverter().convert(rows);

      // Obtém o diretório de downloads
      final directory = Directory('/storage/emulated/0/Download');
      final path = '${directory.path}/products_report.csv';
      final file = File(path);

      await file.writeAsString(csv);
      print("CSV file saved at: $path");
    } else {
      print("Permissão de gerenciamento de armazenamento externo negada");
    }
  }
}
