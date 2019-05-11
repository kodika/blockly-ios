/*
* Copyright 2015 Google Inc. All Rights Reserved.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation

/**
View for rendering a `FieldLabelLayout`.
*/
@objc(BKYFieldLabelView)
@objcMembers open class FieldLabelView: FieldView {
  // MARK: - Properties

  /// Convenience property for accessing `self.layout` as a `FieldLabelLayout`
  open var fieldLabelLayout: FieldLabelLayout? {
    return layout as? FieldLabelLayout
  }

  /// The label to render
  fileprivate let label: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    label.lineBreakMode = .byClipping
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

    guard let fieldLabelLayout = self.fieldLabelLayout else {
      return
    }

    runAnimatableCode(animated) {
      if flags.intersectsWith(Layout.Flag_NeedsDisplay) {
        let label = self.label
        label.text = fieldLabelLayout.text
        
        let parentBlock = FieldLabelView.parentBlock(of: fieldLabelLayout)
        label.textColor = parentBlock.color
        label.font = FieldLabelView.labelFont(fieldLabelLayout: fieldLabelLayout, isShadow: parentBlock.shadow)
      }
    }
  }

  open override func prepareForReuse() {
    super.prepareForReuse()

    self.frame = CGRect.zero
    self.label.text = ""
  }
    
  fileprivate static func parentBlock(of fieldLabelLayout: FieldLabelLayout) -> Block {
    return (fieldLabelLayout.parentLayout!.parentLayout as! DefaultBlockLayout).block
  }
    
  fileprivate static func labelFont(fieldLabelLayout:FieldLabelLayout, isShadow: Bool) -> UIFont {
    if isShadow{
      return fieldLabelLayout.config.font(for: LayoutConfig.PopoverTitleFont)
    }else{
      return fieldLabelLayout.config.font(for: LayoutConfig.GlobalFont)
    }
  }
}

// MARK: - FieldLayoutMeasurer implementation

extension FieldLabelView: FieldLayoutMeasurer {
  public static func measureLayout(_ layout: FieldLayout, scale: CGFloat) -> CGSize {
    guard let fieldLabelLayout = layout as? FieldLabelLayout else {
      bky_assertionFailure("`layout` is of type `\(type(of: layout))`. " +
        "Expected type `FieldLabelLayout`.")
      return CGSize.zero
    }

    let font = FieldLabelView.labelFont(fieldLabelLayout: fieldLabelLayout, isShadow: parentBlock(of: fieldLabelLayout).shadow)
    var size = fieldLabelLayout.text.bky_singleLineSize(forFont: font)
    size.height = max(size.height, layout.config.viewUnit(for: LayoutConfig.FieldMinimumHeight))
    return size
  }
}
