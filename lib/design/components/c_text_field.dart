import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:qm_mlm_flutter/core/models/models.dart';
import 'package:qm_mlm_flutter/design/components/components.dart';
import 'package:qm_mlm_flutter/design/screens/init_controller.dart';
import 'package:qm_mlm_flutter/design/screens/translation_controller.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

class CTextField extends StatelessWidget {
  final int? maxLength;
  final bool showBorders;
  final Key? formFieldKey;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final String? labelText;
  final String? hintText;
  final double? fontSize;
  final int? maxLines;
  final TextAlign textAlign;
  final int? minLines;
  final Color? fillColor;
  final Color? textColor;
  final String? helperText;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? suffixText;
  final EdgeInsets? contentPadding;
  final void Function()? onTap;
  final Color? hintTextColor;
  final void Function(String)? onSubmit;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final List<TextInputFormatter>? inputFormatters;

  const CTextField({
    Key? key,
    this.maxLength,
    this.formFieldKey,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.showBorders = true,
    this.labelText,
    this.hintText,
    this.helperText,
    this.fontSize,
    this.maxLines = 1,
    this.minLines = 1,
    this.focusNode,
    this.onTap,
    this.fillColor,
    this.onSubmit,
    this.textColor,
    this.onChanged,
    this.suffixText,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.controller,
    this.validator,
    this.keyboardType,
    this.hintTextColor,
    this.floatingLabelBehavior,
    this.textAlign = TextAlign.start,
    this.textInputAction = TextInputAction.next,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
  }) : super(key: key);

  static FilteringTextInputFormatter get decimalFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'));

  static OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(width: 1, color: getPrimaryColor),
  );

  static OutlineInputBorder disabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(width: 1, color: getdarkGColor),
  );

  static OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(width: 1, color: getOutlineColor),
  );

  static OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(width: 1, color: lightRed),
  );

  static OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(width: 1, color: lightRed.withOpacity(.5)),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      key: formFieldKey,
      enabled: enabled,
      cursorHeight: 20,
      autocorrect: false,
      minLines: minLines,
      readOnly: readOnly,
      maxLines: maxLines,
      textAlign: textAlign,
      focusNode: focusNode,
      validator: validator,
      maxLength: maxLength,
      controller: controller,
      obscureText: obscureText,
      onFieldSubmitted: onSubmit,
      keyboardType: keyboardType,
      cursorColor: getPrimaryColor,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: TextThemeX.text16.copyWith(fontSize: fontSize, color: textColor ?? getColorWhiteBlack),
      decoration: InputDecoration(
        isDense: true,
        errorMaxLines: 2,
        hintText: hintText,
        labelText: labelText,
        floatingLabelBehavior: floatingLabelBehavior,
        hintStyle: TextThemeX.text14.copyWith(fontSize: fontSize, color: hintTextColor ?? getGrey1),
        labelStyle:
            TextThemeX.text14.copyWith(fontSize: fontSize, color: hintTextColor ?? getGrey1),
        filled: true,
        helperMaxLines: 3,
        fillColor: fillColor ?? getBgColor,
        border: showBorders ? focusedBorder : InputBorder.none,
        errorBorder: showBorders ? errorBorder : InputBorder.none,
        enabledBorder: showBorders ? enabledBorder : InputBorder.none,
        focusedBorder: showBorders ? focusedBorder : InputBorder.none,
        disabledBorder: showBorders ? disabledBorder : InputBorder.none,
        focusedErrorBorder: showBorders ? focusedErrorBorder : InputBorder.none,
        suffixStyle: TextThemeX.text16.copyWith(color: getGrey1),
        helperStyle: TextThemeX.text12.copyWith(color: getPrimaryColor),
      ),
    );
  }
}

// ignore: must_be_immutable
class CDatePickerField extends StatefulWidget {
  final bool isRequired;
  final String? labelText;
  final DateTime? lastDate;
  final DateTime? firstDate;
  DateTime? initialDate;
  final void Function(DateTime? date)? onDateSelected;
  CDatePickerField({
    super.key,
    this.initialDate,
    this.isRequired = true,
    this.onDateSelected,
    this.labelText,
    this.lastDate,
    this.firstDate,
  });

