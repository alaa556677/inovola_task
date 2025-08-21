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

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = 'This Month';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 8.h),
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
              )
            ),
            setHeightSpace(8),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }
////////////////////////////////////////////////////////////////////////////////
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
        DropdownButtonFormField2(
          value: selectedCategory,
          isExpanded: true,
          dropdownStyleData: DropdownStyleData(
              offset: const Offset(0, -5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.background,
              ),
              padding: EdgeInsets.zero
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
              constraints: BoxConstraints(maxHeight: 48.h),
              filled: true,
              fillColor: AppColors.background,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.transparent, width: .5)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.transparent, width: .5),
            ),
          ),
          items: [
            'This Month',
            'Last 7 Days',
            'Last 30 Days',
            'Custom Range',
          ].map((item) => DropdownMenuItem<String>(
            value: item,
            child: CustomTextWidget(text: item, fontSize: 14.sp, textOverflow: TextOverflow.ellipsis,),
          )).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value!;
            });
          },
        ),
      ],
    );
  }
////////////////////////////////////////////////////////////////////////////////
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
        SizedBox(
          height: 48.h,
          child: TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 14.sp,),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: TextStyle(fontSize: 14.sp,),
              prefixIcon: Icon(Icons.attach_money, size: 20.r,),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: EdgeInsetsDirectional.only(bottom: 20.h),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.transparent, width: .5)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent, width: .5),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Please enter a valid amount greater than 0';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
////////////////////////////////////////////////////////////////////////////////
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
            height: 48.h,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.background
            ),
            child: Row(
              children: [
                CustomTextWidget(
                  text: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  fontSize: 14.sp,
                ),
                const Spacer(),
                Icon(Icons.date_range_outlined, size: 22.r,),
              ],
            ),
          ),
        ),
      ],
    );
  }
////////////////////////////////////////////////////////////////////////////////
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
        DropdownButtonFormField2(
          value: selectedCategory,
          isExpanded: true,
          dropdownStyleData: DropdownStyleData(
              offset: const Offset(0, -5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.background,
              ),
              padding: EdgeInsets.zero
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
            constraints: BoxConstraints(maxHeight: 48.h),
            filled: true,
            fillColor: AppColors.background,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.transparent, width: .5)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.transparent, width: .5),
            ),
          ),
          items: [
            'This Month',
            'Last 7 Days',
            'Last 30 Days',
            'Custom Range',
          ].map((item) => DropdownMenuItem<String>(
            value: item,
            child: CustomTextWidget(text: item, fontSize: 14.sp, textOverflow: TextOverflow.ellipsis,),
          )).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value!;
            });
          },
        ),
      ],
    );
  }
////////////////////////////////////////////////////////////////////////////////
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
            height: 48.h,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.background
            ),
            child: Row(
              children: [
                Icon(
                  _receiptPath != null ? Icons.image : Icons.add_a_photo,
                  color: AppColors.primary,
                  size: 22.r,
                ),
                setWidthSpace(12),
                CustomTextWidget(
                  text: _receiptPath != null ? 'Receipt added' : 'Add receipt photo',
                  fontSize: 14.sp,
                  fontColor: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
////////////////////////////////////////////////////////////////////////////////
  Widget _buildCategoryGridView(){
    int length = 6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          text: 'Categories',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontColor: AppColors.textPrimary,
        ),
        setHeightSpace(10),
        MasonryGridView.extent(
          maxCrossAxisExtent: 80.w,
          mainAxisSpacing: 12.w,
          crossAxisSpacing: 12.h,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: length + 1,
          itemBuilder: (context, index){
            if(index == length){
              return const AddCategoryWidget();
            }else{
              return const CategoryWidget();
            }
          },
        ),
      ],
    );
  }
////////////////////////////////////////////////////////////////////////////////
  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 8.h),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveExpense,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ):CustomTextWidget(
            text: 'Save',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            fontColor: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
////////////////////////////////////////////////////////////////////////////////
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

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);

      // TODO: Convert amount to USD using currency service
      final amountUSD = amount; // Placeholder conversion

      // final expense = Expense(
      //   id: DateTime.now().millisecondsSinceEpoch.toString(),
      //   category: _selectedCategory,
      //   amountOriginal: amount,
      //   amountUSD: amountUSD,
      //   currency: _selectedCurrency,
      //   date: _selectedDate,
      //   receiptPath: _receiptPath,
      //   notes: _notesController.text.isEmpty ? null : _notesController.text,
      //   createdAt: DateTime.now(),
      //   updatedAt: DateTime.now(),
      // );
      //
      // context.read<ExpenseBloc>().add(AddExpense(expense));

      // Navigate back after successful save
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving expense: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
