import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_training/model/memo.dart';
import 'package:firebase_training/pages/add_edit_memo_page.dart';
import 'package:firebase_training/pages/memo_detail_page.dart';
import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});

  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final memoCollection = FirebaseFirestore.instance.collection('memo'); //FirebaseのMemoコレクションにアクセスするための記述

  Future<void> deleteMemo(String id) async {
    final doc = FirebaseFirestore.instance.collection('memo').doc(id); //Memoコレクションのドキュメントにアクセス 引数にString idを持ってきて、そのidを削除するようにする
    await doc.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluter × Firebase'),
      ),
      //StreamBuilder: 最近のアプリは非同期性が高く、様々なことが時と順序を選ばずに起こり得ます。
      //今この瞬間にも誰かが文章を投稿しているかもしれないし、いいねを押したかもしれません。
      //こうしたいつ、どこで、どんなイベントが発生するか分からないイベントを Stream （データの流れ）と考えることができます。
      //Flutter では Stream を扱う場合には StreamBuilder を使用します。
      body: StreamBuilder<QuerySnapshot>(
          stream: memoCollection
              .orderBy('createdDate', descending: true)
              .snapshots(), //memoCollectionで記述した処理が実行(または何かしらの変更が加わる)される度にListView.builderの処理が行われる　つまり内容が処理に沿ってリアルタイムに再描画されていく orderByを使うことで並び替えが可能。今回はcreatedDateで並び替えている 今回はtrueで新しい順　falseで古い順に表示させている
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //もし、読み込み中となる場合はぐるぐる回るやつを表示させる
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData) {
              //もし、データがない場合はデータがありませんと表示させる
              return const Center(
                child: Text('データがありません'),
              );
            }
            final docs = snapshot.data!.docs; //データがある場合はdocsの変数に指定されたメモの内容を代入する処理　!はnullではないことを記述している
            return ListView.builder(
              itemCount: docs.length, //docsの中にある要素の数だけ表示させたい場合は関数名+lengthを記述する
              itemBuilder: (context, index) {
                //docs[index].data()がオブジェクト型になっているのでストリング型dataに変換する処理を記述　オブジェクト型はすべてのベースでデータの塊、ストリング型は文字列を格納できる型　メモは文字列で表示させる
                Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
                final Memo fetchMemo = Memo(
                  //メモの内容を取得
                  id: docs[index].id, //idはストリング型に入れることができないのでオブジェクト型で定義する
                  title: data['title'],
                  detail: data['detail'],
                  createdDate: data['createdDate'],
                  updatedDate: data['updatedDate'],
                );

                return ListTile(
                  title: Text(fetchMemo.title),
                  //それぞれのタイルの右側にアイコンを配置して選択すると下から画面が出てきて編集ができるようにする　trailingはListTileの右側に表示するものを指定するプロパティ
                  trailing: IconButton(
                    onPressed: () {
                      //showModalBottomSheetを使うことで編集アイコンを選択するとしたからニョキっと編集画面が出てくるようになる
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SafeArea(
                            //SafeAreaを使うとIOSでアプリを作る際に上下に余白を作ることができる。IOS特有の上下の干渉を自動でいい感じに調整してくれる
                            child: Column(
                              mainAxisSize: MainAxisSize.min, //Columnの大きさを指定することができる。minであれば最小に設定してくれる
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.pop(context); //画面が戻ってきたらボトムシートが出たままになっているので、画面が遷移する前にボトムシートを消しておく処理を記述
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddEditMemoPage(
                                          currentMemo: fetchMemo,
                                        ),
                                      ),
                                    );
                                  },
                                  leading: const Icon(Icons.edit), //leadingはListTileの左側に表示するものを指定するプロパティ
                                  title: const Text('編集'),
                                ),
                                ListTile(
                                  onTap: () async {
                                    await deleteMemo(fetchMemo.id); //選択したメモをidで検出して削除する
                                    Navigator.pop(context);
                                  },
                                  leading: const Icon(Icons.delete),
                                  title: const Text('削除'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  //確認画面に遷移する記述を以下に書く
                  //fetchMemoを挿入することでタップされたメモの情報を詳細ページに送ることができる
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemoDetailPage(fetchMemo),
                      ),
                    );
                  },
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        //FloatingActionButtonを押すとメモの追加ページに遷移するように以下に記述
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditMemoPage(),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
