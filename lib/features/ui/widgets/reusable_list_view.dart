import 'package:flutter/material.dart';

class ReusableListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const ReusableListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.grey[200], // ★ リスト背景（薄い灰色）
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  color: Colors.white, // ★ セル背景（白）
                  child: itemBuilder(context, index),
                ),
                const Divider(height: 1), // ★ アンダーライン
              ],
            );
          },
        ),
      ),
    );
  }
}