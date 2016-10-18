//
//  DKRGameView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 25/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Foundation
import Metal
import MetalKit

internal enum LOOPSTATE {
    case PLAY
    case PAUSE
    case STOP
}

internal class dGameViewDelegate: NSObject, MTKViewDelegate {
	typealias updateFunction = () -> Void
	
	private var _firstStep: Bool = true
	
	fileprivate var _updateFunction: updateFunction?
	fileprivate var _scene: dScene = dScene()
	
    private var simpleRender: dSimpleSceneRender!
    
    internal var state: LOOPSTATE = LOOPSTATE.PLAY
	
	func start() {
		simpleRender = dSimpleSceneRender(scene: _scene)
        simpleRender.start()
        _firstStep = true
	}
	
	func draw(in view: MTKView) {
		if view.device == nil {
			view.device =  dCore.instance.device
		}
		
		if _firstStep {
			self.mtkView(view, drawableSizeWillChange: view.drawableSize)
			_firstStep = false
		}
		
		if _updateFunction != nil {
			_updateFunction!()
		}
		
		if let currentDrawable = view.currentDrawable {
			if _scene.transforms.count > 0 {
                if state == LOOPSTATE.PLAY {
                    simpleRender.update(deltaTime: 0.016)
                }
				simpleRender.draw(drawable: currentDrawable)
			} else {
				let id = dCore.instance.renderer.startFrame(currentDrawable.texture)
				dCore.instance.renderer.endFrame(id)
				dCore.instance.renderer.present(currentDrawable)
			}
		}
        
        #if os(iOS)
            if Float(UIScreen.main.scale) != self._scene.scale {
                self._scene.scale = Float(UIScreen.main.scale)
            }
        #endif
        #if os(tvOS)
            if Float(UIScreen.main.scale) != self._scene.scale {
                self._scene.scale = Float(UIScreen.main.scale)
            }
        #endif
        #if os(OSX)
            if let scale = NSScreen.main()?.backingScaleFactor {
                if Float(scale) != self._scene.scale {
                    self._scene.scale = Float(scale)
                }
            }
        #endif
	}
	
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		#if os(tvOS)
			self._scene.size = float2(1920.0, 1080.0)
		#else
			self._scene.size.x = Float(size.width)
			self._scene.size.y = Float(size.height)
		#endif
	}
}

open class dGameView: MTKView {
    private var _gameView: dGameViewDelegate!
    
    internal var state: LOOPSTATE {
        get {
            return _gameView.state
        }
        set {
            _gameView.state = newValue
        }
    }
	
	internal(set) public var scene: dScene {
		get {
			return self._gameView._scene
		}
        set {
            self._gameView._scene = newValue
        }
	}
	
	override public init(frame frameRect: CGRect, device: MTLDevice?) {
		super.init(frame: frameRect, device: dCore.instance.device)
		self._start()
	}
	
	required public init(coder: NSCoder) {
		super.init(coder: coder)
		self._start()
	}
	
	private func _start() {
		self.device = dCore.instance.device
		self.sampleCount = 4
		
		#if os(iOS)
			if #available(iOS 10.0, *) {
				self.colorPixelFormat = .bgra10_XR_sRGB
			} else {
				self.colorPixelFormat = .bgra8Unorm
			}
		#endif
		#if os(tvOS)
			if #available(tvOS 10.0, *) {
				self.colorPixelFormat = .bgra10_XR_sRGB
			} else {
				self.colorPixelFormat = .bgra8Unorm
			}
		#endif
		#if os(OSX)
			if #available(OSX 10.12, *) {
				self.colorPixelFormat = .bgra8Unorm_srgb
			} else {
				self.colorPixelFormat = .bgra8Unorm
			}
		#endif
		
		_gameView = dGameViewDelegate()
		_gameView._updateFunction = self.update
	}
	
    public func load(scene: String) {
        self._gameView._scene.load(jsonFile: scene)
        self.Init()
    }
    
    public func load(sceneURL: URL) {
        self._gameView._scene.load(url: sceneURL)
        self.Init()
    }
    
    public func Init() {
        self.start()
        _gameView.start()
        self.delegate = _gameView
    }
    
	open func update() {
		
	}
	
	open func start() {
		//Override this method to create your scene on startup
	}
}
