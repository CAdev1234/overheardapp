import 'package:flutter/cupertino.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;

  _AZItem({required this.title, required this.tag});

  @override
  String getSuspensionTag() => tag;

}

class AlphabetScrollList extends StatefulWidget {
  List<String> items;
  // late ValueChanged<String> onClickedItem;
  AlphabetScrollList({
    Key? key, 
    required this.items,
    // required this.onClickedItem 
  }): super(key: key);

  @override
  _AlphabetScrollListState createState() => _AlphabetScrollListState(); 
}

class _AlphabetScrollListState extends State<AlphabetScrollList> {
  List<_AZItem> items = [];
  @override
  void initState() {
    super.initState();
    initList(widget.items);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initList(List<String> items) {
    this.items = items.map((item) => _AZItem(title: item, tag: item[0].toUpperCase())).toList();
    SuspensionUtil.sortListBySuspensionTag(this.items);
    SuspensionUtil.setShowSuspensionStatus(this.items);
  }

  
  @override
  Widget build(BuildContext context) => AzListView(
    data: items, 
    itemCount: items.length,
    indexBarOptions: const IndexBarOptions(
      needRebuild: true,
      textStyle: TextStyle(color: primaryWhiteTextColor),
      selectTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold
      ),
      selectItemDecoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue
      ),
      indexHintAlignment: Alignment.centerRight,
      indexHintOffset: Offset(-20, 0),
    ),
    indexBarMargin: const EdgeInsets.only(right: 10),
    indexBarItemHeight: 18,
    indexHintBuilder: (context, hint) => CircleAvatar(
      radius: 25,
      backgroundColor: Colors.blue,
      child: Text(
        hint,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ),
    itemBuilder: (context, idx) {
      final item = items[idx];
      return _buildListItem(item, idx);
    }
  );

  Widget _buildListItem(_AZItem item, int idx) {
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    return Column(
      children: [
        idx != 0 ? const Divider(height: 1, color: primaryWhiteTextColor) : const SizedBox.shrink(),
        Offstage(offstage: offstage, child: _buildHeaderTag(tag, idx)),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: primaryWhiteTextColor,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        item.title,
                        style: const TextStyle(color: primaryWhiteTextColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                    
                  ],
                ),
              ) 
            )
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderTag(String tag, int idx) => Column(
    children: [
      idx == 0 ? const SizedBox.shrink() : const SizedBox(height: 20),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          tag,
          style: const TextStyle(color: primaryWhiteTextColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      )
    ],
  ); 
}


