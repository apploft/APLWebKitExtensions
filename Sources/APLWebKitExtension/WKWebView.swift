//
// Created by apploft on 18.12.18.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/

import WebKit

public extension WKWebView {
    
    typealias JavaScriptCompletionHandler = ((Any?, Error?) -> Void)
    
    /// Execute the specified java script file.
    /// - Parameter filename: the name of the file containing JavaScript code
    /// - Parameter fileExtension: optionally the file extension of JavaScript file
    /// - Parameter completionHandler: optionally a completion handler
    func executeJavaScriptFile(_ filename: String, fileExtension: String? = "js", completionHandler: JavaScriptCompletionHandler?) {
        if let path = Bundle.main.path(forResource: filename, ofType: fileExtension),
           let source = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String {
            return evaluateJavaScript(source, completionHandler: completionHandler)
        } else {
            print("User script could not be executed from file '\(filename).\(String(describing: fileExtension))'")
            let error = NSError(domain: "de.apploft", code: 1000, userInfo: nil)
            completionHandler?(nil, error)
        }
    }
}
