//
//  PushNotificationSender.swift
//  Project-2
//
//  Created by User on 2019/5/5.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class PushNotificationSender {
    
    func sendPushNotification(to token: String, title: String, body: String) {
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        
        let url = NSURL(string: urlString)!
        
        let paramString: [String: Any] = [
            "to": token,
            "notification": ["title": title, "body": body],
            "data": ["user": "test_id"]
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization
            .data(withJSONObject: paramString,
                  options: [.prettyPrinted])
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        let keyValue = "AAAAwkhfuuM:APA91bFd-gZ1hnPQXNkA819hPovAfaHic66kyI1Neurcl15db3YcO7AVOw_"
        let keyValueBehind = "3UjgKaprFd9zv3rx5Whi9NEF9Yd_TW-o9nyVlYFp_bgF5vGdcOwnhixQYPAKl6P1Ba3IwMw2NQ6F0iy1y"
        
        request.setValue("key=\(keyValue)\(keyValueBehind)", forHTTPHeaderField: "Authorization")
        
        let task =
            URLSession
            .shared
            .dataTask(with: request as URLRequest) { (data, _, _) in
            
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(
                        with: jsonData,
                        options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
