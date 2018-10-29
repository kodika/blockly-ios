//
//  FieldArgumentView.swift
//  Blockly
//
//  Created by Kostas Antonopoulos on 16/10/2018.
//

import Foundation

/**
 View for rendering a `FieldArgumentLayout`.
 */
@objc(BKYFieldArgumentView)
@objcMembers open class FieldArgumentView: FieldView {
    // MARK: - Properties
    
    /// Convenience property for accessing `self.layout` as a `FieldArgumentLayout`
    open var fieldArgumentLayout: FieldArgumentLayout? {
        return layout as? FieldArgumentLayout
    }
    
    /// The label to render
    fileprivate let label: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        label.lineBreakMode = .byClipping
        label.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        label.layer.borderColor = UIColor(red: 230/255, green: 234/255, blue: 238/255, alpha: 1.0).cgColor
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.textColor = UIColor(red: 0/255, green: 180/255, blue: 160/255, alpha: 1.0)
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Initializers
    
    /// Initializes the label field view.
    public required init() {
        super.init(frame: CGRect.zero)
        
        addSubview(label)
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
        
        guard let fieldArgumentLayout = self.fieldArgumentLayout else {
            return
        }
        
        runAnimatableCode(animated) {
            if flags.intersectsWith(Layout.Flag_NeedsDisplay) {
                let label = self.label
                label.text = fieldArgumentLayout.text
                label.font = fieldArgumentLayout.config.font(for: LayoutConfig.GlobalFont)
                label.layer.cornerRadius = fieldArgumentLayout.config.viewUnit(for: LayoutConfig.FieldCornerRadius)

            }
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.frame = CGRect.zero
        self.label.text = ""
    }
}

// MARK: - FieldLayoutMeasurer implementation

extension FieldArgumentView: FieldLayoutMeasurer {
    public static func measureLayout(_ layout: FieldLayout, scale: CGFloat) -> CGSize {
        guard let fieldLabelLayout = layout as? FieldArgumentLayout else {
            bky_assertionFailure("`layout` is of type `\(type(of: layout))`. " +
                "Expected type `FieldArgumentLayout`.")
            return CGSize.zero
        }
        
        let font = layout.config.font(for: LayoutConfig.GlobalFont)
        var size = fieldLabelLayout.text.bky_singleLineSize(forFont: font)
        size.height = max(size.height, layout.config.viewUnit(for: LayoutConfig.FieldMinimumHeight))
        size.width += 10
        return size
    }
}
