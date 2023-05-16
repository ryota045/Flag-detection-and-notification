# 好きなチャートパターンが出現した際に、ラインへメッセージとともに、発見されたチャートの画像を送信するツール。

## ツールの処理の流れ
1.MT4にてチャートのスクリーンショットを定期的に取得する。

2.名前付きパイプを使用し、MT4からPythonのコードを実行する。

3.Pythonのコードにて予め用意したパラメータを使用し、スクリーンショットの中にチャートパターンが出現しているか判定し、
　出現しているものを発見し、パターンを四角で囲み画像を保存する。
 
4.指定の時間にGoogle Apps Scriptのコード処理にて、チャートパターンが出現している画像と通貨ペア名を個人ラインに送信する。
