//
// Created by apploft on 18.12.18.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/

import Foundation
import WebKit

public extension WKUserContentController {
    
    /// Add the specified JavaScript file as user script to the WKWebView.
    /// - Parameter filename: the name of the JavaScript file
    /// - Parameter fileExtension: optionally the extension of the JavaScript file
    /// - Parameter arguments: a dictionary of arguments to be replaced in the JavaScript file
    /// - Parameter injectionTime: the time when the script should be injected into the web page
    /// - Parameter forMainFrameOnly: specifies whether or not the script should be visible in the main frame or not
    func addUserScriptFromFile(_ filename: String,
                               fileExtension: String? = "js",
                               withArguments arguments: [String: String] = [:],
                               injectionTime: WKUserScriptInjectionTime = .atDocumentEnd,
                               forMainFrameOnly: Bool = true) {
        if let path = Bundle.main.path(forResource: filename, ofType: fileExtension),
            var source = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String {
            
            if !arguments.isEmpty {
                for (key, value) in arguments {
                    source = source.replacingOccurrences(of: key, with: value)
                }
            }
            let script = WKUserScript(source: source, injectionTime: injectionTime, forMainFrameOnly: forMainFrameOnly)
            
            self.addUserScript(script)
        } else {
            print("user script could not be added from file '\(filename).js'")
        }
    }
}
