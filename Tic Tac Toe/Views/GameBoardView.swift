//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Oriakhi Collins on 3/28/22.
//

import SwiftUI

struct GameBoardView: View {
    let columns:[GridItem]=[GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    @State private var move:[Move?]=Array(repeating: nil , count: 9)
    @State private var isGamBoardDisabled=false
    var body: some View {
        GeometryReader{
            geometry in  VStack {
                Spacer()
                LazyVGrid(columns: columns){
                    ForEach(0..<9){ i in
                        ZStack{
                            Circle().frame(
                                width: 80,
                                height: 80
                            ).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            
                            Image(systemName: move[i]?.indicator ?? "")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width:30, height: 30).foregroundColor(.white)
                            
                        }
                        .onTapGesture{
                            
                            if isCellOcuppied(in: move, forIndex: i){
                                return
                                //                                Do mnot execute any code
                            }
                            move[i]=Move(player:  .human ,   cellIndex: i)
                            isGamBoardDisabled = true
                            
                            if checkWinCondition(for : .human , in: move) {
                                print("HUMAN WINS!!")
                            }
                            
                            //                            BELOW, IS THE ALGORITHM FOR THE COMPUTER MOVES
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerMovePosition(in: move)
                                move[computerPosition] = Move(player: .computer, cellIndex: computerPosition)
                                isGamBoardDisabled = false
                                if checkWinCondition(for : .computer , in: move) {
                                    print("COMPUTER WINS!!")
                                }
                                
                                
                            }
                            
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGamBoardDisabled)
        }
    }
    
    func isCellOcuppied(in moves:[Move?], forIndex index:Int) ->  Bool {
        return moves.contains(where: {$0?.cellIndex == index})
    }
    func determineComputerMovePosition(in moves:[Move?]) -> Int {
        var newMovePositon = Int.random(in: 0..<9)
        while isCellOcuppied(in: moves, forIndex: newMovePositon) {
            newMovePositon = Int.random(in: 0..<9)
            
        }
        return newMovePositon
    }
    
    func checkWinCondition(for player : Player , in moves : [Move?]) -> Bool {
        let winPatterns : Set<Set<Int>> = [
            [0,1,2],[3,4,4], [6,7,8], [0,3,6], [1,4,7],[2,5,8],[0,4,8],[2,4,6]
        ]
        //            Removes all the Nil Cells on the Gameboard, and returns the Cells
        let playerMoves = moves.compactMap{ $0 }.filter{ $0.player == player}
        //        returns the cell moves for a particular player
        let playerPositions = Set(playerMoves.map{ $0.cellIndex })
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        return false
    }
}

struct GameBoardView_Preview: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
//sparkles



enum Player {
    case human, computer
}

struct Move {
    let player:Player
    let cellIndex:Int
    
    var indicator: String{
        return player == .human ? "moon" : "sparkles"
    }
}
