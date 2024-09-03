//
//  Reviews.swift
//  HEIN
//
//  Created by Marco on 2024-09-03.
//

import Foundation

import Foundation
class Reviews{
    struct Review{
        var customerName : String
        var customerImage : String
        var createdAt : String
        var massage : String
        var rating : Double
    }
   
     
    static var reviews: [Review] = [
            Review(
                customerName: "Basma",
                customerImage: "girlIcon",
                createdAt: "2024-02-02",
                massage: "I recently purchased this product, and it exceeded my expectations!",
                rating: 4.2
            ),
            Review(
                customerName: "Mohamed",
                customerImage: "boyIcon",
                createdAt: "2024-02-16",
                massage: "Great value for the price; I'm very happy with my purchase",
                rating: 4.5
            ),
            Review(
                customerName: "Malek",
                customerImage: "boyIcon",
                createdAt: "2023-12-17",
                massage: "Functionality meets style – this product not only works well but also looks great.",
                rating: 3.9
            ),
            Review(
                customerName: "Salma",
                customerImage: "girlIcon",
                createdAt: "2023-07-16",
                massage: "Excellent value for money. I highly recommend this to anyone looking for a solid product.",
                rating: 4.0
            ),
            Review(
                customerName: "Ahmed",
                customerImage: "boyIcon",
                createdAt: "2023-11-02",
                massage: "The simplicity of this product makes it stand out – it does exactly what it should",
                rating: 3.7
            ),
            Review(
                customerName: "Menna",
                customerImage: "girlIcon",
                createdAt: "2024-01-30",
                massage: "This has become an essential part of my life. I don't know how I lived without it",
                rating: 4.0
            ),
            Review(
                customerName: "Fathy",
                customerImage: "boyIcon",
                createdAt: "2023-12-29",
                massage: "I appreciate the thought put into the packaging; it arrived in perfect condition",
                rating: 3.9
            ),
            Review(
                customerName: "Nada",
                customerImage: "girlIcon",
                createdAt: "2024-02-16",
                massage: "Top-notch quality and excellent craftsmanship",
                rating: 3.8
            ),
            Review(
                customerName: "omer",
                customerImage: "boyIcon",
                createdAt: "2023-12-02",
                massage: "If you're considering buying this, go for it; you won't be disappointed.",
                rating: 4.5
            ),
            Review(
                customerName: "Sara",
                customerImage: "girlIcon",
                createdAt: "2023-12-19",
                massage: "Excellent value for money. I highly recommend this to anyone looking for a solid product.",
                rating: 4.8
            )
        ]
   
    func getReviews()->[Review]{
        let shuffledReviews = Reviews.reviews.shuffled()
        return Array(shuffledReviews.prefix(3))
    }
    func getAllReviews()->[Review]{
        return Reviews.reviews
    }
    
    
}
