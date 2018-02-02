//
//  DesignableButton.swift
//  DesignableButton
//
//  Created by Nicolas Pinon on 02/02/2018.
//  Copyright © 2018 Nicolas Pinon. All rights reserved.
//

import UIKit

@IBDesignable
open class DesignableButton: UIButton {
    
    required public init(style buttonStyle: String) {
        super.init(frame: .zero)
        self.buttonStyle = buttonStyle
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open func getStyles() -> [String: (DesignableButton) -> Void] {
        return DesignableButton.styles
    }
    
    open static var styles = ["": { (designableButton: DesignableButton) -> Void in
        // default "none" style
        if designableButton.isHighlighted || designableButton.isSelected {
            designableButton.backgroundColor = designableButton.selectedColor
        } else if designableButton.isEnabled {
            designableButton.backgroundColor = designableButton.defaultColor
        }
        else {
            designableButton.backgroundColor = designableButton.disabledColor
        }
        designableButton.layer.cornerRadius = designableButton.cornerRadius ?? 0
        designableButton.layer.borderWidth = designableButton.borderWidth ?? 0
        designableButton.layer.borderColor = designableButton.borderColor?.cgColor
        }]
    
    
    public static func setStyle(style: @escaping (DesignableButton) -> Void, for key: String) {
        self.styles.updateValue(style, forKey: key.lowercased())
    }
    
    open func setStyleForAll() {
        self.reversesTitleShadowWhenHighlighted = false
        self.showsTouchWhenHighlighted = false
        self.adjustsImageWhenHighlighted = false
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateStyles()
    }
    
    @IBInspectable open var buttonStyle: String = "" {
        didSet {
            self.updateStyles()
        }
    }
    
    @IBInspectable open var defaultColor: UIColor? {
        didSet {
            self.updateStyles()
        }
    }
    @IBInspectable open var selectedColor: UIColor? {
        didSet {
            self.updateStyles()
        }
    }
    @IBInspectable open var disabledColor: UIColor? {
        didSet {
            self.updateStyles()
        }
    }
    open var cornerRadius: CGFloat? {
        return _cornerRadius != -1 ? _cornerRadius : nil
    }
    @IBInspectable open var borderColor: UIColor? {
        didSet {
            self.updateStyles()
        }
    }
    
    @IBInspectable open var _cornerRadius: CGFloat = -1 {
        didSet {
            self.updateStyles()
        }
    }
    
    @IBInspectable open var _borderWidth: CGFloat = -1 {
        didSet {
            self.updateStyles()
        }
    }
    open var borderWidth: CGFloat? {
        return _borderWidth != -1 ? _borderWidth : nil
    }
    
    @IBInspectable open var customTextColor: UIColor? {
        didSet {
            self.updateStyles()
        }
    }
    
    @IBInspectable open override var isHighlighted: Bool {
        didSet {
            self.updateStyles()
        }
    }
    @IBInspectable open override var isSelected: Bool {
        didSet {
            self.updateStyles()
        }
    }
    @IBInspectable open override var isEnabled: Bool {
        didSet {
            self.updateStyles()
        }
    }
    
    open func updateStyles() {
        
        if self.buttonStyle.count > 0 {
            self.setStyleForAll()
        }
        
        if let styleBlock = self.getStyles()[self.buttonStyle.lowercased()] as ((DesignableButton)->Void)! {
            styleBlock(self)
        }
        
        layer.masksToBounds = layer.cornerRadius > 0
        
        assert(self.buttonType == UIButtonType.custom, "Designable Button \"\(self.titleLabel?.text ?? "?")\" buttonType must be Custom") // here
    }
}

// helper to put icon above text
public extension UIButton {
    
    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
}
