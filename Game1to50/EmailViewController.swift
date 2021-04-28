//
//  EmailViewController.swift
//  EasyGoRecorder
//
//  Created by Steven Lin on 2020/5/15.
//  Copyright © 2020 yulinhu. All rights reserved.
//

import UIKit
import MessageUI

class EmailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var btnEmail: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        print("意見反饋")
                    
         if MFMailComposeViewController.canSendMail() {
            //注意這個實例要寫在if block裏，否則無法發送郵件時會出現兩次提示彈窗（一次是系統的）
             let mailComposeViewController = configuredMailComposeViewController()
             self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        //檢查裝置是否能傳送email
        let emailTitle = "回复开发者"
        let messageBody = "您好我想回馈意见!"
        let toRecipients = ["service@appworkservice.online"]
        
        //初始化郵件內容
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipients)
        //        //判斷檔名與副檔名
        //        let fileparts = attachment.components(separatedBy: ".")
        //        let filename = fileparts[0]
        //        let fileExtension = fileparts[1]
        //
        //        //取得資源路徑並使用 nsdata 讀取檔案
        //        guard let filePath = Bundle.main.path(forResource: filename, ofType: fileExtension) else{
        //            return
        //        }
        //        //取得檔案資料與 mime 型態
        //        if let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
        //            let mimeType = MIMEType(type: fileExtension){
        //
        //            //加入附件
        //            mailComposer.addAttachmentData(fileData, mimeType: mimeType.rawValue, fileName: filename)
        //            present(mailComposer,animated: true,completion: nil)
        //        }
        //
        //    }
        return mailComposer
    }
    
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert = UIAlertController(title: "無法發送郵件", message: "您的設備尚未設置郵箱，請在“郵件”應用中設置後再嘗試發送。", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "確定", style: .default) { _ in })
        self.present(sendMailErrorAlert, animated: true){}
    }
    
    private func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result {
        case MFMailComposeResult.cancelled:
            print("取消發送")
        case MFMailComposeResult.sent:
            print("發送成功")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
        
    }
}
