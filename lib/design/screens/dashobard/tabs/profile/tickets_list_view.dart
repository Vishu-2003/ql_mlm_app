import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/core/models/models.dart';
import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/utils/utils.dart';
import 'ticket_list_controller.dart';

class TicketListView extends StatelessWidget {
  const TicketListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketsListController>(
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          appBar: const CAppBar(title: 'Tickets'),
          body: RefreshIndicator.adaptive(
            onRefresh: () => Future.sync(() => controller.pagingController.refresh()),
            child: CPagedListView<GetTicketModel>(
              bottomPadding: context.bottomPadding + 60,
              pagingController: controller.pagingController,
              itemBuilder: (BuildContext context, GetTicketModel ticket, int index) {
                return CCoreButton(
                  onPressed: () async {
                    await showCupertinoModalBottomSheet(
                      context: context,
                      barrierColor: getDialogBarrierColor,
                      builder: (context) {
                        return _TicketDetailsSheetWidget(ticket);
                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CText(
                            ticket.creation ?? na,
                            style: TextThemeX.text14.copyWith(color: getGrey1),
                          ),
                          CText(
                            ticket.status ?? na,
                            style: TextThemeX.text16.copyWith(color: ticket.getStatusColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CText(
                        ticket.subject ?? na,
                        style: TextThemeX.text16.copyWith(color: getColorWhiteBlack),
                      ),
                      const SizedBox(height: 10),
                      Html(
                        data: """${ticket.description}""",
                        style: {
                          "p": Style(margin: Margins.zero),
                          "pre": Style(margin: Margins.zero),
                          "strong": Style(margin: Margins.zero),
                          "blockquote": Style(margin: Margins.zero),
                          "ol": Style(margin: Margins.zero),
                          "body": Style(
                            color: getGrey1,
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                        },
                      ),
                      Divider(color: getOutlineColor, height: 30),
                    ],
                  ).defaultHorizontal,
                );
              },
            ),
          ),
          bottomNavigationBar: CFlatButton(
            onPressed: () {
              Get.toNamed(Routes.CREATE_TICKET)?.then((value) {
                if (value == true) controller.pagingController.refresh();
              });
            },
            text: "Create Ticket",
            textColor: getPrimaryColor,
            bgColor: Colors.transparent,
            border: Border.all(color: getPrimaryColor),
          ).bottomNavBarButton(context),
        );
      },
    );
  }
}

class _TicketDetailsSheetWidget extends StatelessWidget {
  final GetTicketModel ticket;
  const _TicketDetailsSheetWidget(this.ticket);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: getOutlineColor,
        child: SingleChildScrollView(
          physics: defaultScrollablePhysics,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Center(
                child: CText(
                  "Ticket Details",
                  style: TextThemeX.text16.copyWith(color: getColorWhiteBlack),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CText(
                    ticket.creation ?? na,
                    style: TextThemeX.text14.copyWith(color: getGrey1),
                  ),
                  CText(
                    ticket.status ?? na,
                    style: TextThemeX.text16.copyWith(color: ticket.getStatusColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CText(
                ticket.subject ?? na,
                style: TextThemeX.text16.copyWith(color: getColorWhiteBlack),
              ),
              const SizedBox(height: 6),
              Html(
                data: """${ticket.description}""",
                style: {
                  "p": Style(margin: Margins.zero),
                  "pre": Style(margin: Margins.zero),
                  "strong": Style(margin: Margins.zero),
                  "blockquote": Style(margin: Margins.zero),
                  "ol": Style(margin: Margins.zero),
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                },
              ),
              const SizedBox(height: 24),
              CFlatButton(
                text: "Done",
                onPressed: Get.back,
              ).paddingSymmetric(horizontal: 30),
              SizedBox(height: context.bottomPadding),
            ],
          ).defaultHorizontal,
        ),
      ),
    );
  }
}
