# AABilling <img src="https://i.imgur.com/LEouQqx.png" width="80" height="80" align=center>

[<img src="https://github.com/nick1ee/Shalk/raw/master/screenshot/DownloadAppStoreBadge.png" width="160" height="50" align=center>](https://itunes.apple.com/tw/app/aabilling/id1461738151)

朋友、情侶間簡易分帳，公平、公正，AA 制讓分帳不再困惱，即便付出的金額較多或較少也能快速得知與對方的分帳帳務。

## Screen Shot

<img src="https://i.imgur.com/YmnNnld.png" width="290" height="290" align=center> <img src="https://i.imgur.com/EIZKOsD.png" width="290" height="290" align=center> <img src="https://i.imgur.com/Dj63hOu.png" width="290" height="290" align=center>

## Key Features

- 註冊 / 登入功能

     <img src="https://i.imgur.com/pGrI0LC.gif" width="150" height="290" align=center>
- 使用 Firebase(Cloud Firestore) 儲存使用者資料。

```Swift
func createUserData(userName: String, withEmail: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(currentUser.uid).setData(
            [
                UserData.CodingKeys.name.rawValue: userName,
                UserData.CodingKeys.email.rawValue: withEmail,
                UserData.CodingKeys.storage.rawValue: "",
                UserData.CodingKeys.uid.rawValue: currentUser.uid
            ])
    }
```
```Swift
Auth.auth().createUser(
            withEmail: signUpEmail.text ?? "",
            password: signUpPassword.text ?? "") { [weak self] (_, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    
                    FirebaseManager
                        .shared
                        .createUserData(
                            userName: self?.signUpUsername.text ?? "",
                            withEmail: self?.signUpEmail.text ?? ""
                    )
                }
```
- 使用 UITextFiledDelegate 立即顯示使用者輸入的分帳金額。

```Swift
extension IndividualViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userTextField {
            selectTextField = true
        } else {
            selectTextField = false
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == userTextField {
            
            if userTextField?.text == "" {
                
                friendTextField?.text = ""
                
                owedAmount?(Int(-0.9501))
                
            } else {
                
                guard let userAmount = Int(userTextField?.text ?? "")
                    else {
                        
                        payAmount?(nil)
                        
                        return
                }
                friendTextField?.text =
                "\(individualBilling!.amount - userAmount)"
                
                payAmount?(userAmount)
                
                owedAmount?(userAmount - individualBilling!.amount / 2)
                
                friendPayAmount?(individualBilling!.amount - userAmount)
                
                friendOwedAmount?(individualBilling!.amount / 2 - userAmount)
            }
            
        }
```
- 用 UIStackView 製作計算機。

     <img src="https://i.imgur.com/snXocqS.png" width="290" height="290" align=center>
- 使用者可以透過遠端推播發送欠款通知。

     <img src="https://i.imgur.com/8jS9ji6.gif" width="150" height="290" align=center>
- 使用 UIScrollView 和 Child view controller 建立分帳頁面。

     <img src="https://i.imgur.com/gTlBCkm.gif" width="150" height="290" align=center>

## Library
- SwiftLint
- IQKeyboardManagerSwift
- Fabric
- Crashlytics
- Firebase/Core

## Contacts
Hsien-Han Tsai  
email: sian91355@gmail.com
