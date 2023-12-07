//
//  Data++Extension.swift
//  FlipMate
//
//  Created by 권승용 on 11/30/23.
//

import Foundation

// swiftlint:disable force_unwrapping
extension Data {
    static func makeMultiPartRequestBody(userName: String, jpegImageData: Data, boundary: String) -> Data {
        var body = Data()
        
        // nickname 추가
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"nickname\"\r\n\r\n".data(using: .utf8)!)
        body.append(userName.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // 이미지 데이터 추가
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"profileImage.jpeg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(jpegImageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
// swiftlint: enable force_unwrapping
