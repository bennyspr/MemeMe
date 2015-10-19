//
//  String+Custom.swift
//  MemeMe
//
//  Udacity iOS Developer Nanodegree
//  MemeMe v2.0 Project
//
//  Created by Benny on 9/28/15.
//  Copyright © 2015 Benny Rodriguez. All rights reserved.
//

import Foundation

extension String {
    
    public func trim() -> String {
        
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}