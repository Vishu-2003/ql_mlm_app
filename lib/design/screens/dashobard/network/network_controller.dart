import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/core/services/gs_services.dart';

class NetworkController extends GetxController {
  TreeViewController? treeViewController;
  final HomeRepository _homeRepository = Get.find<HomeRepository>();
  TreeNode<GetMemberTreeViewModel> sampleTree = TreeNode<GetMemberTreeViewModel>.root();

  String selectedKey = '';
  double dynamicWidth = Get.width;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    final List<GetMemberTreeViewModel> response =
        await _homeRepository.getMemberChild(sponser: GSServices.getUser?.memberId);
    if (response.isNotEmpty) {
      sampleTree = TreeNode.root()
        ..addAll([...response.map((e) => TreeNode(key: e.name, data: e)).toList()]);
    }
    isLoading = false;
    update();
  }

  void onItemTap(TreeNode<GetMemberTreeViewModel> item) async {
    // if (item.length > 0) {
    //   if (selectedKey != item.key) {
    //     dynamicWidth += 20; //each node 20 width increase
    //   }
    //   selectedKey = item.key;
    // }

    if (item.children.isEmpty) {
      final List<GetMemberTreeViewModel> response =
          await _homeRepository.getMemberChild(sponser: item.data?.name);
      if (response.isNotEmpty) {
        item.addAll([...response.map((e) => TreeNode(key: e.name, data: e)).toList()]);
      } else {
        item.data?.hasChildren = false;
      }
    }
    treeViewController?.expandNode(item);
    update();
  }
}
