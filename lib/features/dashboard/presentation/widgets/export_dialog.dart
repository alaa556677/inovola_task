import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/services/export_service.dart';
import 'package:inovola_task/core/widgets/text_default.dart';
import 'package:inovola_task/core/widgets/set_height_width.dart';
import 'package:inovola_task/core/style/colors.dart';
import 'package:open_file/open_file.dart';

import '../../../add_expense/domain/entities/expense_entity.dart';

class ExportDialog extends StatefulWidget {
  final List<ExpenseEntity> expenses;
  final String filterType;
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;

  const ExportDialog({
    super.key,
    required this.expenses,
    required this.filterType,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
  });

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  bool _isExporting = false;
  String? _exportStatus;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.file_download,
                  color: AppColors.primaryColor,
                  size: 24.sp,
                ),
                setWidthSpace(12),
                Expanded(
                  child: CustomTextWidget(
                    text: 'Export Expenses',
                    fontSize: 20.sp,
                    fontColor: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    size: 20.sp,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
            setHeightSpace(20),

            // Export options
            if (!_isExporting) ...[
              _buildExportOption(
                icon: Icons.picture_as_pdf,
                title: 'Export as PDF',
                subtitle: 'Professional report with summary and table',
                onTap: () => _exportToPDF(),
              ),
              setHeightSpace(16),
              _buildExportOption(
                icon: Icons.table_chart,
                title: 'Export as CSV',
                subtitle: 'Spreadsheet format for data analysis',
                onTap: () => _exportToCSV(),
              ),
            ] else ...[
              // Loading state
              Column(
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                  setHeightSpace(16),
                  CustomTextWidget(
                    text: _exportStatus ?? 'Preparing export...',
                    fontSize: 14.sp,
                    fontColor: AppColors.greyColor,
                  ),
                ],
              ),
            ],

            setHeightSpace(20),

            // Info text
            if (!_isExporting)
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.lightGreyColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16.sp,
                      color: AppColors.greyColor,
                    ),
                    setWidthSpace(8),
                    Expanded(
                      child: CustomTextWidget(
                        text: 'Files will be saved to your device and can be shared or opened with other apps.',
                        fontSize: 12.sp,
                        fontColor: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGreyColor),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 24.sp,
              ),
            ),
            setWidthSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: title,
                    fontSize: 16.sp,
                    fontColor: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                  setHeightSpace(4),
                  CustomTextWidget(
                    text: subtitle,
                    fontSize: 12.sp,
                    fontColor: AppColors.greyColor,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.greyColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToPDF() async {
    setState(() {
      _isExporting = true;
      _exportStatus = 'Generating PDF...';
    });

    try {
      final file = await ExportService.exportToPDF(
        expenses: widget.expenses,
        filterType: widget.filterType,
        totalBalance: widget.totalBalance,
        totalIncome: widget.totalIncome,
        totalExpenses: widget.totalExpenses,
      );

      if (file != null) {
        setState(() {
          _exportStatus = 'Opening PDF...';
        });

        await OpenFile.open(file.path);
        
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF exported successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        throw Exception('Failed to generate PDF');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isExporting = false;
          _exportStatus = null;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export PDF: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _exportToCSV() async {
    setState(() {
      _isExporting = true;
      _exportStatus = 'Generating CSV...';
    });

    try {
      final file = await ExportService.exportToCSV(
        expenses: widget.expenses,
        filterType: widget.filterType,
      );

      if (file != null) {
        setState(() {
          _exportStatus = 'Opening CSV...';
        });

        await OpenFile.open(file.path);
        
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('CSV exported successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        throw Exception('Failed to generate CSV');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isExporting = false;
          _exportStatus = null;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export CSV: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
