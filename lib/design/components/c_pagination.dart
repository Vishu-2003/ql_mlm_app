import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qm_mlm_flutter/design/components/c_text.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

class CPagedChildBuilderDelegate<T> extends PagedChildBuilderDelegate<T> {
  CPagedChildBuilderDelegate({
    String? noItemFoundMessage,
    required Widget Function(BuildContext, T, int) itemBuilder,
    Widget Function(BuildContext)? noItemsFoundIndicatorBuilder,
  }) : super(
          itemBuilder: itemBuilder,
          noMoreItemsIndicatorBuilder: (ctx) => Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: CText(
                "That's all you got.",
                style: TextThemeX.text14
                    .copyWith(fontWeight: FontWeight.bold, color: getColorWhiteBlack),
              ),
            ),
          ),
          noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder ??
              (ctx) => Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: CText(
                        noItemFoundMessage ?? "No Data Found !",
                        style: TextThemeX.text18.copyWith(
                          color: getColorWhiteBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          newPageProgressIndicatorBuilder: (_) => defaultLoader(),
          firstPageProgressIndicatorBuilder: (_) => defaultLoader(),
        );
}

class CPagedListView<T> extends StatelessWidget {
  final bool shrinkWrap;
  final double topPadding;
  final double? bottomPadding;
  final String? noItemFoundMessage;
  final ScrollController? scrollController;
  final PagingController<int, T> pagingController;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const CPagedListView({
    super.key,
    this.shrinkWrap = true,
    required this.pagingController,
    required this.itemBuilder,
    this.noItemFoundMessage,
    this.scrollController,
    this.topPadding = 24,
    this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, T>(
      physics: defaultScrollablePhysics,
      pagingController: pagingController,
      scrollController: scrollController,
      padding:
          EdgeInsets.only(top: topPadding, bottom: bottomPadding ?? context.bottomPadding + 20),
      builderDelegate: CPagedChildBuilderDelegate(
        itemBuilder: itemBuilder,
        noItemFoundMessage: noItemFoundMessage,
      ),
    );
  }
}

Future<void> fetchPage<T>({
  int pageSize = 20,
  required int pageKey,
  required Future<List<T>> apiCall,
  required PagingController<int, T> pagingController,
}) async {
  try {
    List<T> newEntries = await apiCall;
    final bool isLastPage = newEntries.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(newEntries);
    } else {
      final nextPageKey = newEntries.length + (pagingController.value.itemList?.length ?? 0);
      pagingController.appendPage(newEntries, nextPageKey);
    }
  } catch (error) {
    pagingController.error = error;
  }
}
