//
//  Data++Extension.swift
//  FlipMate
//
//  Created by 권승용 on 11/30/23.
//

import Foundation

extension Data {
    static func makeMultiPartRequestBody(userName: String, jpegImageData: Data, boundary: String) -> Data {
        var body = Data()
        
        // nickname 추가
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"nickname\"\r\n\r\n".utf8))
        body.append(Data(userName.utf8))
        body.append(Data("\r\n".utf8))
        
        // 이미지 데이터 추가
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"image\"; filename=\"profileImage.jpeg\"\r\n".utf8))
        body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
        body.append(jpegImageData)
        body.append(Data("\r\n".utf8))
        body.append(Data("--\(boundary)--\r\n".utf8))
        return body
    }
}
