//Memoクラスの作成　メモを作る上で必要な要素の変数を定義して使えるようにしておく　メモの内容は変則的であるため変数を活用すること必須
import 'package:cloud_firestore/cloud_firestore.dart';

class Memo {
  //String(文字列のみを格納)とTimeStamp(日付及び時刻を格納)型で変数を定義する Memoクラスないの各変数を呼び出せるようにしておく
  String id; //メモのドキュメントID 必須項目とする
  String title; //メモのタイトル　必須項目とする
  String detail; //メモの内容　必須項目とする
  Timestamp createdDate; //メモが作られた日時　必須項目とする
  Timestamp? updatedDate; //メモが更新された日時 更新されなければ出てこないので必須項目としない 必須項目としないのでNullSafetyの処理を忘れずに(?をいれる)

//以下にコンストラクタを記述することで上記のエラーが解消される　コンストラクタ:指定のクラスを実際に実行する際の指示を記述しているもの　以下の場合はMemoクラスで指定した変数をどのように(使うか)実行するかを記載している
//requiredをつけることにより必須項目に指定することができる
  Memo({
    required this.id,
    required this.title,
    required this.detail,
    required this.createdDate,
    this.updatedDate,
  });
}
