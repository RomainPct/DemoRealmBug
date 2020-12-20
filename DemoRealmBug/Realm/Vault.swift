//
//  Vault.swift
//  DemoRealmBug
//
//  Created by Romain Penchenat on 20/12/2020.
//

import Foundation

import Foundation
import RealmSwift

class Vault {
    
    private var _realm:Realm
    
    private var _cardsList:Results<Card> {
        return _realm.objects(Card.self).sorted(byKeyPath: "_uppercaseName")
    }
    
//    Init classic
    init(withRealm: Realm) {
        _realm = withRealm
    }
    
    func reinitialize() {
        _realm.invalidate()
    }
    
//    Functions
    func getNewId() -> Int {
        var id = 0
        if let lastID = _realm.objects(Card.self).sorted(byKeyPath: "_id").last?.id {
            id = lastID + 1
        }
        return id
    }
    
    func newCard(name:String,identifier:String?,password:String?,notes:String?) {
        let newCard = Card(withId: getNewId())
        newCard.name = name
        newCard.identifier = identifier ?? ""
        newCard.password = password ?? ""
        newCard.notes = notes ?? ""
        try? _realm.write {
            _realm.add(newCard)
        }
    }
    
//    Count
    func countCards() -> Int {
        return _cardsList.count
    }
    
//    Get card
    func getCard(atIndex index:Int) -> Card? {
        guard index >= 0 && index < countCards() else {
            return nil
        }
        return _cardsList[index]
    }
    
}
