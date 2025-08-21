import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inovola_task/core/widgets/set_height_width.dart';
import 'package:inovola_task/core/widgets/text_default.dart';
import '../../../../core/style/colors.dart';
import '../widgets/category_widget.dart';
import '../bloc/expense_bloc.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = 'Food & Dining';
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCurrency = 'USD';
  DateTime _selectedDate = DateTime.now();
  String? _receiptPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Expense saved successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          // Return true to indicate successful save
          Navigator.pop(context, true);
        } else if (state is ExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: CustomTextWidget(
            text: 'Add Expense',
            fontSize: 22.sp,
            fontColor: AppColors.blackColor,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16.w, vertical: 8.h),
                child: Column(
                  children: [
                    _buildCategorySection(),
                    setHeightSpace(16),
                    _buildAmountSection(),
                    setHeightSpace(16),
                    _buildDateSection(),
                    setHeightSpace(16),
                    _buildCurrencySection(),
                    setHeightSpace(16),
                    _buildReceiptSection(),
                    setHeightSpace(16),
                    _buildCategoryGridView()
                  ],
                ),
              )),
              setHeightSpace(8),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          text: 'Category',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontColor: AppColors.textPrimary,
        ),
        setHeightSpace(8),
        DropdownButtonFormField2<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          value: selectedCategory,
          items: [
            'Food & Dining',
            'Transportation',
            'Shopping',
            'Entertainment',
            'Healthcare',
            'Utilities',
            'Housing',
            'Other'
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          text: 'Amount',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontColor: AppColors.textPrimary,
        ),
        setHeightSpace(8),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            hintText: '0.00',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid amount';
            }
            if (double.parse(value) <= 0) {
              return 'Amount must be greater than 0';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          text: 'Date',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontColor: AppColors.textPrimary,
        ),
        setHeightSpace(8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: TextStyle(fontSize: 16.sp),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          text: 'Currency',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontColor: AppColors.textPrimary,
        ),
        setHeightSpace(8),
        DropdownButtonFormField2<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          value: _selectedCurrency,
          items: [
            'USD',
            'EUR',
            'GBP',
            'JPY',
            'CAD',
            'AUD',
            'CHF',
            'CNY',
            'INR',
            'BRL'
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCurrency = newValue!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildReceiptSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          text: 'Receipt (Optional)',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontColor: AppColors.textPrimary,
        ),
        setHeightSpace(8),
        InkWell(
          onTap: _pickImage,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.attach_file, color: AppColors.primary),
                setWidthSpace(8),
                Text(
                  _receiptPath != null
                      ? 'Receipt selected'
                      : 'Select receipt image',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGridView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          text: 'Quick Categories',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontColor: AppColors.textPrimary,
        ),
        setHeightSpace(8),
        StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            'Food',
            'Transport',
            'Shopping',
            'Entertainment',
            'Health',
            'Bills',
            'Home',
            'Other'
          ].map((category) => CategoryWidget(
                    category: category,
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        final isLoading = state is ExpenseLoading;

        return Padding(
          padding: EdgeInsets.all(16.w),
          child: SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : _saveExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : CustomTextWidget(
                      text: 'Save',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontColor: AppColors.whiteColor,
                    ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _receiptPath = pickedFile.path;
      });
    }
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);

    context.read<ExpenseBloc>().add(AddExpense(
          category: selectedCategory,
          amount: amount,
          currency: _selectedCurrency,
          date: _selectedDate,
          receiptPath: _receiptPath,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          type: 'expense',
        ));
  }
}
