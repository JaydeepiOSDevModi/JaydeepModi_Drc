//
//  Dairy_HomeVC.swift
//  DairyApp
//
//  Created by Jaydeep Modi on 08/12/20.
//

import UIKit
import RxSwift
import RxCocoa


class Dairy_HomeVC: UIViewController {
    
    // MARK: Constants
    private let disposeBag = DisposeBag()

    @IBOutlet weak var tableView  : UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "Dairy_TableViewCell", bundle: nil), forCellReuseIdentifier: "Dairy_TableViewCell")

        tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.title = "My Dairy"
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let arr = try? DVM.arrDiary.value() else { return }
            DVM.arrDiary.onNext(arr)
    }
    
    
    
    private func bindTableView() {
        
        DVM.arrDiary.bind(to: tableView.rx.items(cellIdentifier: "Dairy_TableViewCell", cellType: Dairy_TableViewCell.self)) { (row,item,cell) in
            cell.c_index = row
            guard let sections = try? DVM.arrDiary.value() else { return }
            if row != 0 {
                cell.previousItem = sections[row - 1]
            }
            cell.item = item
            cell.btnDelete.tag =  row
            cell.btnDelete.addTarget(self, action: #selector(self.btnCloseTapped), for: .touchUpInside)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Model_Dairy.self).subscribe(onNext: { item in
            print("SelectedItem: \(item)")
            guard let sections = try? DVM.arrDiary.value() else { return }
            if let index = sections.firstIndex(where: {$0.title == item.title}){
                self.performSegue(withIdentifier: "detailsSegue", sender: sections[index])
            }
           DVM.arrDiary.onNext(sections)
        }).disposed(by: disposeBag)
        DVM.fetchProductList()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! Dairy_ContentVC
        
        if let model =  sender as? Model_Dairy {
            guard var arr = try? DVM.arrDiary.value() else { return }
            if let index = arr.firstIndex(where: {$0.id == model.id}){
                destinationVC.row = index
            }
           DVM.arrDiary.onNext(arr)
            destinationVC.modelDairy = model
            
        }

        
        
        
        
    }
    
    
    @objc func btnCloseTapped(_ sender : UIButton){
            let actions: [UIAlertController.AlertAction] = [
                .action(title: "No", style: .destructive),
                .action(title: "Yes")
            ]
            UIAlertController
                .present(in: self, title: "Alert", message: "Are you sure you want to delete?", style: .alert, actions: actions)
                .subscribe(onNext: { buttonIndex in
                    print(buttonIndex)
                    if buttonIndex == 1{
                        if let value = try? DVM.arrDiary.value()[sender.tag] {
                            guard var arr = try? DVM.arrDiary.value() else { return }
                                if let index = arr.firstIndex(where: {$0.id == value.id}){
                                    arr.remove(at: index)
                                }
                            DVM.arrDiary.onNext(arr)
                            SaveDataToUserDefaults()
                        }
                    }
                })
                .disposed(by: disposeBag)
        }

        
    
    


}



extension Dairy_HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func toDateString(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")-> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
}
