//
//  ViewController.swift
//  Highlight
//
//  Created by Nghia Tran on 7/4/18.
//  Copyright © 2018 com.nsproxy.proxy. All rights reserved.
//

import Cocoa
import Highlightr
import TinyConstraints

/*
class ViewController: NSViewController {

    let textStorage = CodeAttributedString()
    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textStorage.language = "json"
        textStorage.highlightr.setTheme(to: "atom-one-dark")
        textStorage.highlightr.theme.codeFont = NSFont.systemFont(ofSize: 14.0)

        print(textStorage.highlightr.supportedLanguages())
        print(textStorage.highlightr.availableThemes())

        let code = try! String.init(contentsOfFile: Bundle.main.path(forResource: "sample", ofType: "txt")!)
        textStorage.setAttributedString(NSAttributedString(string: code))

        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

//        let textContainer = NSTextContainer(size:self.view.frame.size)
        let size = code.height(withConstrainedWidth: self.view.bounds.width, font: NSFont.systemFont(ofSize: 14))
        print(size)
        let textContainer = NSTextContainer(size: size)
        layoutManager.addTextContainer(textContainer)

        textView.textContainer = textContainer
        textView.backgroundColor = (textStorage.highlightr.theme.themeBackgroundColor)!
        textView.insertionPointColor = NSColor.white

//        textView = NSTextView(frame: self.view.bounds, textContainer: textContainer)
//        textView.autoresizingMask = [.width,.height]
//        textView.translatesAutoresizingMaskIntoConstraints = true
//        textView.backgroundColor = (textStorage.highlightr.theme.themeBackgroundColor)!
//        textView.insertionPointColor = NSColor.white
//        self.view.addSubview(textView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}
*/

class ViewController: NSViewController {

    fileprivate lazy var textStorage = CodeAttributedString()
    fileprivate lazy var layoutManager = NSLayoutManager()
    fileprivate lazy var textContainer = NSTextContainer()
    fileprivate var textView: NSTextView!
    fileprivate lazy var scrollview = NSScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollview)
        // Set `true` to enable horizontal scrolling.

        setupTextStack()
        setupUI(isHorizontalScrollingEnabled: false)
        setupLayout()

        textView.lnv_setUpLineNumberView()

        let color = (textStorage.highlightr.theme.themeBackgroundColor)!
        textView.backgroundColor = color
        textView.lineNumberView.wantsLayer = true
        textView.lineNumberView.layer?.backgroundColor = color.cgColor
    }
}

extension ViewController {

    fileprivate func setupTextStack() {

        textStorage.language = "json"
        textStorage.highlightr.setTheme(to: "googlecode")
        textStorage.highlightr.theme.codeFont = NSFont.systemFont(ofSize: 14.0)

        print(textStorage.highlightr.supportedLanguages())
        print(textStorage.highlightr.availableThemes())

        let code = try! String.init(contentsOfFile: Bundle.main.path(forResource: "sample", ofType: "txt")!)
        textStorage.setAttributedString(NSAttributedString(string: code))

        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
    }

    fileprivate func setupUI(isHorizontalScrollingEnabled: Bool) {

        let contentSize = scrollview.contentSize

        if isHorizontalScrollingEnabled {
            textContainer.containerSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            textContainer.widthTracksTextView = false
        } else {
            textContainer.containerSize = CGSize(width: contentSize.width, height: CGFloat.greatestFiniteMagnitude)
            textContainer.widthTracksTextView = true
        }

        textView = NSTextView(frame: CGRect(), textContainer: textContainer)
        textView.minSize = CGSize(width: 0, height: 0)
        textView.maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = isHorizontalScrollingEnabled
        textView.frame.size = CGSize(width: contentSize.width, height: contentSize.height)



        if isHorizontalScrollingEnabled {
            textView.autoresizingMask = [.width, .height]
        } else {
            textView.autoresizingMask = [.width]
        }

        scrollview.borderType = .noBorder
        scrollview.hasVerticalScroller = true
        scrollview.hasHorizontalScroller = isHorizontalScrollingEnabled
        scrollview.documentView = textView
    }

    fileprivate func setupLayout() {

        scrollview.edges(to: view)
    }
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: NSFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)

        return boundingBox.size
    }

    func width(withConstrainedHeight height: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)

        return ceil(boundingBox.width)
    }
}

