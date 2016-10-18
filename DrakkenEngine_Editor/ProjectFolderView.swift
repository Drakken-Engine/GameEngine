//
//  ProjectFolderView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 18/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

internal class FolderItem {
    var icon: NSImage
    var name: String
    var url: URL
    var children: [FolderItem]
    
    internal init(icon: NSImage, name: String, url: URL, children: [FolderItem]) {
        self.icon = icon
        self.name = name
        self.url = url
        self.children = children
    }
}

internal class RootItem: FolderItem {}

class ProjectFolderView: NSOutlineView, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    private var itens: [RootItem] = [RootItem]()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.dataSource = self
        self.delegate = self
        
        doubleAction = #selector(self.doubleActionSelector)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if self.tableColumns[0].width != superview!.frame.width - 2 {
            self.tableColumns[0].minWidth = superview!.frame.width - 2
            self.tableColumns[0].maxWidth = superview!.frame.width - 2
            self.tableColumns[0].width = superview!.frame.width - 2
        }
        
        super.draw(dirtyRect)
    }
    
    internal func doubleActionSelector() {
        let item = self.item(atRow: clickedRow) as! FolderItem
        let url = item.url
        
        if NSApplication.shared().mainWindow!.contentViewController is EditorViewController {
            let editorVC = NSApplication.shared().mainWindow!.contentViewController as! EditorViewController
            if url.pathExtension == "dkscene" {
                editorVC.editorView.scene.load(url: url)
                editorVC.editorView.Init()
            }
        }
    }
    
    internal func loadData(for url: URL) {
        let rootItens = getItens(from: url)
        itens.removeAll()
        
        for i in rootItens {
            let rootItem = RootItem(icon: i.icon, name: i.name, url: i.url, children: [FolderItem]())
            itens.append(rootItem)
            
            loadItem(from: i.url, at: rootItem)
        }
        
        self.reloadData()
    }
    
    internal func loadItem(from url: URL, at: FolderItem) {
        let contentItens = getItens(from: url)
        
        for i in contentItens {
            let item = FolderItem(icon: i.icon, name: i.name, url: i.url, children: [FolderItem]())
            at.children.append(item)
            
            loadItem(from: i.url, at: item)
        }
    }
    
    internal func getItens(from url: URL) -> [(icon: NSImage, name: String, url: URL)] {
        if !url.hasDirectoryPath {
            return []
        }
        
        let fileManager = FileManager()
        var contentItens = [(icon: NSImage, name: String, url: URL)]()
        
        let enumerator = fileManager.enumerator(at: url,
                                                includingPropertiesForKeys: [URLResourceKey.effectiveIconKey,URLResourceKey.localizedNameKey],
                                                options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
                                                        .union(FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)
                                                        .union(FileManager.DirectoryEnumerationOptions.skipsPackageDescendants),
                                                errorHandler: { (u, error) -> Bool in
                                                    NSLog("URL: \(u.path) - Error: \(error)")
                                                    return false
        })
        
        while let u = enumerator?.nextObject() as? URL {
            do{
                
                let properties = try u.resourceValues(forKeys: [URLResourceKey.effectiveIconKey,URLResourceKey.localizedNameKey]).allValues
                
                let icon = properties[URLResourceKey.effectiveIconKey] as? NSImage ?? NSImage()
                let name = properties[URLResourceKey.localizedNameKey] as? String ?? " "
                
                contentItens.append((icon: icon, name: name, url: u))
            }
            catch {
                NSLog("Error reading file attributes")
            }
        }
        
        return contentItens
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item != nil {
            if let i = item as? FolderItem {
                return i.children.count
            }
        }
        
        return itens.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item != nil {
            if let i = item as? FolderItem {
                return i.children[index]
            }
        }
        
        
        return itens[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let i = item as? FolderItem {
            return i.children.count > 0
        }
        
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var image:NSImage?
        var text:String = ""
        var cellIdentifier: String = ""
        
        if let i = item as? FolderItem {
            if tableColumn == outlineView.tableColumns[0] {
                image = i.icon
                text = i.name
                cellIdentifier = "FolderItemID"
            }
            
            if let cell = outlineView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = text
                cell.imageView?.image = image ?? nil
                return cell
            }
        }
        
        return nil
    }
}