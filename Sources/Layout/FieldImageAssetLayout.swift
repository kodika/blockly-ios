//
//  FieldImageAssetLayout.swift
//  Blockly
//
//  Created by Kostas Antonopoulos on 29/05/2018.
//

import Foundation

/**
 Class for a `FieldImageAsset`-based `Layout`.
 */
@objc(BKYFieldImageAssetLayout)
@objcMembers open class FieldImageAssetLayout: FieldLayout {
    
    // MARK: - Properties
    
    /// The `FieldImageAsset` that backs this layout
    private let fieldImageAsset: FieldImageAsset
    
    /// The size of the image field, expressed as a Workspace coordinate system size
    open var size: WorkspaceSize {
        return fieldImageAsset.size
    }

    // MARK: - Initializers
    
    /**
     Initializes the image field layout.
     
     - parameter fieldImageAsset: The `FieldImageAsset` model for this layout.
     - parameter engine: The `LayoutEngine` to associate with the new layout.
     - parameter measurer: The `FieldLayoutMeasurer.Type` to measure this layout.
     */
    public init(fieldImageAsset: FieldImageAsset, engine: LayoutEngine, measurer: FieldLayoutMeasurer.Type) {
        self.fieldImageAsset = fieldImageAsset
        super.init(field: fieldImageAsset, engine: engine, measurer: measurer)
    }
    
    // MARK: - Public
    
    /**
     Asynchronously loads this layout's image in the background and executes a callback on the main
     thread with the loaded image.
     
     - parameter completion: The callback method that will be executed on completion of this method.
     The `image` parameter of the callback method contains the `UIImage` that was loaded. If it is
     `nil`, the image could not be loaded.
     */
    open func loadImage(completion: @escaping ((_ image: UIImage?) -> Void)) {
        // Load image in the background
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { () -> Void in

            //Load image using `imageAssetLoader`
            self.fieldImageAsset.imageAssetLoader?.loadImage(uniqueId: self.fieldImageAsset.uniqueId, completion: { (image) in
                // Execute the callback on the main thread
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(image)
                })
            })

        }
    }
}
