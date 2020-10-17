<h1>tan5</h1>

itsukiさんが作ったアプリを勝手に少しリファクタリングたり、ER図を出力したりしてみた。  

## URL

### **https://tan5.herokuapp.com/**  

## 説明

ウェブ上で単語帳を作成したり、共有ができます。
単語帳を利用する上でシンプルな機能が実装されています。
CSVでのダウンロード、アップロードも可能です。

## 使用例

![tan5 demo](https://i.gyazo.com/5ad3d9c19352801a783233acb7e62cf6.gif)

## 使い方

database.yml.defaultを書き換えてください。  

```text
$ git clone https://git@github.com:itsuki-n22/tan5v2.git
$ cd tan5v2
$ bundle install
$ rails db:create
$ rails db:migrate
$ yarn install
$ rails s
```
