import 'package:firebase_training/model/memo.dart';
import 'package:flutter/material.dart';

class MemoDetailPage extends StatelessWidget {
//top pageで取得しているメモの内容を遷移後のページに表示させる処理を以下に記述する 以下を記載することで詳細ページに取得しているメモの情報を送ってきてもらうことができる
  final Memo memo;
  const MemoDetailPage(this.memo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(memo.title), //top pageでタップされたメモのタイトルをAppBarに表示させる
      ),
      body: Center(
        //それぞれの要素を左右中央に配置する際に使う
        child: Column(
          //それぞれの要素を縦に配置する際に使う
          mainAxisAlignment: MainAxisAlignment.center, //それぞれの要素を上下中央に配置する際に使う
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Text(
              'メモ詳細',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              memo.detail,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
