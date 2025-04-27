//
//  HomeView.swift
//  Atlys
//
//  Created by Vineet Rai on 27-Apr-25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = CarouselViewModel()
    let cardDimension: CGFloat = 250 // 250 x 250
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Carousel(items: viewModel.carouselItems, cardHeight: cardDimension) { item in
                ZStack(alignment: .bottomLeading) {
                    Group {
                        Image(item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.title)
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .shadow(radius: 2)
                                    .padding(.leading, 16)
                                Text(item.description)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 8)
                                    .padding(.leading, 20)
                                    .padding(.vertical, 4)
                                    .background(Color.purple.opacity(0.85))
                                    .cornerRadius(8)
                                    .padding(.leading, -4)
                            }
                            .padding(.bottom, 16)
                            Spacer()
                        }
                    }
                    .frame(width: cardDimension)
                    .cornerRadius(24)
                }
            }
            .frame(height: 300)
            Spacer()
        }
        .background(Color.white)
    }
}

#Preview {
    HomeView()
}
