//
// Created by apploft on 18.12.18.
// Copyright © 2019 apploft GmbH.
// MIT License · http://choosealicense.com/licenses/mit/

import WebKit

public extension WKHTTPCookieStore {

    /// Set the given cookies or replace them in case they exist
    /// already. Note: This operation happens asynchronously.
    ///
    /// - Parameter cookies: the list of cookies to set or replace
    /// - Parameter completinHandler: a completion handler which will be called from the main thread
    ///   when the cookie replacement operation has finished
    ///
    func setOrReplaceCookies(newCookies: [HTTPCookie]?, completionHandler: (() -> Void)? = nil) {
        let cookiesToReplace = newCookies?.map { $0.name }
        let cookieReplaceOpQueue = DispatchQueue(label: "Cookie replace queue")
        let dispatchGroup = DispatchGroup()

        // Unfortunately, the WKHTTPCookieStore is not very well-documented.
        // It is unclear how to properly override a cookie. The naïve approach
        // of just setting a new cookie with a new value worked at first glance,
        // but turned out to be unreliable in one way or another.
        // Hence we remove all cookies we want to update before setting them
        // again.
        //
        // If Apple's documentation:
        //     https://developer.apple.com/documentation/webkit/wkhttpcookiestore?language=objc
        // becomes clearer one day, feel free to refactor this piece of code
        // to reflect the correct way® of updating cookies.
        //
        getAllCookies { (allCookies) in
            allCookies.forEach { cookie in
                if cookiesToReplace?.contains(cookie.name) ?? false {
                    dispatchGroup.enter()

                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {
                            dispatchGroup.leave()
                            return
                        }

                        strongSelf.delete(cookie) { dispatchGroup.leave() }
                    }
                }
            }

            cookieReplaceOpQueue.async {
                dispatchGroup.wait()
                DispatchQueue.main.async { [weak self] in
                    newCookies?.forEach { self?.setCookie($0, completionHandler: nil) }
                    completionHandler?()
                }
            }
        }
    }

    /// WKHTTPCookieStore is lacking a method to remove multiple cookies
    /// at once. So we're hand crafting one.
    /// - Parameters:
    ///   - cookies: the cookies to remove
    ///   - completion: a completion block being called, once the cookies
    ///     have been removed
    func removeCookies(_ cookies: [HTTPCookie]?, completion: @escaping () -> Void) {
        guard let cookies = cookies, !cookies.isEmpty else {
            completion()
            return
        }

        let dispatchGroup = DispatchGroup()

        cookies.forEach { cookie in
            dispatchGroup.enter()
            DispatchQueue.main.async {
                self.delete(cookie) {
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main,
                             work: DispatchWorkItem(block: completion))
    }

    /// The 'getAllCookies' method of WKHTTPCookieStore returns all
    /// cookies of all domains. What probably often is needed are just
    /// the cookies for a specific domain.
    /// - Parameters:
    ///   - domain: the domain to return cookies for. If 'nil' all cookies
    ///     will be returned
    ///   - onlyUnexpiredCookies: usually only unexpired cookies are wanted
    ///     however the caller can overrule this.
    ///   - completion: a completion handler receiving all cookies matching
    ///     the specified filter criteria.
    func getAllCookies(domain: String? = nil, onlyUnexpiredCookies: Bool = true, completion: @escaping ([HTTPCookie]) -> Void) {
        self.getAllCookies { allCookies in
            var filteredCookies = allCookies

            if let domain = domain {
                filteredCookies = filteredCookies.filter {
                    $0.domain == domain
                }
            }

            if onlyUnexpiredCookies {
                filteredCookies = self.unexpiredCookiesFrom(filteredCookies)
            }

            completion(filteredCookies)
        }
    }

    private func unexpiredCookiesFrom(_ cookies: [HTTPCookie]) -> [HTTPCookie] {
        return cookies.filter { cookie in
            guard let expireDate = cookie.expiresDate else { return true }

            // The 'Date()' constructor is broken which is why we are applying
            // such crude workarounds here.
            let now = Date(timeIntervalSinceNow: 0)
            let isExpired = expireDate.timeIntervalSince(now) < 0

            return !isExpired
        }
    }
}
