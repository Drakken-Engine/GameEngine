//
//  DKRCore.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import CoreGraphics

public class dCore {
	public static let instance: dCore = dCore()
	
	internal var device: MTLDevice
	internal var library: MTLLibrary!
	
	internal var cQueue: MTLCommandQueue
	
	internal var renderer: dRenderer!
	
	internal var bManager: dBufferManager
	internal var tManager: dTextureManager
	internal var trManager: dTransformManager
	internal var mtManager: dMaterialManager
	internal var shManager: dShaderManager
	internal var mshManager: dMeshManager
	internal var spManager: dSpriteManager
    internal var scManager: dSceneManager
    
    internal var allDebugLogs: [dLog] = []
    
    internal var ROOT_PATH: URL?
    internal var IMAGES_PATH: URL?
    internal var SCENES_PATH: URL?
    internal var SCRIPTS_PATH: URL?
	
	internal init() {
		self.device = MTLCreateSystemDefaultDevice()!
		self.cQueue = device.makeCommandQueue()
		
		self.bManager = dBufferManager()
		self.tManager = dTextureManager()
		self.trManager = dTransformManager()
		self.mtManager = dMaterialManager()
		self.shManager = dShaderManager()
		self.mshManager = dMeshManager()
		self.spManager = dSpriteManager()
        self.scManager = dSceneManager()

		self.renderer = dRenderer()
        
        self.ROOT_PATH = Bundle.main.url(forResource: "Assets", withExtension: nil)
        self.IMAGES_PATH = ROOT_PATH?.appendingPathComponent("images", isDirectory: true)
        self.SCENES_PATH = ROOT_PATH?.appendingPathComponent("scenes", isDirectory: true)
        self.SCRIPTS_PATH = ROOT_PATH?.appendingPathComponent("scripts", isDirectory: true)
		
		let bundle = Bundle.init(identifier: "drakkenstudio.DrakkenEngine")
		
		if let path = bundle!.path(forResource: "default", ofType: "metallib") {
			do
			{
				library = try self.device.makeLibrary(filepath: path)
			}
			catch MTLLibraryErrorDomain.internal
			{
				assert(false, "Bundle identifier incorrect!")
			}
			catch MTLLibraryErrorDomain.compileFailure
			{
				assert(false, "Compile failure")
			}
			catch MTLLibraryErrorDomain.compileWarning
			{
				assert(false, "Compile warning")
			}
			catch MTLLibraryErrorDomain.unsupported
			{
				assert(false, "Unsupported")
			}
			catch
			{
				assert(false, "default.metallib error!")
			}
		}
	}
    
    internal func loadRootPath(path: String) {
        self.ROOT_PATH = URL(string: path)?.appendingPathComponent("Assets")
        self.IMAGES_PATH = ROOT_PATH?.appendingPathComponent("images", isDirectory: true)
        self.SCENES_PATH = ROOT_PATH?.appendingPathComponent("scenes", isDirectory: true)
        self.SCRIPTS_PATH = ROOT_PATH?.appendingPathComponent("scripts", isDirectory: true)
    }
    
    internal func loadRootPath(url: URL) {
        self.ROOT_PATH = url.appendingPathComponent("Assets")
        self.IMAGES_PATH = ROOT_PATH?.appendingPathComponent("images", isDirectory: true)
        self.SCENES_PATH = ROOT_PATH?.appendingPathComponent("scenes", isDirectory: true)
        self.SCRIPTS_PATH = ROOT_PATH?.appendingPathComponent("scripts", isDirectory: true)
    }
}
