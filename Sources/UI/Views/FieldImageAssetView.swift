//
//  FieldImageAssetView.swift
//  Blockly
//
//  Created by Kostas Antonopoulos on 29/05/2018.
//

import Foundation

/**
 View for rendering a `FieldImageAssetLayout`.
 */
@objc(BKYFieldImageAssetView)
@objcMembers open class FieldImageAssetView: FieldView {
    // MARK: - Properties
    
    /// Convenience property for accessing `self.layout` as a `FieldImageAssetLayout`
    open var fieldImageAssetLayout: FieldImageAssetLayout? {
        return layout as? FieldImageAssetLayout
    }
    
    /// The image to render
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.bounds
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initializers
    
    /// Initializes the image field view.
    public required init() {
        super.init(frame: CGRect.zero)
        
        addSubview(imageView)
    }
    
    /**
     :nodoc:
     - Warning: This is currently unsupported.
     */
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Called unsupported initializer")
    }
    
    // MARK: - Super
    
    open override func refreshView(
        forFlags flags: LayoutFlag = LayoutFlag.All, animated: Bool = false)
    {
        super.refreshView(forFlags: flags, animated: animated)
        
        guard let fieldImageAssetLayout = self.fieldImageAssetLayout else {
            return
        }
        
        runAnimatableCode(animated) {
            if flags.intersectsWith(Layout.Flag_NeedsDisplay) {
                fieldImageAssetLayout.loadImage(completion: { (image) in
                    if let image = image{
                        self.imageView.image = image
                    }else{
                        self.imageView.image = (fieldImageAssetLayout.field as! FieldImageAsset).defaultImage
                    }
                    
                })
            }
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.frame = CGRect.zero
        self.imageView.image = (fieldImageAssetLayout?.field as? FieldImageAsset)?.defaultImage
    }
}

// MARK: - FieldLayoutMeasurer implementation

extension FieldImageAssetView: FieldLayoutMeasurer {
    public static func measureLayout(_ layout: FieldLayout, scale: CGFloat) -> CGSize {
        guard let fieldImageAssetLayout = layout as? FieldImageAssetLayout else {
            bky_assertionFailure("`layout` is of type `\(type(of: layout))`. " +
                "Expected type `FieldImageAssetLayout`.")
            return CGSize.zero
        }
        
        return layout.engine.viewSizeFromWorkspaceSize(fieldImageAssetLayout.size)
    }
}
