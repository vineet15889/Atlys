//
//  Carousel.swift
//  Atlys
//
//  Created by Vineet Rai on 27-Apr-25.
//

import SwiftUI
import Combine

class CarouselViewModel: ObservableObject {
    @Published var activeIndex: Int = 0
    @Published var carouselItems: [Item] = []

    init() {
        loadItems()
    }

    private func loadItems() {
        carouselItems = [
            Item(id: 0, title: "Dubai", description: "53K+ Visas on Atlys", image: "dubai"), // Image need to added in the build
            Item(id: 1, title: "Malaysia", description: "10K+ Visas on Atlys", image: "malaysia"),
            Item(id: 2, title: "Thailand", description: "52K+ Visas on Atlys", image: "thailand"),
            Item(id: 3, title: "Singapore", description: "46K+ Visas on Atlys", image: "singapore"),
            Item(id: 4, title: "Vietnam", description: "23K+ Visas on Atlys", image: "vietnam"),
            Item(id: 5, title: "Indonesia", description: "30K+ Visas on Atlys", image: "indonesia")
        ]
    }
}
