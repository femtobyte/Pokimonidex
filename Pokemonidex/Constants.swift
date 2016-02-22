//
//  Constants.swift
//  Pokemonidex
//
//  Created by C Sinclair on 1/26/16.
//  Copyright © 2016 femtobyte. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co/"
let URL_POKEMON = "api/v1/pokemon/"
let URL_MOVE = "api/v1/move/"

// creating our own simple download closure.  returns nothing.
// we call this to let our app know when our download is complete
typealias DownloadComplete = () -> ()