  @override
  State<CDatePickerField> createState() => _CDatePickerFieldState();
}

class _CDatePickerFieldState extends State<CDatePickerField> {
  @override
  Widget build(BuildContext context) {
    return CTextField(
      maxLines: 1,
      readOnly: true,
      suffixIcon: widget.initialDate == null
          ? selectIcon(AppIcons.calendar)
          : CCoreButton(
              onPressed: () {
                setState(() {
                  widget.initialDate = null;
                  widget.onDateSelected?.call(null);
                  FocusScope.of(context).unfocus();
                });
              },
              child: Icon(CupertinoIcons.clear_circled, color: getGrey1),
            ),
      labelText: widget.labelText ?? TranslationController.td.selectDate,
      validator: widget.isRequired ? AppValidator.emptyNullValidator : null,
      controller: TextEditingController(text: widget.initialDate?.getDefaultDateFormat),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: widget.initialDate,
          firstDate: widget.firstDate ?? DateTime(1900),
          lastDate: widget.lastDate ?? DateTime.now().add(const Duration(days: 2200)),
        );
        if (pickedDate != null) {
          setState(() {
            widget.initialDate = pickedDate;
            widget.onDateSelected?.call(pickedDate);
          });
        }
      },
    );
  }
}

class CSelectionSheetField extends StatelessWidget {
  final bool isRequired;
  final String? labelText;
  final String? sheetTitle;
  final List<SelectionSheetItem> items;
  final TextEditingController controller;
  final List<SelectionSheetItem> selectedItems;
  final Function(SelectionSheetItem?)? onSelected;

  const CSelectionSheetField({
    super.key,
    this.labelText,
    this.sheetTitle,
    this.onSelected,
    required this.items,
    this.isRequired = true,
    required this.controller,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    return CTextField(
      readOnly: true,
      onTap: () async {
        await showCupertinoModalBottomSheet(
          context: context,
          barrierColor: getDialogBarrierColor,
          builder: (context) {
            return CSelectionSheet(
              items: items,
              onSelected: onSelected,
              selectedItems: selectedItems,
              sheetTitle: sheetTitle ?? TranslationController.td.select,
            );
          },
        );
      },
      controller: controller,
      suffixIcon: selectIcon(AppIcons.arrowDown),
      labelText: labelText ?? TranslationController.td.select,
      validator: isRequired ? AppValidator.emptyNullValidator : null,
    );
  }
}

// ignore: must_be_immutable
class CSelectRangeDate extends StatefulWidget {
  final bool showTextField;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final String? labelText;
  final String? hintText;
  DateTimeRange? selectedDateRange;
  void Function(DateTimeRange?)? onDateRangeChanged;

  CSelectRangeDate({
    Key? key,
    this.hintText,
    this.labelText,
    this.lastDate,
    this.firstDate,
    this.selectedDateRange,
    this.onDateRangeChanged,
    this.showTextField = true,
  }) : super(key: key);

  @override
  State<CSelectRangeDate> createState() => _CSelectRangeDateState();
}

class _CSelectRangeDateState extends State<CSelectRangeDate> {
  @override
  void initState() {
    super.initState();
    widget.selectedDateRange = widget.selectedDateRange;
  }

