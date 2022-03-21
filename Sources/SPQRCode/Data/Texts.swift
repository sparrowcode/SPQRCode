// The MIT License (MIT)
// Copyright © 2022 Sparrow Code (hello@sparrowcode.io)
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

import Foundation

enum Texts {
    
    static var action_handle: String { NSLocalizedString("action handle", bundle: bundle, comment: "") }
    static var action_cancel: String { NSLocalizedString("action cancel", bundle: bundle, comment: "") }
    
    static var qr_code_data_text_prefix: String { NSLocalizedString("qr code data text prefix", bundle: bundle, comment: "") }
    static var qr_code_data_url_prefix: String { NSLocalizedString("qr code data url prefix", bundle: bundle, comment: "") }
    static var qr_code_data_eth_wallet_prefix: String { NSLocalizedString("qr code data eth wallet prefix", bundle: bundle, comment: "") }
    
    
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
