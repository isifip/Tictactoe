//
//  ContentView.swift
//  Tictactoe
//
//  Created by Irakli Sokhaneishvili on 14.01.22.
//

import SwiftUI

struct ContentView: View {
    //MARK: --> Properties
    @StateObject private var viewModel = GameViewModel()
    
    //MARK: --> Body
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 2) {
                    ForEach(0..<9) { item in
                        ZStack {
                            GameSquareView(proxy: geo)
                            PlayerIndicator(systemImageName: viewModel.moves[item]?.idicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: item)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(viewModel.alertItem?.title ?? Text(""), isPresented: $viewModel.showingAlert) {
                Button(role: .cancel) {
                    
                } label: {
                    viewModel.alertItem?.buuttonTitle ?? Text("")
                }
                Button {
                    viewModel.resetGame()
                } label: {
                    Text("Reset game")
                }
            } message: {
                viewModel.alertItem?.message ?? Text("")
            }
        }
    }
}

enum Player {
    case human, computer
}
struct Move {
    let player: Player
    let boardIndex: Int
    
    var idicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
//MARK: --> Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//MARK: --> Subviews
struct GameSquareView: View {
    var proxy: GeometryProxy
    var body: some View {
        Circle()
            .foregroundColor(.purple).opacity(0.7)
            .frame(width: proxy.size.width / 3 - 10, height: proxy.size.width / 3 - 10)
    }
}

struct PlayerIndicator: View {
    
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
