//
//  File.swift
//  
//
//  Created by 임현규 on 2024/03/02.
//

import UIKit

public protocol ChartDrawProtocol {
    func draw()
    func fetchData(data: ChartData?)
}

extension ChartDrawProtocol {
    func drawText(context: CGContext,
                 position: CGPoint,
                 text: String,
                 fontSize: CGFloat = 15,
                 width: CGFloat,
                 alignmentMode: NSTextAlignment = .center) {
        context.saveGState()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignmentMode
        
        let attrs: [NSAttributedString.Key: Any?] = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: fontSize),
            NSAttributedString.Key.paragraphStyle: paragraphStyle, .foregroundColor: UIColor.systemGray
        ]

        text.draw(
            with: CGRect(x: position.x, y: position.y, width: width, height: fontSize),
            options: .usesLineFragmentOrigin, attributes: attrs, context: nil
        )
        
        context.restoreGState()
    }
}
