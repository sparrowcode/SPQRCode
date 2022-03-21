// The MIT License (MIT)
// Copyright © 2020 Ivan Vorobei (hello@ivanvorobei.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

enum Images {
    
    static func detail_safari() -> UIImage {
        return .init(systemName: "safari.fill")!
    }
    
    static func detail_text() -> UIImage {
        return .init(systemName: "textformat.alt")!
    }
    
    static func detail_eth_wallet() -> UIImage {
        return UIImage.init(named: "ethereum", in: bundle, compatibleWith: nil) ?? UIImage()
    }
    
    // MARK: - Internal
    
    static var bundle: Bundle {
        
        // If installed via SPM, will be available bundle .module.
        
        #if SPQRCODE_SPM
        return .module
        #else
        
        // If installed via Cocoapods, should use bundle from podspec.
        
        let path = Bundle(for: SPQRCode.self).path(forResource: "SPQRCode", ofType: "bundle") ?? ""
        let bundle = Bundle(path: path) ?? Bundle.main
        return bundle
        #endif
    }
}
