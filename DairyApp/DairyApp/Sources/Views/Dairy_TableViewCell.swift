//
//  Dairy_TableViewCell.swift
//  DairyApp
//
//  Created by Jaydeep Modi on 08/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class Dairy_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDate :  UILabel!
    @IBOutlet weak var lblTitle :  UILabel!
    @IBOutlet weak var lblContent :  UILabel!
    @IBOutlet weak var lblHour :  UILabel!
    @IBOutlet weak var imgTime :  UIImageView!
    @IBOutlet weak var btnDelete :  UIButton!

    @IBOutlet  weak var cnst1 :  NSLayoutConstraint!
    @IBOutlet  weak var cnst2 :  NSLayoutConstraint!
    @IBOutlet  weak var cnst3 :  NSLayoutConstraint!


    var previousItem: Model_Dairy?
    var c_index = 0
    
    
    var item: Model_Dairy! {
        didSet {
            setProductData()
        }
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setProductData() {
        lblDate.isHidden = false
        imgTime.isHidden = false
        
        cnst1.constant = 20
        cnst3.constant = 53

        if c_index == 0 {
            lblDate.text = item.date.toDateString() ?? ""
        }
        else {
            if previousItem!.date.toDateString() ?? "" == item.date.toDateString() ?? "" {
                lblDate.isHidden = true
                imgTime.isHidden = true
                cnst1.constant = 0
                cnst3.constant = 10

            } else {
                lblDate.text = item.date.toDateString() ?? ""
            }
        }
        lblHour.text =  (((item.date).toDate() ?? Date()).timeAgo()) +  "  ago"
        lblTitle.text = item.title
        lblContent.text = item.content
    }

    
    
    

}



//MARK:- //Advance Display View
class CardView: UIView {

    @IBInspectable override var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.shadowRadius = newValue
            layer.masksToBounds = false
        }
    }

    @IBInspectable override var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layer.shadowColor = UIColor.darkGray.cgColor
        }
    }

    @IBInspectable override var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            layer.shadowColor = UIColor.black.cgColor
            layer.masksToBounds = false
        }
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

extension UIAlertController {

    struct AlertAction {
        var title: String?
        var style: UIAlertAction.Style

        static func action(title: String?, style: UIAlertAction.Style = .default) -> AlertAction {
            return AlertAction(title: title, style: style)
        }
    }

    static func present(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        style: UIAlertController.Style,
        actions: [AlertAction])
        -> Observable<Int>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)

            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }

            viewController.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }

    }

}
