import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../models/jewellery.dart';
import '../repository/jewellery_repository.dart';

class DemoView extends StatefulWidget {
  const DemoView({super.key});

  @override
  State<DemoView> createState() => _DemoViewState();
}

class _DemoViewState extends State<DemoView> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(animateToTab);
    super.initState();
  }


  ///Scroll to index
  Future<void> scrollToIndex(int index) async {
    scrollController.removeListener(animateToTab);
    final categories = jewelleryCategories[index].currentContext!;
    await Scrollable.ensureVisible(
      categories,
      duration: const Duration(milliseconds: 600),
    );
    scrollController.addListener(animateToTab);
  }

  BuildContext? tabContext;

  final List<GlobalKey> jewelleryCategories = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  ///Animate to tab
  void animateToTab(){
    late RenderBox box;

    for(var i=0;i<jewelleryCategories.length; i++){
      box = jewelleryCategories[i].currentContext!.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);
      if(scrollController.offset>= position.dy){
        DefaultTabController.of(tabContext!).animateTo(i,duration: const Duration(microseconds: 500));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context){
          tabContext = context;
          return Scaffold(
            appBar: _buildAppBar(),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  _buildCategoryTitle('Tin Tức', 0),
                  _buildItemList(JewelleryRepository.news),
                  _buildCategoryTitle('Áo đấu', 1),
                  _buildItemList(JewelleryRepository.clubJersey),
                  _buildCategoryTitle('Cầu thủ', 2),
                  _buildItemList(JewelleryRepository.Player),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ///Appbar
  AppBar _buildAppBar(){
    return AppBar(
      leading: IconButton(
        onPressed: (){},
        icon: const Icon(Remix.menu_2_line),
      ),
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Remix.search_line)),

      ],
      title: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Trương Nguyễn Quang Thái',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              'Scroll Demo',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      ),
      bottom: TabBar(
        tabs: const [
          Tab(
            child: Text('Tin tức'),
          ),
          Tab(
            child: Text('Áo đấu'),
          ),
          Tab(
            child: Text('Cầu thủ'),
          )
        ],
        onTap: (int index) => scrollToIndex(index),
      ),
    );
  }

  ///Category title
  Widget _buildCategoryTitle(String title, int index){
    return Padding(
      key: jewelleryCategories[index],
        padding: const EdgeInsets.only(top: 14, right: 12, left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Xem thêm',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.indigo),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildItemList(List<JewelleryModel> categories) {
    return Column(
      children: categories.map((m3) => _buildSingleItem(m3)).toList(),
    );
  }
  /// Single Product item widget
  Widget _buildSingleItem(JewelleryModel item) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${item.price}",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const Icon(Remix.arrow_right_s_line)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}