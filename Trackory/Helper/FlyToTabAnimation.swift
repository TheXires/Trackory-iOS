//
//  FlyToTabAnimation.swift
//  Trackory
//
//  Created by Robin Beckmann on 12.03.26.
//

import SwiftUI
import Observation

// MARK: - Coordinator

@Observable
class FlyToTabCoordinator {
    var particles: [FlyParticle] = []
    
    func fly(from origin: CGPoint, size: CGSize, @ViewBuilder content: () -> some View) {
        let id = UUID()
        let particle = FlyParticle(id: id, origin: origin, size: size, content: AnyView(content()))
        particles.append(particle)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
            self?.particles.removeAll { $0.id == id }
        }
    }
}

struct FlyParticle: Identifiable {
    let id: UUID
    let origin: CGPoint
    let size: CGSize
    let content: AnyView
}

// MARK: - Overlay View

struct FlyToTabOverlay: View {
    @Environment(FlyToTabCoordinator.self) private var coordinator
    /// Approximate global position of the "Today" tab icon (fork.knife).
    /// We anchor it to the bottom-left tab item.
    var tabTargetX: CGFloat
    var tabTargetY: CGFloat
    
    var body: some View {
        ForEach(coordinator.particles) { particle in
            FlyingIcon(origin: particle.origin,
                       target: CGPoint(x: tabTargetX, y: tabTargetY),
                       size: particle.size,
                       content: particle.content)
        }
    }
}

// MARK: - Single Flying Row

struct FlyingIcon: View {
    let origin: CGPoint
    let target: CGPoint
    let size: CGSize
    let content: AnyView
    
    @State private var position: CGPoint
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    init(origin: CGPoint, target: CGPoint, size: CGSize, content: AnyView) {
        self.origin = origin
        self.target = target
        self.size = size
        self.content = content
        _position = State(initialValue: origin)
    }
    
    var body: some View {
        content
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 6)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(position)
            .onAppear {
                withAnimation(.easeIn(duration: 0.5)) {
                    position = target
                    scale = 0.2
                }
                withAnimation(.easeIn(duration: 0.25).delay(0.45)) {
                    opacity = 0
                }
            }
    }
}

// MARK: - View Modifier

struct FlyToTabModifier: ViewModifier {
    var coordinator: FlyToTabCoordinator
    
    func body(content: Content) -> some View {
        content.overlay(alignment: .topLeading) {
            GeometryReader { geo in
                let targetX = geo.size.width / 6
                let targetY = geo.size.height - 30
                ZStack {
                    ForEach(coordinator.particles) { particle in
                        FlyingIcon(
                            origin: particle.origin,
                            target: CGPoint(x: targetX, y: targetY),
                            size: particle.size,
                            content: particle.content
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(false)
            }
        }
    }
}

extension View {
    func flyToTabAnimationOverlay(coordinator: FlyToTabCoordinator) -> some View {
        modifier(FlyToTabModifier(coordinator: coordinator))
    }
}
