import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_training/model/memo.dart';
import 'package:flutter/material.dart';

class AddEditMemoPage extends StatefulWidget {
  //三項演算子を用いて条件によって処理を分けていく
  final Memo? currentMemo; //currentMemoの変数を定義。これに値が入っていれば編集画面を表示させ、なければ(nullであれば)追加画面を表示させる　?を入れることでnullを許容する形とする ※ nullであれば追加画面に遷移するだけなので問題ない
  const AddEditMemoPage({super.key, this.currentMemo});

  @override
  State<AddEditMemoPage> createState() => _AddEditMemoPageState();
}

class _AddEditMemoPageState extends State<AddEditMemoPage> {
  //実際に入力した内容を管理するための関数。入力された内容を取得するために使う。
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  //FirebaseのMemoコレクションに入力及び追加した内容を反映させる記述
  Future<void> createMemo() async {
    final memoCollection = FirebaseFirestore.instance.collection('memo'); //変数memoCollectionを定義して入力内容の追加を記述
    await memoCollection.add({
      //awaitを入れないとメモが追加される前にトップページに戻ってしまう
      'title': titleController.text, //タイトルに入力された内容を追加する
      'detail': detailController.text, //詳細に入力された内容を追加する
      'createdDate': Timestamp.now(), //追加された日時を登録する
    });
  }

//更新した内容を反映させるためにFirebaseに登録されている特定のドキュメントを取得するように記述
  Future<void> updateMemo() async {
    final doc = FirebaseFirestore.instance.collection('memo').doc(widget.currentMemo!.id);
    await doc.update({
      'title': titleController.text, //タイトルに入力された内容を追加する
      'detail': detailController.text, //詳細に入力された内容を追加する
      'updatedDate': Timestamp.now(), //更新された日時を登録する
    });
  }

//編集のアイコンを選択した場合に、元からメモの情報を入れておく処理を以下に記述。　initStateのタイミングで処理を行う : widgetツリーの初期化を行うタイミングで一度だけ呼ばれる　イメージとしては画面の再描画のタイミング
  @override
  void initState() {
    super.initState();
    if (widget.currentMemo != null) {
      //currentMemoに値が入っていれば(nullでなければ)
      titleController.text = widget.currentMemo!.title; //titleControllerにcurrentMemoのtitleを入れておく
      detailController.text = widget.currentMemo!.detail; //detailControllerにcurrentMemoのdetailを入れておく
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentMemo == null ? 'メモ追加' : 'メモ編集'), //currentMemoがnullであればメモ追加を表示させ、nullでなければメモ編集を表示させる処理 前半の条件式が合っていると?以降の処理が条件よって処理される
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //Textを左に寄せる記述
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const SizedBox(height: 40), //ボックスを入れて余白を作る
            const Text('タイトル'), //TextFieldと合わせて使うと勝手に中央になる？　その場で確認して任意の位置に移動させれば問題なし。
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), //入力欄の箱の枠線を作っている
              ),
              //MediaQueryを使うことで指定した要素(今回はSizedBox)の横幅のサイズを取得できている。また、今回は8割の大きさを指定している。
              width: MediaQuery.of(context).size.width * 0.8,
              //以下で入力欄を作成
              child: TextField(
                controller: titleController, //タイトルに入力された内容を取得する
                decoration: const InputDecoration(
                  border: InputBorder.none, //デフォルトで出てくる架線を見えなくする
                  contentPadding: EdgeInsets.only(left: 10), //入力時のカーソルが左寄りになっているので、左に少し余白を作成する
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text('詳細'),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: detailController, //詳細に入力された内容を取得する
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              alignment: Alignment.center, //ウィジェットの位置を指定することができる
              //ボタンを作る際に多用するウィジェット。ボタンを押すとFirebaseにメモが追加されるように処理を記述していく。
              child: ElevatedButton(
                onPressed: () async {
                  //もしcurrentMemoの値がnullだったら以下の処理を行う
                  if (widget.currentMemo == null) {
                    await createMemo(); //19行目で記述したメモの追加をここで行う　awaitを追加しないと追加が完了する前に元のページに戻ってしまう
                  } else {
                    await updateMemo(); //30行目で記述したメモの更新をここで行う　awaitを追加しないと更新が完了する前に元のページに戻ってしまう
                  }
                  Navigator.pop(context); //追加が完了すると元のページに戻る処理
                },
                child: Text(widget.currentMemo == null ? '追加' : '更新'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Firebaseに追加する際にIDを指定して登録する方法も調べておく
