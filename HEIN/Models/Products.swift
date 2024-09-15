//
//  Products.swift
//  HEIN
//
//  Created by Marco on 2024-09-03.
//

import Foundation


// MARK: - Welcome
struct Products: Codable {
    var products: [Product]
}
struct ProductContainer: Codable {
    var product: Product
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, bodyHTML, vendor: String
    let productType: ProductType
    let createdAt: String
    let handle: String
    let updatedAt, publishedAt: String
    let publishedScope: PublishedScope
    let tags: String
    let status: Status
    let adminGraphqlAPIID: String
    let variants: [Variant]
    let options: [Option]
    let images: [ProductImage]
    let image: ProductImage

    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case publishedScope = "published_scope"
        case tags, status
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case variants, options, images, image
    }
}

// MARK: - Image
struct ProductImage: Codable {
    let id: Int
    let position, productID: Int
    let createdAt, updatedAt: String
    let adminGraphqlAPIID: String
    let width, height: Int
    let src: String
 

    enum CodingKeys: String, CodingKey {
        case id, position
        case productID = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case width, height, src
        
    }
}

// MARK: - Option
struct Option: Codable {
    let id, productID: Int
    let name: Name
    let position: Int
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}

enum Name: String, Codable {
    case color = "Color"
    case size = "Size"
}

enum ProductType: String, Codable {
    case accessories = "ACCESSORIES"
    case shoes = "SHOES"
    case tShirts = "T-SHIRTS"
}

enum PublishedScope: String, Codable {
    case global = "global"
}

enum Status: String, Codable {
    case active = "active"
}

// MARK: - Variant
struct Variant: Codable {
    let id, productID: Int
    let title, price, sku: String
    let position: Int
    let inventoryPolicy: InventoryPolicy
    let compareAtPrice: String?
    let fulfillmentService: FulfillmentService
    let inventoryManagement: InventoryManagement
    let option1: String
    let option2: Option2
  
    let createdAt, updatedAt: String
    let taxable: Bool
  
    let grams, weight: Int
    let weightUnit: WeightUnit
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int
    let requiresShipping: Bool
    let adminGraphqlAPIID: String
 

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, sku, position
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case option1, option2
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable, grams, weight
        case weightUnit = "weight_unit"
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case requiresShipping = "requires_shipping"
        case adminGraphqlAPIID = "admin_graphql_api_id"
       
    }
}

enum FulfillmentService: String, Codable {
    case manual = "manual"
}

enum InventoryManagement: String, Codable {
    case shopify = "shopify"
}

enum InventoryPolicy: String, Codable {
    case deny = "deny"
}

enum Option2: String, Codable {
    case beige = "beige"
    case black = "black"
    case blue = "blue"
    case burgandy = "burgandy"
    case gray = "gray"
    case lightBrown = "light_brown"
    case red = "red"
    case white = "white"
    case yellow = "yellow"
}

enum WeightUnit: String, Codable {
    case kg = "kg"
}
extension Product {
    init(favoriteProduct: FavoriteProduct) {
        self.id = Int(favoriteProduct.id)
        self.title = favoriteProduct.title ?? ""
        self.bodyHTML = favoriteProduct.bodyHTML ?? ""
        self.vendor = favoriteProduct.vendor ?? ""
        self.productType = ProductType(rawValue: favoriteProduct.productType ?? "") ?? .accessories
        self.createdAt = "" // Use a default or leave empty if not needed
        self.handle = ""
        self.updatedAt = ""
        self.publishedAt = ""
        self.publishedScope = .global
        self.tags = ""
        self.status = .active
        self.adminGraphqlAPIID = ""
        self.variants = [Variant(id: 0, productID: 0, title: "", price: favoriteProduct.price ?? "N/A", sku: "", position: 0, inventoryPolicy: .deny, compareAtPrice: nil, fulfillmentService: .manual, inventoryManagement: .shopify, option1: "", option2: .black, createdAt: "", updatedAt: "", taxable: false, grams: 0, weight: 0, weightUnit: .kg, inventoryItemID: 0, inventoryQuantity: 0, oldInventoryQuantity: 0, requiresShipping: false, adminGraphqlAPIID: "")]
        self.options = [
            Option(id: 0, productID: 0, name: .color, position: 0, values: [favoriteProduct.color ?? ""]),
            Option(id: 1, productID: 0, name: .size, position: 1, values: [favoriteProduct.size ?? ""])
        ]
        self.images = [ProductImage(id: 0, position: 0, productID: 0, createdAt: "", updatedAt: "", adminGraphqlAPIID: "", width: 0, height: 0, src: favoriteProduct.imageSrc ?? "")]
        self.image = ProductImage(id: 0, position: 0, productID: 0, createdAt: "", updatedAt: "", adminGraphqlAPIID: "", width: 0, height: 0, src: favoriteProduct.imageSrc ?? "")
    }
}
