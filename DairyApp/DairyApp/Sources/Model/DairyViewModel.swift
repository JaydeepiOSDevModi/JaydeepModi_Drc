//
//  DairyViewModel.swift
//  DairyApp
//
//  Created by Jaydeep Modi on 08/12/20.
//

import Foundation
import RxSwift
import RxCocoa

class DairyViewModel {
    
    let arrDiary = BehaviorSubject(value: [Model_Dairy]())
    
    func DataAlreadyExist(kUsernameKey: String) -> Bool {
        if UserDefaults.standard.value(forKey: kUsernameKey) as? Int ?? 0 == 1{
            return true
        } else {
            return false
        }
    }


    func fetchProductList() {
        
        if DataAlreadyExist(kUsernameKey: "LocalData") {
         
            fetchProductList()
            
        } else {
            if let url = URL(string: "https://private-ba0842-gary23.apiary-mock.com/notes") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let diary = try JSONDecoder().decode([Model_Dairy].self, from: data)
                            var diary_sort = diary.sorted(by: { $0.date.toDate()?.compare($1.date.toDate() ?? Date()) == .orderedDescending })
                            UserDefaults.standard.set("1", forKey: "LocalData")
                            self.arrDiary.onNext(diary_sort)
                            SaveDataToUserDefaults()
                        } catch let error {
                            print(error)
                        }
                    }
                }.resume()
            }
        }
        
        
       
          
        
        
        
        
    
    }
}

