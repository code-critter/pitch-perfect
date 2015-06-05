//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by W N Barker on 5/24/15.
//  Copyright (c) 2015 W N Barker. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(title: String, filePathUrl: NSURL){
        
        self.filePathUrl = filePathUrl
        
        self.title = title
        
    }
    
    
    
    
}
