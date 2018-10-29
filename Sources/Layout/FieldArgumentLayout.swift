//
//  FieldArgumentLayout.swift
//  Blockly
//
//  Created by Kostas Antonopoulos on 16/10/2018.
//

import Foundation

/**
 Class for a `FieldArgument`-based `Layout`.
 */
@objc(BKYFieldArgumentLayout)
@objcMembers open class FieldArgumentLayout: FieldLayout {
    
    // MARK: - Properties
    
    /// The `FieldArgument` that backs this layout
    private let fieldArgument: FieldArgument
    
    /// The value that should be used when rendering this layout
    open var text: String {
        return fieldArgument.text
    }
    
    // MARK: - Initializers
    
    /**
     Initializes the argument field layout.
     
     - parameter fieldArgument: The `FieldArgument` model for this layout.
     - parameter engine: The `LayoutEngine` to associate with the new layout.
     - parameter measurer: The `FieldLayoutMeasurer.Type` to measure this layout.
     */
    public init(fieldArgument: FieldArgument, engine: LayoutEngine, measurer: FieldLayoutMeasurer.Type) {
        self.fieldArgument = fieldArgument
        super.init(field: fieldArgument, engine: engine, measurer: measurer)
    }
}
