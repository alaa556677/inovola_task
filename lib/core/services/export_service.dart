import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import '../../features/dashboard/domain/entities/expense_entity.dart';

class ExportService {
  static const List<String> _categories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Education',
    'Utilities',
    'Travel',
    'Other'
  ];

  /// Export expenses as PDF
  static Future<File?> exportToPDF({
    required List<ExpenseEntity> expenses,
    required String filterType,
    required double totalBalance,
    required double totalIncome,
    required double totalExpenses,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            _buildPDFHeader(filterType),
            _buildPDFSummary(totalBalance, totalIncome, totalExpenses),
            _buildPDFExpensesTable(expenses),
          ],
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/expenses_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());
      
      return file;
    } catch (e) {
      print('Error generating PDF: $e');
      return null;
    }
  }

  /// Export expenses as CSV
  static Future<File?> exportToCSV({
    required List<ExpenseEntity> expenses,
    required String filterType,
  }) async {
    try {
      final csvData = <List<dynamic>>[];
      
      // Add header
      csvData.add([
        'Date',
        'Category',
        'Amount',
        'Currency',
        'Converted Amount (USD)',
        'Type',
        'Notes',
      ]);

      // Add data rows
      for (final expense in expenses) {
        csvData.add([
          DateFormat('yyyy-MM-dd').format(expense.date),
          expense.category,
          expense.amount.toStringAsFixed(2),
          expense.currency,
          expense.convertedAmount.toStringAsFixed(2),
          expense.type,
          expense.notes ?? '',
        ]);
      }

      final csvString = const ListToCsvConverter().convert(csvData);
      
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/expenses_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csvString);
      
      return file;
    } catch (e) {
      print('Error generating CSV: $e');
      return null;
    }
  }

  static pw.Widget _buildPDFHeader(String filterType) {
    return pw.Header(
      level: 0,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Expenses Report',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            'Filter: $filterType',
            style: pw.TextStyle(
              fontSize: 14,
              color: PdfColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPDFSummary(
    double totalBalance,
    double totalIncome,
    double totalExpenses,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 20),
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Summary',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Income:'),
              pw.Text(
                '\$${totalIncome.toStringAsFixed(2)}',
                style: pw.TextStyle(color: PdfColors.green),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Expenses:'),
              pw.Text(
                '\$${totalExpenses.toStringAsFixed(2)}',
                style: pw.TextStyle(color: PdfColors.red),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Balance:'),
              pw.Text(
                '\$${totalBalance.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  color: totalBalance >= 0 ? PdfColors.green : PdfColors.red,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPDFExpensesTable(List<ExpenseEntity> expenses) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey),
      columnWidths: const {
        0: pw.FixedColumnWidth(80),  // Date
        1: pw.FixedColumnWidth(100), // Category
        2: pw.FixedColumnWidth(80),  // Amount
        3: pw.FixedColumnWidth(60),  // Currency
        4: pw.FixedColumnWidth(100), // Converted Amount
        5: pw.FixedColumnWidth(60),  // Type
        6: pw.FixedColumnWidth(120), // Notes
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('Category', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('Currency', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('USD Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text('Notes', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        // Data rows
        ...expenses.map((expense) => pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(DateFormat('MM/dd/yyyy').format(expense.date)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(expense.category),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(expense.amount.toStringAsFixed(2)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(expense.currency),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(expense.convertedAmount.toStringAsFixed(2)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                expense.type,
                style: pw.TextStyle(
                  color: expense.type == 'income' ? PdfColors.green : PdfColors.red,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(expense.notes ?? ''),
            ),
          ],
        )).toList(),
      ],
    );
  }
}
