//
//  SwiftUIToast.swift
//  ToastViewTest
//
//  Created by Jake Nelson on 9/6/21.
//

import Foundation
import SwiftUI

public class SwiftUIToast {
    
    public enum ToastPosition{
        case top, middle, bottom
    }
    
    @ObservedObject public static var state : ToastState = ToastState()
    
    static var duration: Double = 1.5
    static var opacity: Double = 0.8
    static var shadow: CGFloat = 5.0
    static var position: ToastPosition = .top
    
    static var workItem: DispatchWorkItem? = nil
          
    public static func setDefaults(
        duration: Double = 1.5,
        opacity: Double = 0.8,
        shadow: CGFloat = 5.0,
        position: ToastPosition = .top
        
    ){
        SwiftUIToast.duration = duration
        SwiftUIToast.opacity = opacity
        SwiftUIToast.shadow = shadow
        SwiftUIToast.position = position
    }
       
    public static func show(image: String, text: String, duration: Double? = nil){
        
        let delay = duration ?? SwiftUIToast.duration
        
        state.text = text
        state.image = image
        
        state.display = true
        
        workItem?.cancel()
        
        workItem = DispatchWorkItem {
            state.display = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
    
    
    
    public struct ToastContainerView<Content: View>: View {
        
        @ObservedObject var state: ToastState = SwiftUIToast.state
        @State var geo: GeometryProxy? = nil
        
        let content: Content
        
        public init(@ViewBuilder content: () -> Content){
            self.content = content()
        }
        
        private var screenSize: CGSize {
            return UIScreen.main.bounds.size
        }

        private var screenHeight: CGFloat {
            screenSize.height
        }
        
        public
        var yOffset: CGFloat {
            switch SwiftUIToast.position {
            case .top:
                return -(screenHeight / 2) + (geo?.safeAreaInsets.top ?? 0.0) + 20
            case .middle:
                return 0.0
            case .bottom:
                return (screenHeight / 2) - (geo?.safeAreaInsets.bottom ?? 0.0) - 20
            }
        }
        
        public var body: some View {
            GeometryReader { localGeo in
                ZStack{
                    
                    content
                    
                    if state.display {
                        HStack{
                            Group {
                                
                                    Image(systemName: "\(state.image)")
                                        .padding(.leading)
                                    Text("\(state.text)")
                                        .padding()
                                
                            }
                        }
                        .background(
                            Color(
                                UIColor.systemBackground
                            ).opacity(SwiftUIToast.opacity)
                        )
                        .cornerRadius(100)
                        .shadow(radius: SwiftUIToast.shadow)
                        .allowsHitTesting(false)
                        .animation(.easeInOut, value: state.display)
                        .offset(x: 0, y: yOffset)
                    }
                }
                .onAppear{
                    geo = localGeo
                }
            }
        }
    }
}

public class ToastState: ObservableObject {
    @Published var display: Bool = false
    @Published var image: String = "text.append"
    @Published var text: String = "Added to queue"
}
