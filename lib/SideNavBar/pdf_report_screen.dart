import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class PDFReportScreen extends StatelessWidget {
  final int completedWork;
  final int pendingWork;
  final bool danger;

  PDFReportScreen({
    required this.completedWork,
    required this.pendingWork,
    required this.danger,
  });

  @override
  Widget build(BuildContext context) {
    int totalWork = completedWork + pendingWork;
    double efficiency = (completedWork / totalWork) * 100;
    String reportDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Report'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView to avoid overflow issues
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildReportCard(
                title: 'Completed Work',
                value: '$completedWork',
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildReportCard(
                title: 'Pending Work',
                value: '$pendingWork',
                icon: Icons.pending_actions,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              _buildReportCard(
                title: 'Total Work',
                value: '$totalWork',
                icon: Icons.work_outline,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildReportCard(
                title: 'Efficiency',
                value: '${efficiency.toStringAsFixed(2)}%',
                icon: Icons.show_chart,
                color: Colors.purple,
              ),
              const SizedBox(height: 16),
              _buildReportCard(
                title: 'Hazards',
                value: danger ? '⚠️ Danger Detected' : 'No Danger',
                icon: danger ? Icons.warning_amber_rounded : Icons.shield_outlined,
                color: danger ? Colors.red : Colors.green,
              ),
              const SizedBox(height: 16),
              _buildReportCard(
                title: 'Report Date',
                value: reportDate,
                icon: Icons.date_range,
                color: Colors.grey,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    onPressed: () => _createPDF(context),
                    label: const Text('Print PDF'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.share),
                    onPressed: () => _sharePDF(context),
                    label: const Text('Share PDF'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createPDF(BuildContext context) async {
    final pdf = _generatePDF();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> _sharePDF(BuildContext context) async {
    try {
      final pdf = _generatePDF();
      
      // Get the temporary directory path
      final output = await getTemporaryDirectory();
      final filePath = '${output.path}/report.pdf';
      
      // Create the PDF file
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      
      // Share the file
      await Share.shareFiles([filePath], text: 'Coal Mining Work Report');
      
    } catch (e) {
      // Show error in case of any issue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing PDF: $e')),
      );
    }
  }

  pw.Document _generatePDF() {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Coal Mining Work Report', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text('Completed Work: $completedWork', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Pending Work: $pendingWork', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Total Work: ${completedWork + pendingWork}', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Efficiency: ${(completedWork / (completedWork + pendingWork) * 100).toStringAsFixed(2)}%', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 20),
            pw.Text(
              danger ? '⚠️ Danger: Hazards detected!' : 'No dangers detected.',
              style: pw.TextStyle(fontSize: 18, color: danger ? PdfColors.red : PdfColors.green),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Report Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())}', style: pw.TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );

    return pdf;
  }
}
