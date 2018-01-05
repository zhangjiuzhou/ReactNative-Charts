//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import Charts

open class BalloonMarker: MarkerImage
{
    @objc open var html: String?
    @objc open var formatters: [String:IAxisValueFormatter]?
    @objc open var color: UIColor?
    @objc open var insets = UIEdgeInsets()
    open var arrowSize = CGSize(width: 15, height: 11)
    open var minimumSize = CGSize()
    
    fileprivate var labelns: NSAttributedString?
    fileprivate var _labelSize: CGSize = CGSize()

    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        let size = self.size
        var point = point
        point.x -= size.width / 2.0
        point.y -= size.height
        return super.offsetForDrawing(atPoint: point)
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        if labelns == nil {
            return
        }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height

        context.saveGState()
        
        if let color = color {
            context.setFillColor(color.cgColor)
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0 - offset.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width / 2.0 - offset.x,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0 - offset.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }

        rect.origin.x += self.insets.left
        rect.origin.y += self.insets.top
        rect.size.width -= self.insets.left + self.insets.right
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)

        labelns?.draw(in: rect)

        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        if let html = self.html {
            do {
                let regExp = try NSRegularExpression.init(pattern: "\\{\\{([^}]+)\\}\\}", options: [])
                let matches = regExp.matches(in: html, options: [], range: NSMakeRange(0, html.characters.count))

                var string = html
                for match in matches {
                    let start = html.index(html.startIndex, offsetBy: match.range.location + 2)
                    let end = html.index(html.startIndex, offsetBy: match.range.location + match.range.length - 2)

                    let k = String(html[start..<end])!

                    var v: String = ""
                    if (k == "x" || k == "y") {
                        var val: Double? = nil
                        if (k == "x") {
                            val = entry.x
                        } else {
                            val = entry.y
                        }

                        if (val != nil) {
                            if let formatter = formatters?[k] {
                                v = formatter.stringForValue(val!, axis: nil)
                            } else {
                                v = String(val!)
                            }
                        }
                    } else {
                        if let data = entry.data as? [String:Any], let d = data[k] {
                            v = "\(d)"
                        }
                    }

                    string = string.replacingOccurrences(of: "{{\(k)}}", with: v)
                }

                let aStr = try NSAttributedString.init(data: string.data(using: String.Encoding.utf8)!,
                                                       options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
                                                       documentAttributes: nil)
                setLabel(aStr)
            } catch let error {
                print(error)
            }
        }
    }

    func setLabel(_ label: NSAttributedString)
    {
        labelns = label as NSAttributedString
        _labelSize = labelns?.boundingRect(with: CGSize(width: 140, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil).size ?? CGSize.zero

        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
