//
//  CoreAppData.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/14/24.
//

import SwiftUI

let Heights = BarInfo(name: "The Heights Bar and Grill", address: "2867 Broadway, New York, NY 10025", img: Image("heights"), latitude: 40.805220, longitude: -73.966370, bar_id: 1)
let TenTwenty = BarInfo(name: "1020 Bar", address: "1020 Amsterdam Ave, New York, NY 10025", img: Image("tentwenty"), latitude: 40.803379, longitude: -73.964012, bar_id: 2)
let Amity = BarInfo(name: "Amity Hall Uptown", address: "982 Amsterdam Ave, New York, NY 10025", img: Image("amity"), latitude: 40.802292, longitude: -73.964737, bar_id: 3)
let LionsHead = BarInfo(name: "Lion's Head Tavern", address: "995 Amsterdam Ave, New York, NY 10025", img: Image("lionshead"), latitude: 40.802132, longitude: -73.964058, bar_id: 4)
let ArtsAndCrafts = BarInfo(name: "Arts and Crafts Beer Parlor", address: "1135 Amsterdam Ave, New York, NY 10025", img: Image("artsandcrafts"), latitude: 40.806568, longitude: -73.961006, bar_id: 5)

let allBars : [BarInfo] = [Heights, TenTwenty, Amity, LionsHead, ArtsAndCrafts]

var realUser = UserInfo(email: "", username: "", profPicURL: "")
let emptyUserObservable = UserData()
