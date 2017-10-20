//
//  RecordVideoViewController.swift
//  VideoPlayRecord
//
//  Created by Andy on 2/1/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
import MobileCoreServices

class RecordVideoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
    @IBAction func record(_ sender: UIButton) {
        print("record pressed")
        let result = startCameraFromViewController(viewController: self, withDelegate: self)
        if result{
            print("camera started and available")
        }else{
            print("camera isnt available, maybe because you are using an emulator DUMMY")
        }
    }

  func startCameraFromViewController(viewController: UIViewController, withDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) -> Bool {
    if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
      return false
    }

    let cameraController = UIImagePickerController()
    cameraController.sourceType = .camera
    cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
    cameraController.allowsEditing = false
    cameraController.delegate = delegate

    present(cameraController, animated: true, completion: nil)
    return true
  }

  func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
    var title = "Success"
    var message = "Video was saved"
    if let _ = error {
      title = "Error"
      message = "Video failed to save"
    }
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
}

// MARK: - UIImagePickerControllerDelegate

extension RecordVideoViewController: UIImagePickerControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    let mediaType = info[UIImagePickerControllerMediaType] as! NSString
    dismiss(animated: true, completion: nil)
    // Handle a movie capture
    if mediaType == kUTTypeMovie {
      guard let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path else { return }
      if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
        UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(video), nil)
      }
    }
  }
}

// MARK: - UINavigationControllerDelegate

extension RecordVideoViewController: UINavigationControllerDelegate {
}
