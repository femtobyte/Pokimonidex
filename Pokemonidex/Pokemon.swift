//
//  Pokemon.swift
//  Pokemonidex
//
//  Created by C Sinclair on 1/19/16.
//  Copyright © 2016 femtobyte. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    //  never use an ! when declaring a var unless you absolutely know there will be a variable in there
    //  since we are guaranteeing there will be a value in these var, and the api may or may not provide a value, we
    //  will create computed properties for them
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
   
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
  
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
  
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
  
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
        print("\(_pokemonUrl)")
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON {response in
            let result = response.result
            // convert JSON into dictionary
            if let dict = result.value as? Dictionary<String, AnyObject> {
                // following is parsing the JSON dictionary, grabbing the data we want
                // need to grab it just as it's written in the JSON file, and it has to be the same type - which is sometimes hard to tel
                // so print results to test.
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                // in the Pokemon API, the types is an array.
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    // grabs the name property out of the first slot of types dictionary array
                    if let name = types[0]["name"]{
                        self._type = name.capitalizedString
                    }
                    
                //  if there are any more types, this will add them to the string along with a forward slash.  Some pokemon have no 
                //  type, sometimes they have 1, sometimes 2, don't think they have more than 2 ever.
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types [x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    } else {
                        self._type = ""
                    }
                    print(self._type)
                }
               
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let evolution = evolutions[0]["to"] as? String {
                        // this api has some mega pokemon that this app will not be supporting so ruling them out
                        if evolution.rangeOfString("mega") == nil {
                            // getting uri so we can extract the pokemon id from it
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                // strips off extra text from string so just number is there
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionID = num
                                self._nextEvolutionTxt = evolution
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                            }
                        }
                    } else {
                        print("evolution 'to' not found")
                    }
                } else {
                    print("evolutions array not found")
                }
                
                if let descArray = dict["descriptions"] as? [Dictionary<String, String>] where descArray.count > 0  {
                    if let url = descArray[0]["resource_uri"]{
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let descResult = response.result
                            if let descDict = descResult.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            completed() // calling completed after second download from descriptions is done
                        }
                    }
                }
            }
        }
    }
}