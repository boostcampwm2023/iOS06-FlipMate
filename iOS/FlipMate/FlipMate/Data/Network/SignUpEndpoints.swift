//
//  SignUpEndpoints.swift
//  FlipMate
//
//  Created by 권승용 on 11/28/23.
//

import Foundation

struct SignUpEndpoints {
    static func nickNameValidation(_ nickName: String) -> EndPoint<NickNameValidationResponseDTO> {
        let path = Paths.nickNameValidation + "?nickName=\(nickName)"
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: path,
            method: .get)
    }
    
    static func userSignUp(nickName: String, profileImageData: Data) -> EndPoint<SignUpResponseDTO> {
        let boundary = "\(UUID().uuidString)"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        let body = Data.makeMultiPartRequestBody(
            userName: nickName,
            jpegImageData: profileImageData,
            boundary: boundary)
        
        return EndPoint(
            baseURL: BaseURL.flipmateDomain,
            path: Paths.authInfo,
            method: .patch,
            data: body,
            headers: [HTTPHeader(value: contentType, field: "Content-Type")])
    }
}
