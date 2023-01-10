import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_training/model/memo.dart';
import 'package:firebase_training/pages/memo_detail_page.dart';
import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});

  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  //List型のmemoListを作成。memoListの中にメモの情報を入れてListViewで表示できるようにしておく
  List<Memo> memoList = [];

//以下のコードを記述することで実際にFirebaseからデータを取得する
  Future<void> fetchMemo() async {
    final memoCollection = await FirebaseFirestore.instance
        .collection('memo')
        .get(); //FirebaseのMemoコレクションにアクセスするためのコード
    final docs = memoCollection.docs; //Memoコレクションのドキュメントにアクセスするためのコード
    //以下のコードで登録されているMemoコレクションのドキュメントの数だけ処理(データを取り出す)を行うようにする
    for (var doc in docs) {
      Memo fetchMemo = Memo(
        title: doc.data()['title'], //ドキュメントの中のタイトルを取り出すことができる
        detail: doc.data()['detail'], //ドキュメントの中の詳細を取り出すことができる
        createdDate: doc.data()['createdDate'], //ドキュメントの中の作成日時を取り出すことができる
      );
      //fetchMemoを15行目のmemoListに追加するためのコードを以下に記述する
      memoList.add(fetchMemo);
    }
    //以上の処理が完了したら画面の再描画をするために以下にsetStateを記述する(画面を更新する処理)
    setState(() {});
  }

  //initState関数はその中に書かれた(今回はfetchMemo)の処理を一度だけ実行する。実行のタイミングはウィジェットが作成された直後となる。
  @override
  void initState() {
    super.initState();
    fetchMemo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluter × Firebase'),
      ),
      body: ListView.builder(
        itemCount:
            memoList.length, //memoListの中にある要素の数だけ表示させたい場合は関数名+lengthを記述する
        itemBuilder: (context, index) {
          return ListTile(
            title:
                Text(memoList[index].title), //indexを使うことで順番の指定なくそのまま順番に表示してくれる
            //確認画面に遷移する記述を以下に書く
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemoDetailPage(memoList[
                      index]), //memoList[index]を挿入することでタップされたメモの情報を詳細ページに送ることができる
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
