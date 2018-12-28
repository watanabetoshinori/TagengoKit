# TagengoKit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![NICT: Sandbox](https://img.shields.io/badge/NICT-Sandbox-red.svg)](https://mimi.readme.io/page/tagengo)

TagengoKit は [多言語音声翻訳コンテスト](https://tagen.go.jp/) のサンドボックスサーバーが提供する各種 API を利用するための iOS 用フレームワークです。
国立研究開発法人情報通信研究機構（NICT）の開発した多言語音声翻訳機能を利用することができます。

サンドボックスサーバーは2019年3月15日まで利用可能です。

## 機能
- [x] アクセストークンの取得
- [x] チケット残数の取得
- [x] 音声認識 API (一括送信のみ)
- [x] 機械翻訳 API
- [x] 音声合成 API
- [x] マイクから録音
- [x] 音声ファイルを再生

## はじめに

### 利用申請

サンドボックスサーバーの API を使用するためには、利用申請が必要です。
以下のページから申請を行ってください。

https://tagen.go.jp/sandbox/


### サンドボックスサーバー API

API の詳細については以下を参照してください。

https://mimi.readme.io/page/tagengo

### 環境

* iOS 12.0+
* Xcode 10.0+
* Swift 4.2+

### インストール

**[Swift Package Manager](https://github.com/apple/swift-package-manager)**

```swift
dependencies: [
    .package(url: "https://github.com/watanabetoshinori/TagengoKit.git", from: "1.0.0"),
],
targets: [
    .target(
        ...
        dependencies: ["TagengoKit"]),
]
```

**[Cocoa Pods](https://cocoapods.org)**

```sh
pod "TagengoKit", :git => 'https://github.com/watanabetoshinori/TagengoKit.git', :branch => 'master'
```

**[Carthage](https://github.com/Carthage/Carthage)**

```sh
github "watanabetoshinori/TagengoKit"
```

## 使い方

### 初期化

TagengoKit をインポートします

```swift
import TagengoKit
```

### アクセストークンを取得

サンドボックス の各 API を利用するために必要なアクセストークンを取得します。

```swift
// 利用申請により取得したアプリケーションIDとアプリケーションシークレットを渡します
let id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
let secret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

let api = AccessToken(id: id, secret: secret)

api.getToken { (accessToken, error) in

    // 取得したアクセストークンを保存します
    self.accessToken = accessToken

}
```

### チケット残数を取得

各 API を利用する際に必要なチケットの残数を確認できます。

```swift
// アクセストークンを渡して初期化します
let api = TicketCounter(accessToken: accessToken)

api.getCount { (count, error) in 

    // チケット残数を表示します
    print(count)

}
```

### API を利用する

NICT の開発した多言語音声翻訳機能を利用できます。
API を呼び出すとチケットを消費します。

#### 音声認識 API

音声データをテキストに変換します。

```swift
// アクセストークンを渡して初期化します
let api = Recognizer(accessToken: accessToken)

// 音声ファイルの Data を渡します
api.recognize(audio: data) { (result, error) in

    // 認識結果を表示します
    print(result)

}
```

#### 機械翻訳 API

テキストを指定した言語に翻訳します。

```swift
// アクセストークンを渡して初期化します
let api = Translator(accessToken: accessToken)

// 翻訳したいテキスト、言語を渡します
api.translate(text: "こんにちは", from: .en, to: .ja) { (result, error) in
 
    // 翻訳結果を表示します
    print(result)

}
```

#### 音声合成 API

テキストから音声ファイルを生成します。

```swift
// アクセストークンを渡して初期化します
let api = SpeechSynthesizer(accessToken: accessToken)

// 音声合成したいテキストを渡します
api.synthesize(text: "老若男女が火を囲み、みんなで手をつないで歌う", language: .ja) { (data, error) in

    // data に音声ファイルが渡されるので、再生またはファイルに保存します

}

```

### マイクから録音する

端末のマイクから録音を行い、音声ファイルを出力します。
出力した音声ファイルは音声認識 API に最適化されています。

#### 録音を開始する

```swift
do {
    recorder = Recorder()

    try recorder.startRecording()

} catch {
    print(error)
}
```

#### 録音を終了する

```swift
recorder.stopRecording()

// 保存されたファイルは以下のファイル URL で参照できます
recorder.path
```

### 音声を再生する

指定した音声ファイルを再生します。

```swift
do {
    player = Player()

    // Data またはファイル URL を渡します
    try player.play(audio: path)

} catch {
    print(error)
}
```

音声合成 API から取得した wav ファイルを再生する場合は、`appendWavHeader` を使用して wav ヘッダーを補完します。

```swift
do {
    player = Player()

    let wav = player.appendWavHeader(to: data)

    try player.play(audio: wav)

} catch {
    print(error)
}
```

## サンプル

各 API を利用したサンプルアプリケーションを提供しています。
[Example](Example) フォルダを参照してください。


## 作者

Watanabe Toshinori – toshinori_watanabe@tiny.blue

## ライセンス

このプロジェクトは MIT ライセンスで配布しています。 詳細については [ライセンス](LICENSE) を参照してください。

サンドボックサーバー については サンドボックスサーバーの[利用規約](https://tagen.go.jp/sandbox/)を参照してください。
