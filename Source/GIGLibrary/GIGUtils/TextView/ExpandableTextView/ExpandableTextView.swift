//
//  ExpandableTextView.xib.swift
//  GIGLibrary
//
//  Created by Jerilyn Goncalves on 11/04/2017.
//  Copyright © 2017 Gigigo SL. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
open class ExpandableTextView: UIView {
    
    // MARK: IBOutlet
    @IBOutlet weak open var stackView: UIStackView!
    @IBOutlet weak open var hyperlinkTextView: HyperlinkTextView!
    
    // MARK: - Public properties
    
    open var isCollapsed: Bool = true
    
    // MARK: - Private properties
    
    private var shortText: String?
    private var longText: String?
    
    // MARK: - Public methods
    
    ///  Use this method to create an instance of ExpandableTextView and set all its properties.
    ///  **Note**: Avoid creating instances with the `init()` method`.
    ///
    /// - Parameters:
    ///   - shortText: Title for the alert
    ///   - longText: Message for the alert
    /// - Returns: The `ExpandableTextView` instance
    open class func instantiate(shortText: String, longText: String, hyperlinkDelegate: HyperlinkTextViewDelegate?) -> ExpandableTextView? {
        let expandableTextView = self.instantiate()
        expandableTextView?.shortText = shortText
        expandableTextView?.longText = longText
        expandableTextView?.hyperlinkTextView.hyperlinkDelegate = hyperlinkDelegate
        expandableTextView?.setup()
        return expandableTextView
    }
    
    open func collapse() {
        guard !self.isCollapsed else { return }
        self.isCollapsed = true
        guard let shortText = self.shortText else { return }
        self.hyperlinkTextView.setText(htmlText: shortText)
    }
    
    open func expand() {
        guard self.isCollapsed else { return }
        self.isCollapsed = false
        guard
            let shortText = self.shortText,
            let longText = self.longText else { return }
        self.hyperlinkTextView.setText(htmlText: shortText + "<br>" + longText)
    }
    
    // MARK: - Private methods
    
    private class func instantiate() -> ExpandableTextView? {
        guard let expandableTextView = Bundle(for: ExpandableTextView.self).loadNibNamed("ExpandableTextView", owner: self, options: nil)?.first as? ExpandableTextView else {
            return ExpandableTextView()
        }
        return expandableTextView
    }
    
    // MARK: - Private helpers
    
    private func setup() {
        guard let shortText = self.shortText else { return }
        self.hyperlinkTextView.setText(htmlText: shortText)
    }
}
