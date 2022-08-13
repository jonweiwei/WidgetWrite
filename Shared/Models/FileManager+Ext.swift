//
//  FileManager+Ext.swift
//  WidgetWrite
//
//  Created by Jonathan Wei on 2022-08-12.
//

import Foundation

extension FileManager {
    static let appGroupContainerURL = FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.com.widgetwrite")!
}

extension FileManager {
    static let drawingFileName = "Drawing.txt"
}
