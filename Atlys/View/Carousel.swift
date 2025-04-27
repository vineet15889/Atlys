//
//  Carousel.swift
//  Atlys
//
//  Created by Vineet Rai on 27-Apr-25.
//

import SwiftUI

struct Carousel<Content: View, T: Identifiable>: View {
    let items: [T]
    let cardHeight: CGFloat
    let content: (T) -> Content
    
    @GestureState private var dragOffset: CGFloat = 0
    @State private var currentOffset: CGFloat = 0
    @State private var activeIndex: Int = 0
    
    private let maxScale: CGFloat = 1.2 // For max overlaps
    private let minScale: CGFloat = 0.951 // To keep the spacing 0 when card scal to 1


    init(items: [T], cardHeight: CGFloat, @ViewBuilder content: @escaping (T) -> Content) {
        self.items = items
        self.cardHeight = cardHeight
        self.content = content
        let middleIndex = items.count / 2 // Start from middle of array
        self._activeIndex = State(initialValue: middleIndex)
        self._currentOffset = State(initialValue: -CGFloat(middleIndex) * cardHeight)
    }

    var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geometry in
                let initialOffset = (geometry.size.width / 2) - (cardHeight / 2)
                
                HStack(spacing: 0) {
                    ForEach(items.indices, id: \.self) { index in
                        content(items[index])
                            .frame(width: cardHeight, height: cardHeight)
                            .scaleEffect(scaleForIndex(index, geometry: geometry))
                            .zIndex(scaleForIndex(index, geometry: geometry))
                    }
                }
                .offset(x: initialOffset + currentOffset + dragOffset)
                .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.7), value: currentOffset)
                .animation(.easeInOut(duration: 0.1), value: dragOffset)
                .gesture(dragGesture)
            }
            .frame(height: cardHeight * maxScale)
            
            dotIndicator
        }
        .onAppear {
            activeIndex = items.count / 2
            currentOffset = -CGFloat(activeIndex) * cardHeight
        }
    }
    
    private var dotIndicator: some View {
        HStack(spacing: 8) {
            ForEach(items.indices, id: \.self) { index in
                Circle()
                    .fill(
                        index == activeIndex ? Color.gray : Color.gray
                            .opacity(0.5)
                    )
                    .frame(width: 8, height: 8)
                    .animation(.spring(), value: activeIndex)
            }
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation.width
                updateActiveIndex(with: value.translation.width)
            }
            .onEnded { value in
                currentOffset += value.translation.width
                let targetIndex = Int(-(currentOffset / cardHeight).rounded())
                    .clamped(to: 0...(items.count - 1))
                let snappedOffset = -CGFloat(targetIndex) * cardHeight
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7)) {
                    currentOffset = snappedOffset
                    activeIndex = targetIndex
                }
            }
    }

    private func updateActiveIndex(with translation: CGFloat = 0) {
        let offset = currentOffset + translation
        let index = Int(-(offset / cardHeight).rounded())
        let newActiveIndex = index.clamped(to: 0...(items.count - 1))
        if newActiveIndex != activeIndex {
             DispatchQueue.main.async {
                 self.activeIndex = newActiveIndex
             }
        }
    }

    private func scaleForIndex(_ index: Int, geometry: GeometryProxy) -> CGFloat {
        let cardCenter = cardCenterX(index, geometry: geometry)
        let distance = abs(geometry.size.width/2 - cardCenter)
        return calculateScale(distance: distance)
    }
    
    private func cardCenterX(_ index: Int, geometry: GeometryProxy) -> CGFloat {
        let initialOffset = (geometry.size.width / 2) - (cardHeight / 2)
        let itemOffset = CGFloat(index) * cardHeight
        return initialOffset + currentOffset + dragOffset + itemOffset + cardHeight/2
    }
    
    private func calculateScale(distance: CGFloat) -> CGFloat {
        let transition = cardHeight * 0.7
        guard distance < transition else { return minScale }
        
        let proximity = 1 - (distance / transition)
        let eased = proximity * proximity * (3 - 2 * proximity) // Ease-in-out curve
        return minScale + (maxScale - minScale) * eased
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
