# same_file
指定されたディレクトリの中から、

* 同じ内容のファイル
* サイズ0のファイル

を探し出して、その結果をyamlファイルに出力します。

また、

* 同じ内容のファイル → どちらを消すのか質問してから片方を削除
* サイズ0のファイル → 削除するのか質問してから削除

します。

## 設定方法
`target_directory.yaml`の中に、検索対象にするディレクトリを指定してください。

## 使い方
```(shell)
$ ruby same_file.rb
```
