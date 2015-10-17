//
//  String+Custom.swift
//  MemeMe
//
//  Udacity.com MemeMe v1.0 Project
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