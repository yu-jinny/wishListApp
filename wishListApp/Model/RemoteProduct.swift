//
//  File.swift
//  wishListApp
//
//  Created by t2023-m0028 on 1/9/24.
//
import Foundation

// URLSession을 통해 가져올 상품의 Decodable Model
struct RemoteProduct: Decodable {
    let id: Int              // 상품 ID
    let title: String        // 상품 제목
    let description: String  // 상품 설명
    let price: Double        // 상품 가격
    let thumbnail: URL       // 상품 썸네일 이미지 URL
}
