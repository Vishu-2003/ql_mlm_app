import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qm_mlm_flutter/design/components/c_app_buttons.dart';
import 'package:qm_mlm_flutter/design/components/c_text.dart';
import 'package:qm_mlm_flutter/design/screens/translation_controller.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

class CSelectionSheet extends StatefulWidget {
  final bool multiSelect;
  final String? sheetTitle;
  final List<SelectionSheetItem> items;
  final List<SelectionSheetItem> selectedItems;
  final Function(SelectionSheetItem? item)? onSelected;
  final Function(List<SelectionSheetItem> item)? onMultiItemSelected;

  const CSelectionSheet({
    Key? key,
    this.sheetTitle,
    required this.items,
    this.onSelected,
    this.multiSelect = false,
    required this.selectedItems,
    this.onMultiItemSelected,
  }) : super(key: key);

  @override
  State<CSelectionSheet> createState() => _CSelectionSheetState();
}

class _CSelectionSheetState extends State<CSelectionSheet> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: searchController,
          builder: (context, value, _) {
            List<SelectionSheetItem> filteredItems = widget.items
                .where((item) =>
                    (item.title?.toLowerCase().contains(value.text.toLowerCase()) ?? false) ||
                    (item.subtitle?.toLowerCase().contains(value.text.toLowerCase()) ?? false) ||
                    (item.id?.toLowerCase().contains(value.text.toLowerCase()) ?? false))
                .toList();

            return filteredItems.isEmpty
                ? noDataAvailableCard(height: 72)
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    physics: neverScrollablePhysics,
                    itemBuilder: (context, index) {
                      final String title = filteredItems[index].title ?? '';
                      final String subtitle = filteredItems[index].subtitle ?? '';
                      final bool isSelected = widget.selectedItems.contains(filteredItems[index]);
                      return CCoreButton(
                        onPressed: () {
                          setState(() {
                            if (!widget.multiSelect) {
                              widget.selectedItems.clear();
                            }

                            widget.selectedItems.contains(filteredItems[index])
                                ? widget.selectedItems.remove(filteredItems[index])
                                : widget.selectedItems.add(filteredItems[index]);

                            if (widget.onSelected != null) {
                              widget.onSelected!(filteredItems[index]);
                            }

                            if (widget.onMultiItemSelected != null) {
                              widget.onMultiItemSelected!(widget.selectedItems);
                            }

                            // we immidiaetly close the sheet if only one item is supposed to be selected
                            if (!widget.multiSelect) {
                              Navigator.pop(context);
                            }
                            FocusScope.of(context).unfocus();
                          });
                        },
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            widget.multiSelect
                                ? Icon(
                                    isSelected
                                        ? CupertinoIcons.checkmark_square_fill
                                        : CupertinoIcons.square,
                                    size: 20,
                                    color: getdarkGColor,
                                  )
                                : Icon(
                                    isSelected
                                        ? CupertinoIcons.largecircle_fill_circle
                                        : CupertinoIcons.circle,
                                    size: 20,
                                    color: getdarkGColor,
                                  ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CText(
                                    title,
                                    style: TextThemeX.text14.copyWith(
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.visible,
                                      color: getdarkGColor,
                                    ),
                                  ),
                                  if (!isNullEmptyOrFalse(subtitle))
                                    CText(
                                      subtitle,
                                      style: TextThemeX.text14.copyWith(
                                        fontSize: 9,
                                        color: getdarkGColor,
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(color: getOutlineColor, indent: 30);
                    },
                  );
          },
        ),
      ],
    ).prepareBottomSheet(
      context: context,
      controller: searchController,
      title: widget.sheetTitle ?? TranslationController.td.select,
      trailing: CCoreButton(
        onPressed: () {
          widget.onSelected?.call(null);
          widget.onMultiItemSelected?.call([]);
          Navigator.pop(context);
          FocusScope.of(context).unfocus();
        },
        child: CText(
          "Clear",
          style: TextThemeX.text16.copyWith(
            color: lightRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SelectionSheetItem {
  final String? id;
  final String? title;
  final String? subtitle;

  SelectionSheetItem({
    this.id,
    this.title,
    this.subtitle,
  });

  SelectionSheetItem copyWith({
    String? id,
    String? title,
    String? image,
    String? subtitle,
  }) {
    return SelectionSheetItem(
      id: id ?? id,
      title: title ?? this.title,
      subtitle: subtitle ?? subtitle,
    );
  }

  @override
  String toString() {
    return 'SelectionSheetItem(id: $id, title: $title,subtitle: $subtitle)';
  }

  @override
  bool operator ==(covariant SelectionSheetItem other) {
    if (identical(this, other)) return true;

    return other.id == id && other.title == title && other.subtitle == subtitle;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ subtitle.hashCode;
  }
}
