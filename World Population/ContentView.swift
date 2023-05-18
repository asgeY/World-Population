//
//  ContentView.swift
//  World Population
//
//  Created by AsgeY on 5/17/23.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel: WorldPopulationViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: WorldPopulationViewModel())
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.yellow, Color.green]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text("World Population")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                Text(viewModel.populationCount)
                    .font(.title)
                    .padding()
                
                if let apiStatus = viewModel.apiStatus {
                    Text(apiStatus)
                        .foregroundColor(apiStatus == "Error" ? .red : .green)
                        .padding()
                    
                }
                Spacer()
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

