//
//  Moves.swift
//  Pokemonidex
//
//  Created by C Sinclair on 1/30/16.
//  Copyright © 2016 femtobyte. All rights reserved.
//
//  

import Foundation
import Alamofire

class Moves {
    
    private var _name: String!  
    private var _movesID: Int!
    private var _moveAccuracy: String!
    private var _moveDescription: String!
    private var _movePower: String!
    private var _moveUrl: String!
    private var _movePP: String!
    private var _versionGrpUrl: String!
    private var _category: String!
    // This is in the pokemon url, not the moves url.  but I have to get it here cause it is
    // based on the move.  And based on the pokemon.  So I have to know which pokemon it is, 
    // and then which move it is.  Then I look up the pokemon id, and the move name, and can get the learn type.
    // which means this class has to have a reference to the pokemon, right?
    private var _learnType: String!
    private var _learnUrl: String!
    private var _pokeName: String!
    
    var category: String {
        if _category == nil {
            _category = "null"
        }
        return _category
    }
    
    var name: String {
        return _name
    }
    
    var movesID: Int {
        return _movesID
    }
    
    var movePP: String {
        return _movePP
    }
    
    var learnType: String {
        if _learnType == nil {
            _learnType = ""
        }
        return _learnType
    }

    var moveAccuracy: String {
        if _moveAccuracy == nil {
            _moveAccuracy = ""
        }
        return _moveAccuracy
    }
    
    var moveDescription: String {
        if _moveDescription == nil {
            _moveDescription = ""
        }
        return _moveDescription
    }
    
    var movePower: String {
        if _movePower == nil {
            _movePower = ""
        }
        return _movePower
    }
    
    var pokeName: String {
        return _pokeName
    }
    
    init(name: String, movesID: Int){
        self._name = name
        self._movesID = movesID
        _moveUrl = "\(URL_BASE)\(URL_MOVE)\(self._movesID)/"
    }
    

    func downloadPokemonDetails(completed: DownloadComplete) {
        //all the fields but one is being accessed from pokemon.co/api/v1/move/
        //the learntype field is being accessed via api/v2/move-learn-method
        let url = NSURL(string: _moveUrl)!
        Alamofire.request(.GET, url).responseJSON {response in
            let result = response.result
            // convert JSON into dictionary
            if let dict = result.value as? Dictionary<String, AnyObject> {
                // following is parsing the JSON dictionary, grabbing the data we want                
                if let accuracy = dict["accuracy"] as? Int {
                    self._moveAccuracy = "\(accuracy)"
                } else {
                    self._moveAccuracy = ""
                }
                
                if let description = dict["description"] as? String {
                    self._moveDescription = description
                } else {
                    self._moveDescription = ""
                }
                
                if let power = dict["power"] as? Int {
                    self._movePower = "\(power)"
                } else {
                    self._movePower = ""
                }
                
                if let pp = dict["pp"] as? Int {
                    self._movePP = "\(pp)"
                } else {
                    self._movePP = ""
                }
            }
            completed()
        }
    }
}