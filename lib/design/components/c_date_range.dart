import 'package:flutter/material.dart';
import 'package:qm_mlm_flutter/design/components/c_text_field.dart';

// ignore: must_be_immutable
class CSelectDateRange extends StatefulWidget {
  DateTime? initialToDate;
  DateTime? initialFromDate;
  final Function(DateTime?)? onFromDateChanged;
  final Function(DateTime?)? onToDateChanged;

  CSelectDateRange({
    super.key,
    this.initialFromDate,
    this.initialToDate,
    this.onFromDateChanged,
    this.onToDateChanged,
  });

  @override
  State<CSelectDateRange> createState() => _CSelectDateRangeState();
}

class _CSelectDateRangeState extends State<CSelectDateRange> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CDatePickerField(
            labelText: "From Date",
            initialDate: widget.initialFromDate,
            onDateSelected: (date) {
              setState(() {
                widget.initialFromDate = date;
                widget.onFromDateChanged?.call(date);
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CDatePickerField(
            labelText: "To Date",
            initialDate: widget.initialToDate,
            onDateSelected: (date) {
              setState(() {
                widget.initialToDate = date;
                widget.onToDateChanged?.call(date);
              });
            },
          ),
        ),
      ],
    );
  }
}
