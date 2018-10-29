//
//  FieldArgument.swift
//  Blockly
//
//  Created by Kostas Antonopoulos on 16/10/2018.
//

import Foundation

/**
 Non-editable argument. Used for block and function arguments
 */
@objc(BKYFieldArgument)
@objcMembers public final class FieldArgument: Field {
    // MARK: - Properties
    
    /// The text label of the field
    public var text: String {
        didSet {
            if text != oldValue {
                notifyDidUpdateField()
            }
        }
    }
    
    public var methodUniqueIdentifier: String
    
    // MARK: - Initializers
    
    /**
     Initializes the label field.
     
     - parameter name: The name of this field.
     - parameter text: The initial text of this field.
     */
    public init(name: String, text: String, methodUniqueIdentifier: String) {
        self.text = text
        self.methodUniqueIdentifier = methodUniqueIdentifier
        super.init(name: name)
    }
    
    // MARK: - Super
    
    public override func copyField() -> Field {
        return FieldArgument(name: name, text: text, methodUniqueIdentifier: methodUniqueIdentifier)
    }
    
    public override func setValueFromSerializedText(_ text: String) throws {
        throw BlocklyError(.illegalState, "Argument field text cannot be set after construction.")
    }
    
    public override func serializedText() throws -> String? {
        // Return nil. Labels shouldn't be serialized.
        return nil
    }
}
