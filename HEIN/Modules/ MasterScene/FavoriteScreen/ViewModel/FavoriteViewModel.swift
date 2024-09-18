//
//  FavoriteViewModel.swift
//  HEIN
//
//  Created by Youssif Hany on 16/09/2024.
//

import Foundation

class FavoriteViewModel{
    var favoriteProducts: [FavoriteProduct] = []
    func loadFavorites() {
        favoriteProducts = FavoriteProductManager.shared.fetchFavorites()
    }
}
