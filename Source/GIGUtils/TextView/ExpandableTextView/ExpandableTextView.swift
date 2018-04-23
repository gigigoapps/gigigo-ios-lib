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
    @IBOutlet weak open var expandButton: UIButton!
    
    // MARK: - Private properties
    
    private var isCollapsed: Bool = true
    private var shortText: String?
    private var longText: String?
    private var collapseText: String?
    private var expandText: String?
    
    // MARK: - Public methods
    
    ///  Use this method to create an instance of ExpandableTextView and set all its properties.
    ///  **Note**: Avoid creating instances with the `init()` method`.
    ///
    /// - Parameters:
    ///   - shortText: Title for the alert
    ///   - longText: Message for the alert
    /// - Returns: The `ExpandableTextView` instance
    open class func instantiate(shortText: String, longText: String, collapseText: String, expandText: String, hyperlinkDelegate: HyperlinkTextViewDelegate?) -> ExpandableTextView? {
        let expandableTextView = self.instantiate()
        expandableTextView?.shortText = shortText
        expandableTextView?.longText = longText
        expandableTextView?.collapseText = collapseText
        expandableTextView?.expandText = expandText
        expandableTextView?.hyperlinkTextView.hyperlinkDelegate = hyperlinkDelegate
        expandableTextView?.setup()
        return expandableTextView
    }
    
    open func collapse() {
        guard !self.isCollapsed else { return }
        self.isCollapsed = true
        guard
            let shortText = self.shortText,
            let expandText = self.expandText else { return }
        self.hyperlinkTextView.setText(htmlText: shortText)
        self.expandButton.setTitle(expandText, for: .normal)
    }
    
    open func expand() {
        guard self.isCollapsed else { return }
        self.isCollapsed = false
        guard
            let shortText = self.shortText,
            let longText = self.longText,
            let collapseText = self.collapseText else { return }
        self.hyperlinkTextView.setText(htmlText: shortText + "<br>" + longText)
        self.expandButton.setTitle(collapseText, for: .normal)
    }
    
    // MARK: - Private methods
    
    private class func instantiate() -> ExpandableTextView? {
        guard let expandableTextView = Bundle(identifier: "com.gigigo.GIGLibrary")?.loadNibNamed("ExpandableTextView", owner: self, options: nil)?.first as? ExpandableTextView else {
            return ExpandableTextView()
        }
        return expandableTextView
    }
    
    // MARK: - Private helpers
    
    private func setup() {
        guard
            let shortText = self.shortText,
            let expandText = self.expandText else { return }
        self.hyperlinkTextView.setText(htmlText: shortText)
        self.expandButton.setTitle(expandText, for: .normal)
    }
}
