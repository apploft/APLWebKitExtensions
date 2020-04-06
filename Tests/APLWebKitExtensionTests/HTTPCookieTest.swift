//
// Created by apploft on 04.01.19.
// Copyright © 2019 apploft GmbH￼￼
// MIT License · http://choosealicense.com/licenses/mit/

import XCTest
import APLWebKitExtension

class HTTPCookieTest: XCTestCase {

    //MARK:- var javaScriptString
    // create an HTTP cookie and call javaScriptString on it, then assert equal
    // result to expected hardcoded key-value pair string
    func testJavaScriptStringEqual() {
        let httpCookie: HTTPCookie! = HTTPCookie(properties: [
            .domain: "someDomain",
            .path: "somePath",
            .name: "someName",
            .secure: "TRUE",
            .value: "someValue",
            .originURL: "someOriginURL"
            ])
        XCTAssertEqual(httpCookie.javaScriptString, "someName=someValue; domain=somedomain; path=somePath; secure=true")
    }

    func testJavaScriptStringNotEqual() {
        let httpCookie: HTTPCookie! = HTTPCookie(properties: [
            .domain: "someOtherDomain",
            .path: "someOtherPath",
            .name: "someOtherName",
            .secure: "False",
            .value: "someOtherValue",
            .originURL: "someOtherURL"
            ])
        XCTAssertNotEqual(httpCookie.javaScriptString, "someName=someValue; domain=somedomain; path=somePath; secure=true")
    }
}
