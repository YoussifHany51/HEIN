//
//  FavoriteProductManager.swift
//  HEIN
//
//  Created by Youssif Hany on 14/09/2024.
//

import Foundation
import CoreData
import FirebaseAuth

class FavoriteProductManager {
    static let shared = FavoriteProductManager()

    // MARK: - Add a Product to Favorites
    func addProductToFavorites(product: Product) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No current user logged in")
            return
        }

        let context = CoreDataManager.shared.context
        let favoriteProduct = FavoriteProduct(context: context)
        
        favoriteProduct.id = Int64(product.id)
        favoriteProduct.title = product.title
        favoriteProduct.bodyHTML = product.bodyHTML
        favoriteProduct.vendor = product.vendor
        favoriteProduct.productType = product.productType.rawValue
        favoriteProduct.imageSrc = product.image.src
        favoriteProduct.userID = userID  // Assign the current user's ID

        if let firstVariant = product.variants.first {
            favoriteProduct.price = firstVariant.price
        } else {
            favoriteProduct.price = "N/A"
        }

        if let colorOption = product.options.first(where: { $0.name == .color }) {
            favoriteProduct.color = colorOption.values.first ?? "No color available"
        } else {
            favoriteProduct.color = "No color available"
        }

        if let sizeOption = product.options.first(where: { $0.name == .size }) {
            favoriteProduct.size = sizeOption.values.first ?? "No size available"
        } else {
            favoriteProduct.size = "No size available"
        }

        CoreDataManager.shared.saveContext()
        print("Product added to favorites for user: \(userID)")
    }

    // MARK: - Remove a Product from Favorites
    func removeProductFromFavorites(productID: Int) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No current user ID available")
            return
        }

        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld AND userID == %@", Int64(productID), userID)

        do {
            let results = try context.fetch(fetchRequest)
            if let favoriteProduct = results.first {
                print("Product found: \(favoriteProduct.title ?? "Unknown Title")")
                context.delete(favoriteProduct)
                CoreDataManager.shared.saveContext()
                print("Product deleted successfully for user: \(userID)")
            } else {
                print("No product found with ID: \(productID) for userID: \(userID)")
            }
        } catch {
            print("Failed to delete product: \(error)")
        }
    }

    // MARK: - Fetch All Favorite Products for the Current User
    func fetchFavorites() -> [FavoriteProduct] {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No current user ID available")
            return []
        }

        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)

        do {
            let results = try context.fetch(fetchRequest)
            print("Fetched \(results.count) favorite products for user: \(userID)")
            return results
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }

    
    func toggleFavorite(product: Product) {
        let favorites = FavoriteProductManager.shared.fetchFavorites()
        
        if favorites.contains(where: { $0.id == Int64(product.id) }) {
            FavoriteProductManager.shared.removeProductFromFavorites(productID: product.id)
            print("Product removed from favorites")
        } else {
            FavoriteProductManager.shared.addProductToFavorites(product: product)
            print("Product added to favorites")
        }
    }

}
