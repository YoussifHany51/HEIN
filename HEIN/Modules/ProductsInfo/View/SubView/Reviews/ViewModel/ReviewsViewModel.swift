//
//  ReviewsViewModel.swift
//  HEIN
//
//  Created by Youssif Hany on 18/09/2024.
//

import Foundation

class ReviewsViewModel {
    
    var reviews: [Review] = [
           Review(
               customerName: "Youssif",
               customerImage: "boyIcon",
               createdAt: "2024-09-15",
               message: "حاجة عظمة بصراحة",
               rating: 4.2
           ),
           Review(
               customerName: "El Galawy",
               customerImage: "boyIcon",
               createdAt: "2024-09-16",
               message: "فاجر يا جدعان",
               rating: 4.5
           ),
           Review(
               customerName: "Mego",
               customerImage: "boyIcon",
               createdAt: "2023-12-17",
               message: "Functionality meets style – this product not only works well but also looks great.",
               rating: 3.9
           ),
           Review(
               customerName: "Salma",
               customerImage: "girlIcon",
               createdAt: "2023-07-16",
               message: "Excellent value for money. I highly recommend this to anyone looking for a solid product.",
               rating: 4.0
           ),
           Review(
               customerName: "Ahmed Zizo",
               customerImage: "boyIcon",
               createdAt: "2023-12-29",
               message: "I appreciate the thought put into the packaging; it arrived in perfect condition",
               rating: 3.9
           ),
           Review(
               customerName: "Menna",
               customerImage: "girlIcon",
               createdAt: "2024-01-30",
               message: "This has become an essential part of my life. I don't know how I lived without it",
               rating: 4.0
           ),
           Review(
               customerName: "Nada",
               customerImage: "girlIcon",
               createdAt: "2024-02-16",
               message: "Top-notch quality and excellent craftsmanship",
               rating: 3.8
           ),
           Review(
               customerName: "omar",
               customerImage: "boyIcon",
               createdAt: "2023-12-02",
               message: "If you're considering buying this, go for it; you won't be disappointed.",
               rating: 4.5
           ),
           Review(
               customerName: "Sara",
               customerImage: "girlIcon",
               createdAt: "2023-12-19",
               message: "Excellent value for money. I highly recommend this to anyone looking for a solid product.",
               rating: 4.8
           ),
           Review(
               customerName: "Ahmed",
               customerImage: "boyIcon",
               createdAt: "2023-11-02",
               message: "The simplicity of this product makes it stand out – it does exactly what it should",
               rating: 3.7
           ),
       ]
}
