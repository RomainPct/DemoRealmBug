//
//  Card.swift
//  DemoRealmBug
//
//  Created by Romain Penchenat on 20/12/2020.
//

import Foundation
import RealmSwift
import Realm

class Card : Object {
    
    @objc private dynamic var _id:Int = 0
    @objc private dynamic var _name = ""
    @objc private dynamic var _uppercaseName = ""
    @objc private dynamic var _identifier = ""
    @objc private dynamic var _password = ""
    @objc private dynamic var _notes = ""
    
    convenience init(withId id:Int) {
        self.init()
        _id = id
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    var id:Int { _id }
    
    var name:String {
        get { _name }
        set {
            realm?.beginWrite()
            _name = newValue
            _uppercaseName = setUppercaseName(name: newValue)
            try? realm?.commitWrite()
        }
    }
    var uppercaseName:String { _uppercaseName }
    func setUppercaseName(name:String) -> String {
        var returnName = name.uppercased()
        if let match = returnName.range(of: "[a-zA-Z]", options: String.CompareOptions.regularExpression) {
            if match.lowerBound.utf16Offset(in: returnName) != 0 {
                returnName = "#" + returnName
            }
        } else {
            returnName = "#" + returnName
        }
        return returnName.uppercased()
    }
    
    var identifier:String {
        get { _identifier }
        set {
            realm?.beginWrite()
            _identifier = newValue
            try? realm?.commitWrite()
        }
    }
    
    var password:String {
        get { _password }
        set {
            realm?.beginWrite()
            _password = newValue
            try? realm?.commitWrite()
        }
    }
    
    var notes:String {
        get { _notes }
        set {
            realm?.beginWrite()
            _notes = newValue
            try? realm?.commitWrite()
        }
    }
    
}

