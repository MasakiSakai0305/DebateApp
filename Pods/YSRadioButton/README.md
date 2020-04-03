# YSRadioButton
YSRadioButtonは簡単に使えるiOS用のswift製ラジオボタンライブラリです。  

![radioButton](radioButton.gif)　
![radioButton2](radioButton3.gif)　
![radioButton2](radioButton2.gif)　
# Features
ブラウザ標準のようなラジオボタンです。

# Installation
### CocoaPods

1. Podfileに `pod 'YSRadioButton', :git => 'https://github.com/sekies/YSRadioButton.git'` と追加します。
1. pod install します。


# Usage
1. YSRadioButtonをインポートします。
 ```Swift
 import YSRadioButton
 ```
2. 任意のUIViewContorollerで`YSRadioButtonViewControllerDelegate` プロトコルに準拠します。
 ```Swift
 class ViewController: UIViewController,YSRadioButtonViewControllerDelegate {
 ```
3. `YSRadioButtonViewController`インスタンスを生成します。生成時にラジオボタンのラベルを配列で指定します。  
  ```Swift
  let radio = YSRadioButtonViewController(labels: ["Orange","GrapeFruits","Banana"])
  ```
4. delegateと各種デザインプロパティを設定します。必須となるのはdelegateのみです。
  ```Swift
  radio.delegate = self
  radio.font = UIFont.systemFont(ofSize: 18)
  radio.labelColor = .black
  radio.labelMargin = 0
  radio.lineWidth = 1
  radio.radioHeadFillSize = 0.6
  radio.radioHeadMargin = 5
  radio.radioHeadStroke = .darkGray
  radio.radioHeadFill = .red
  ```
4. 親UIViewControllerに生成したYSRadioButtonViewControllerをaddChildしコンテナとなるUIViewにYSRadioButtonViewControllerのviewをaddSubviewします。ラジオボタンの位置はコンテナとなるUIViewに依存します。
  ```Swift
  addChild(radio)
  radio.view.frame = container.bounds
  container.addSubview(radio.view)
  radio.didMove(toParent: self)
  ```
5. デリゲートメソッドを実装します。ラジオボタンを選択するとこのメソッドが呼ばれます。YSRadioButtonViewController生成時に追加した配列の順にIntが割り振られます。
  ```Swift
  func didYSRadioButtonSelect(no: Int) {
    print(no)
  }
  ```
