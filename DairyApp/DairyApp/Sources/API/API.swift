//
//  API.swift
//  RxTableViewOne
//
//  Created by Jaydeep Modi on 08/12/20.
//

import Foundation
import RxSwift
import RxCocoa




public enum RequestType: String {
    case GET, POST, PUT,DELETE
}


class APIRequest {
    let baseURL = URL(string: "https://private-ba0842-gary23.apiary-mock.com/notes")!
    var method = RequestType.GET
    var parameters = [String: String]()
    
    func request(with baseURL: URL) -> URLRequest {
          var request = URLRequest(url: baseURL)
           request.httpMethod = method.rawValue
           request.addValue("application/json", forHTTPHeaderField: "Accept")
           return request
       }

}




class APICalling {
    // create a method for calling api which is return a Observable
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: apiRequest.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    
                    let diary = try JSONDecoder().decode([Model_Dairy].self, from: data!)
                    observer.onNext(diary as! T)
                    
//                    let jsonDecoder = JSONDecoder()
//                    if let data = data,
//                        let categories = try? jsonDecoder.decode([Dictionary<String,Any>], from: data) {
//                        print(categories)
//
//                    } else {
//                            print("Nothing reutrned or Not decoded")
//                        }
//
//
//
//
//
//                    let model: Arr_Model_Dairy = try JSONDecoder().decode(Arr_Model_Dairy.self, from: data ?? Data())
//                    observer.onNext( model.result as! T)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}


func SaveDataToUserDefaults() {
    
    if let value = try? DVM.arrDiary.value(){
        do {
           let jsonData = try JSONEncoder().encode(value)
           UserDefaults.standard.set(jsonData, forKey: "diary")
    
        } catch let error {
          print(error)
        }
    }

}

func FetchDataToUserDefaults(){
    
    if let diaryData = UserDefaults.standard.object(forKey: "diary") as? Data{
        do {
        let arrTemp = try JSONDecoder().decode([Model_Dairy].self, from: diaryData)
        let diary = arrTemp.sorted(by: { $0.date.toDate()?.compare($1.date.toDate() ?? Date()) == .orderedDescending })
            DVM.arrDiary.onNext( diary)
        } catch let error {
            print(error)
        }
    }
}
