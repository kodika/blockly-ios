//
//  FieldImageAsset.swift
//  Blockly
//
//  Created by Kostas Antonopoulos on 29/05/2018.
//

import Foundation

@objc(BKYFieldImageAssetLooader)
public protocol FieldImageAssetLooader: class {
    func loadImage(uniqueId: String? ,completion: @escaping ((_ image: UIImage?) -> Void))
}

/**
 An imageAsset field used to display a stored Asset.
 */
@objc(BKYFieldImageAsset)
@objcMembers public final class FieldImageAsset: Field {
    
    // MARK: - Properties
 
    /// The `WorkspaceSize` of this field.
    public var size: WorkspaceSize {
        didSet { didSetProperty(size, oldValue) }
    }
    
    /// A unique identifier used to identify this imageAsset
    public var uniqueId: String? {
        didSet { didSetProperty(uniqueId, oldValue) }
    }
    
    /// Default image to be used when uniqueId is nil
    open var defaultImage : UIImage
    
    /// Loader to be used to load image from imageAsset `uniqueId`
    weak open var imageAssetLoader : FieldImageAssetLooader?
    
    // MARK: - Initializers
    
    /**
     Initializes the image field.
     
     - parameter name: The name of this field.
     - parameter imageLocation: The location of the image in this field. Specifies the location of a
     local image resource, either as an image asset name or a location relative to the main resource
     bundle of the app. As a fallback, this can specify the location of a URL web image to fetch.
     - parameter altText: The alt text for this field.
     - parameter flipRtl: Flag determining if this image should be flipped horizontally in RTL
     rendering.
     */
    public init(
        name: String, defaultImage: UIImage, size: WorkspaceSize, imageAssetLoader: FieldImageAssetLooader?) {
        self.defaultImage = defaultImage
        self.imageAssetLoader = imageAssetLoader
        self.size = size
        
        super.init(name: name)
    }
    
    // MARK: - Super
    
    public override func copyField() -> Field {
        return FieldImageAsset(name: name, defaultImage: defaultImage, size:size, imageAssetLoader: imageAssetLoader)
    }
    
    public override func setValueFromSerializedText(_ text: String) throws {
        uniqueId = text
    }
    
    public override func serializedText() throws -> String? {
        // Return nil. Images shouldn't be serialized.
        return uniqueId
    }
}