  Future<void> onTap() async {
    final DateTimeRange? selectedDateRange = await showDateRangePicker(
      context: context,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2200),
      initialDateRange: widget.selectedDateRange,
    );
    if (selectedDateRange != null) {
      setState(() {
        widget.selectedDateRange = selectedDateRange;
        if (widget.onDateRangeChanged != null) {
          widget.onDateRangeChanged!(selectedDateRange);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.showTextField
        ? CTextField(
            maxLines: 1,
            onTap: onTap,
            readOnly: true,
            hintText: widget.hintText,
            suffixIcon: widget.selectedDateRange == null
                ? selectIcon(AppIcons.calendar)
                : CCoreButton(
                    onPressed: () {
                      widget.onDateRangeChanged!(null);
                      FocusScope.of(context).unfocus();
                    },
                    child: Icon(CupertinoIcons.clear_circled, color: getGrey1),
                  ),
            validator: AppValidator.emptyNullValidator,
            controller: TextEditingController(
              text: widget.selectedDateRange == null
                  ? ""
                  : "${widget.selectedDateRange?.start.getDefaultDateFormat} to ${widget.selectedDateRange?.end.getDefaultDateFormat}",
            ),
            labelText: widget.labelText ?? TranslationController.td.select,
          )
        : widget.selectedDateRange == null
            ? selectIcon(
                AppIcons.calendar,
                onPressed: onTap,
              ).defaultContainer(vP: 13, hP: 13, hM: 0)
            : CCoreButton(
                onPressed: () {
                  widget.onDateRangeChanged!(null);
                },
                child: Icon(CupertinoIcons.clear_circled, color: getGrey1)
                    .defaultContainer(vP: 13, hP: 13, hM: 0),
              );
  }
}

// ignore: must_be_immutable
class CPullDownButton<T> extends StatefulWidget {
  final String? hint;
  final String? icon;
  final String? helperText;
  final PullDownMenuPosition position;
  ({String? item, T? data})? selectedItem;
  final List<({String item, T data})> items;
  final void Function(({String item, T data})) onChanged;

  CPullDownButton({
    super.key,
    this.icon,
    this.hint,
    this.helperText,
    this.selectedItem,
    required this.items,
    required this.onChanged,
    this.position = PullDownMenuPosition.automatic,
  });
  @override
  State<CPullDownButton<T>> createState() => _CPullDownButtonState<T>();
}

class _CPullDownButtonState<T> extends State<CPullDownButton<T>> {
  @override
  Widget build(BuildContext context) {
    return PullDownButton(
      position: widget.position,
      buttonAnchor: PullDownMenuAnchor.start,
      scrollController: ScrollController(),
      itemBuilder: (context) => widget.items
          .map(
            (item) => PullDownMenuItem.selectable(
              selected: item == widget.selectedItem,
              onTap: () {
                setState(() {
                  widget.selectedItem = item;
                  widget.onChanged(item);
                });
              },
              title: item.item,
            ),
          )
          .toList(),
      buttonBuilder: (context, showMenu) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CTextField(
            readOnly: true,
            onTap: showMenu,
            helperText: widget.helperText,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: AppValidator.emptyNullValidator,
            labelText: widget.hint ?? TranslationController.td.select,
            controller: TextEditingController(text: widget.selectedItem?.item),
            suffixIcon: Icon(CupertinoIcons.chevron_up_chevron_down, color: getGrey1),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CMobileTextField extends StatelessWidget {
  GetCountryCodeModel? selectedCountryCode;
  final TextEditingController controller;
  final void Function(GetCountryCodeModel value) onCountryCodeChanged;

  CMobileTextField({
    Key? key,
    required this.controller,
    this.selectedCountryCode,
    required this.onCountryCodeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CTextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      validator: AppValidator.emptyNullValidator,
      labelText: TranslationController.td.mobileNumber,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      prefixIcon: GetBuilder<InitController>(
        builder: (controller) {
          return PullDownButton(
            scrollController: ScrollController(),
            itemBuilder: (context) => controller.countryCodes
                .map(
                  (countryCode) => PullDownMenuItem.selectable(
                    onTap: () => onCountryCodeChanged(countryCode),
                    selected: countryCode == selectedCountryCode,
                    title: "(${countryCode.code}) ${countryCode.country}",
                  ),
                )
                .toList(),
            buttonBuilder: (context, showMenu) => CCoreButton(
              onPressed: showMenu,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CText("${selectedCountryCode?.code}"),
                  const SizedBox(width: 6),
                  selectIcon(AppIcons.arrowDown, color: getPrimaryColor),
                ],
              ).paddingSymmetric(horizontal: 10),
            ),
          );
        },
      ),
    );
  }
}
