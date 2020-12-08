//
//  Dairy_ContentVC.swift
//  DairyApp
//
//  Created by Jaydeep Modi on 08/12/20.
//

import UIKit
let DVM = DairyViewModel()

class Dairy_ContentVC: UIViewController  , UITextViewDelegate {
    
    @IBOutlet weak var lblDairytitle :  UILabel!
    @IBOutlet weak var lblDairyContent :  UITextView!
    var row = 0

    var modelDairy : Model_Dairy?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblDairyContent.delegate = self
        self.title = modelDairy?.title
        self.navigationItem.backBarButtonItem?.title = ""
        self.lblDairytitle.text = self.modelDairy?.title ?? ""
        self.lblDairyContent.text = self.modelDairy?.content ?? ""

        lblDairyContent.translatesAutoresizingMaskIntoConstraints = true
        
        let fixedWidth = lblDairyContent.frame.size.width
        lblDairyContent.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = lblDairyContent.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = lblDairyContent.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        lblDairyContent.frame = newFrame

        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
        
    
    func textViewDidChange(_ textView: UITextView) {
          let fixedWidth = textView.frame.size.width
          textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          var newFrame = textView.frame
          newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
          textView.frame = newFrame

    }
    
    @IBAction func btnSaveClicked(_ sender : UIButton){
        self.view.endEditing(true)
        modelDairy?.content = lblDairyContent.text ?? ""
        guard var arr = try? DVM.arrDiary.value() else { return }
        if let index = arr.firstIndex(where: {$0.id == modelDairy?.id}){
            arr[index] = modelDairy!
        }
        DVM.arrDiary.onNext( arr)
        SaveDataToUserDefaults()
        self.navigationController?.popViewController(animated: true)
    }


}


