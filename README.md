# firebase-training

1. 以下のURLよりFirebaseの新規プロジェクトを作成
※Googleアカウントがない場合はアカウントの作成からスタート

https://firebase.google.com/?hl=ja

2. プロジェクトが作成できたらflutterfireをインストールする

https://firebase.flutter.dev/docs/overview

3. FirebaseCLIのインストール及びFirebaseへのログイン

https://firebase.google.com/docs/cli#mac-linux-npm

【詳細】

以下のコマンドを順番に入力

・　flutter pub add firebase_core

・　npm install -g firebase-tools　※npmがインストールされていなければインストールしてから対応した方が後々のためになる

・　dart pub global activate flutterfire_cli

・　flutterfire configure

以上が完了したらFirebaseのプロジェクトを選択してログイン

4. プロジェクトとFirebaseを繋げる

main.dart内にて以下のコードを記述　※添付のリンクからコピペで対応できる

![image](https://user-images.githubusercontent.com/108006833/211261069-c45140fa-356f-45a4-b957-27ea5a9deeef.png)

エラー部分はそれぞれの新規ファイルを紐づけて対応。　※Firebaseとの連携が完了すると連携に必要なファイルが自動生成させるのでそれらと紐づける

※cocoapodsのエラーが出た時の解消法は再インストールしてからflutter cleanを実装してからビルドすると解決した

5. Firestore Databaseの構築

　構築 > Firestore Database > テスト環境を選択 > リージョンを設定 > 有効

