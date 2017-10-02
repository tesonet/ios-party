//
//  FancyButton.swift
//  Server Browser
//
//  Created by Tanya on 10/2/17.
//  Copyright © 2017 Slava. All rights reserved.
//

import Cocoa

class FancyButton: NSButton {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func setBackgroundColor(_ color: NSColor) {
        let size = self.frame.size
        let image = NSImage(size: size)
        image.lockFocus()
        let rect = NSMakeRect(0, 0, size.width, size.height)
        color.drawSwatch(in: rect)
        image.unlockFocus()
        self.image = image
    }
    
    func setText(_ text: String, font: NSFont, color: NSColor) {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.alignment = .center
        let range = NSRange.init(location: 0,
                                 length: (text.lengthOfBytes(using: String.Encoding.utf8)))
        let attributedTitle = NSMutableAttributedString.init(string: text)
        attributedTitle.addAttribute(NSParagraphStyleAttributeName,
                                     value: paragraphStyle,
                                     range: range)
        attributedTitle.addAttribute(NSForegroundColorAttributeName,
                                     value: color,
                                     range: range)
        attributedTitle.addAttribute(NSFontAttributeName,
                                     value: font,
                                     range: range)
        self.attributedTitle = attributedTitle
    }
    
    func setBorderAttributes(color: NSColor,
                             borderWidth: CGFloat,
                             cornerRadius: CGFloat) {
        self.isBordered = true
        self.layer?.masksToBounds = true
        self.layer?.borderColor = color.cgColor
        self.layer?.borderWidth = borderWidth
        self.layer?.cornerRadius = cornerRadius
    }
    
    // MARK: - Private
    
    private func setupButton() {
        cell = NSButtonCell()
        wantsLayer = true
        setButtonType(.momentaryChange)
        bezelStyle = .texturedSquare
        isBordered = false
    }
}
