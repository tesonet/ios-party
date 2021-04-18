//
//  ServersProgressView.swift
//  nordPassTechTask
//
//  Created by Blazej Wdowikowski on 18/04/2021.
//

import SwiftUI

struct ServersProgressView: View {
    @State private var isLoading = false
    var body: some View {
        VStack(spacing: UIConstraints.Layout.innerSpacing) {
            Circle()
                .strokeBorder(
                    AngularGradient(gradient: Gradient(colors: [.clear, .white]), center: .center, angle: Angle(degrees: -90)),
                    lineWidth: UIConstraints.Progress.lineWidth,
                    antialiased: true
                )
                .frame(width: UIConstraints.Progress.width, height: UIConstraints.Progress.width, alignment: .center)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .onAppear(perform: {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        self.isLoading = true
                    }
                })
            Text("Fetching the list...")
        }
        .foregroundColor(.white)
    }
}
