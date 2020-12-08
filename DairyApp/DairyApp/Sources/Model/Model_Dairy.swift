//
//	Model_Dairy.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation






struct Model_Dairy  : Decodable , Encodable{

        var id, title, content, date: String


    
    
//
//	init(fromDictionary dictionary: [String:Any]){
//		content = dictionary["content"] as? String
//		date = dictionary["date"] as? String
//		id = dictionary["id"] as? String
//		title = dictionary["title"] as? String
//	}

//	/**
//	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
//	 */
//	func toDictionary() -> [String:Any]
//	{
//		var dictionary = [String:Any]()
//		if content != nil{
//			dictionary["content"] = content
//		}
//		if date != nil{
//			dictionary["date"] = date
//		}
//		if id != nil{
//			dictionary["id"] = id
//		}
//		if title != nil{
//			dictionary["title"] = title
//		}
//		return dictionary
//	}

}
