//
//  imageNetworking.swift
//  FindYourFace
//
//  Created by Roman on 9/6/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit
import Firebase

class ImageNetworking: NSObject {
    func uploadPhoto(image: UIImage, profile:Bool, completion: @escaping (Error?) -> ()) {
        // Data in memory
        let storageRef = Storage.storage().reference()
        guard let data = image.pngData() else { return  }
        let time = NSDate().timeIntervalSince1970
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/\(time).png")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            if (error != nil) {
                completion(error)
            }
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                var ref: DatabaseReference!
                ref = Database.database().reference()
                let user = Auth.auth().currentUser
                if profile {
                    ref.child("images").child(user!.uid).updateChildValues(["profileImageUrl": downloadURL.absoluteString])
                } else {
                    //ref.child("images").child(user!.uid).updateChildValues(["name": user!.uid, "type": "HotDog", "time": time, "mainImageUrl": downloadURL.absoluteString, "registred": "yes"])
                    self.checkIsRegistred(completion: { (flag) in
                        if flag {
                            ref.child("images").child(user!.uid).updateChildValues(["time": time, "mainImageUrl": downloadURL.absoluteString])
                        } else {
                            ref.child("images").child(user!.uid).updateChildValues(["name": user!.uid, "type": "HotDog", "time": time, "profileImageUrl": downloadURL.absoluteString, "mainImageUrl": downloadURL.absoluteString, "registred": "yes"])
                        }
                    })
                }
            }
        }
        
        let observer = uploadTask.observe(.progress) { snapshot in
            print("Progress: \(snapshot.progress)")
        }
    }
    
    func fetchDataFromFirebase(completion: @escaping ([CustomData]) -> ()) {
        let ref = Database.database().reference().child("images")
        var dataArray = [CustomData]()
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let enumNext = enumerator.nextObject() as? DataSnapshot {
                let rest = enumNext.value as! [String:Any]
                if (rest["mainImageUrl"] == nil) {
                    continue
                }
                if ((rest["profileImageUrl"] as! String) == "") {
                    let data = CustomData(name: rest["name"] as! String, type: rest["type"] as! String, time: "\(rest["time"] ?? "0")", profileImageUrl: "", mainImageUrl: rest["mainImageUrl"] as! String)
                    dataArray.append(data)
                } else {
                    let data = CustomData(name: rest["name"] as! String, type: rest["type"] as! String, time: "\(rest["time"] ?? "0")", profileImageUrl: rest["profileImageUrl"] as! String, mainImageUrl: rest["mainImageUrl"] as! String)
                    dataArray.append(data)
                }
            }
            dataArray.sort { (customDataOne, customDataTwo) -> Bool in
                customDataOne.time > customDataTwo.time
            }
            completion(dataArray)
        }
    }
    
    func fetchLogoFromFirebase(completion: @escaping (UIImage?, Error?) -> ()) {
        let ref = Database.database().reference().child("images").child(Auth.auth().currentUser!.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let profileImageUrl = value?["profileImageUrl"] as? String ?? ""
            
            if !(profileImageUrl.isEmpty) {
                self.downloadImage(from: URL(string: profileImageUrl)!, completion: completion)
            } else {
                return
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func checkIsRegistred(completion: @escaping (Bool) -> ()) {
        let ref = Database.database().reference().child("images").child(Auth.auth().currentUser!.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let profileImageUrl = value?["registred"] as? String ?? ""
            
            var isRegistred = false
            if !(profileImageUrl.isEmpty) {
                isRegistred = true
                completion(isRegistred)
            } else {
                completion(isRegistred)
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping(UIImage?, Error?) -> Void) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async {
                completion(UIImage(data: data), error)
            }
        }
    }
}
