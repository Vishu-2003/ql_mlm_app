import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/models/models.dart';
import '/design/components/components.dart';
import '/utils/utils.dart';
import 'network_controller.dart';

class NetworkTab extends StatelessWidget {
  const NetworkTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NetworkController>(
      init: NetworkController(),
      builder: (controller) {
        return Scaffold(
          appBar: const CAppBar(title: "My Network"),
          body: controller.isLoading
              ? defaultLoader()
              : controller.sampleTree.children.isEmpty
                  ? RefreshIndicator.adaptive(
                      onRefresh: () => Future.sync(controller.init),
                      child: SingleChildScrollView(
                        physics: defaultScrollablePhysics,
                        child: Container(
                          height: Get.height - 200,
                          alignment: Alignment.center,
                          child: CText(
                            "No Downline !",
                            style: TextThemeX.text18.copyWith(
                              color: getColorWhiteBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: defaultScrollablePhysics,
                      child: SizedBox(
                        width: controller.dynamicWidth,
                        child: TreeView.simple(
                          shrinkWrap: true,
                          showRootNode: false,
                          focusToNewNode: true,
                          tree: controller.sampleTree,
                          physics: defaultScrollablePhysics,
                          expansionBehavior: ExpansionBehavior.scrollToLastChild,
                          expansionIndicatorBuilder: (context, node) =>
                              noExpansionIndicatorBuilder(context, node),
                          onItemTap: controller.onItemTap,
                          indentation: const Indentation(style: IndentStyle.roundJoint),
                          onTreeReady: (controllerValue) {
                            controller.treeViewController = controllerValue;
                          },
                          builder: (context, node) {
                            return PersonTile(node: node);
                          },
                        ),
                      ),
                    ).paddingAll(16),
        );
      },
    );
  }
}

class PersonTile extends StatelessWidget {
  final TreeNode<GetMemberTreeViewModel> node;

  const PersonTile({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (node.data?.hasChildren == true)
          Icon(
            node.isExpanded ? CupertinoIcons.minus_circle_fill : CupertinoIcons.plus_circle_fill,
            color: node.isExpanded ? grey1 : getPrimaryColor,
          )
        else
          const SizedBox(width: 24),
        const SizedBox(width: 10),
        selectIcon(AppIcons.user),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              node.data?.memberName ?? na,
              style: TextThemeX.text16.copyWith(color: white),
            ),
            Text(
              node.data?.name ?? na,
              style: TextThemeX.text12,
            ),
          ],
        ),
      ],
    ).paddingSymmetric(vertical: 10);
  }
}
