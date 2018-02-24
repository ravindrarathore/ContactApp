//
//  ViewController.swift
//  MyContact
//
//  Created by Apple on 23/02/18.
//  Copyright © 2018 Ravindra_Rathore. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI


@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    
//    Mark : Outlet
    @IBOutlet weak var noOfContactLabel: UILabel!
    
    @IBOutlet weak var exportBtn: DesignableButton!
    
    @IBOutlet weak var progressvVew: DesignableView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    var noofcontact = [CNContact]()
    var filepath  = ""

let contactStore = CNContactStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestAccess(completionHandler: {_ in 
            print("requst")
             self.noofcontact = self.fetchAllContacts()
            self.noOfContactLabel.text = "Total: "+String(self.noofcontact.count)+" Contacts"
        })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MArk : Function for fetching all contact
    func fetchAllContacts() -> [CNContact]{
        var contacts = [CNContact]()
        let contactStore = CNContactStore()
        let fetchreq = CNContactFetchRequest.init(keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
        
        do{
            try contactStore.enumerateContacts(with: fetchreq){
                (contact,end) in
                contacts.append(contact)
            }
          }
        catch{
            print("Failed to fetch")
        }
        
         return contacts
    }
    
//    Request for permession
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            contactStore.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        }
   }
    //        Make To Documents
    func saveContactToDocuments(contacts:[CNContact]) -> Bool{
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileURL = URL.init(fileURLWithPath: documentDirectoryPath.appending("/MyContacts.vcf"))
        self.filepath = fileURL.path
        let data : NSData?
        do{
            print(contacts)
             CNContactVCardSerialization.descriptorForRequiredKeys()
         try  data =  CNContactVCardSerialization.data(with: contacts) as NSData
//            try  data =  CNContactVCardSerialization.data(with: contacts) as NSData
            do{
                  try data?.write(to: fileURL, options: .atomic)
                print(fileURL.absoluteString)
                return true
            }
            catch{
                print("Failed to write")
                return false
            }
          
        }
        catch{
            return false
            print("exception")
        }
    }
    
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            completionHandler(false)
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
    }
    
    
//    Mark : Action
    
    @IBAction func ExportAction(_ sender: Any) {
        if self.noofcontact.count > 0{
       if self.exportBtn.tag == 1{
             let contctSave =  self.saveContactToDocuments(contacts: noofcontact)
            if contctSave{
                self.exportBtn.setTitle("Email", for: .normal)
                self.exportBtn.tag = 2
                self.exportBtn.backgroundColor = UIColor.blue
            }
           
        }
        else{
          let fileManager = FileManager()
           if fileManager.fileExists(atPath: self.filepath){
                let myContactFile = fileManager.contents(atPath: self.filepath)
            DispatchQueue.main.async {
                let activityViewController = UIActivityViewController(activityItems: [myContactFile], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion:nil)
            }
//
//            self.exportBtn.setTitle("Export", for: .normal)
//            self.exportBtn.tag = 1
//            self.exportBtn.backgroundColor =  UIColor.green
            }
           else{
            print("File not found")
            }
            }
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    //Set current view to landscape
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
   
}

