//
//  ContentView.swift
//  slots-game
//  A game of slots
//
//  Created by Sandon Lai on 9/2/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var symbols = ["apple", "star", "cherry"]
    @State private var numbers = Array(repeating: 0, count: 9)
    @State private var backgrounds = Array(repeating: Color.white, count: 9)
    @State private var credits = 1000
    private var betAmount = 5
    
    
    var body: some View {
        
        // ZStack for background elements
        
        ZStack {
            
            // Background Elements
            Rectangle().foregroundColor(Color(red: 196/255, green: 55/255, blue: 55/255)).edgesIgnoringSafeArea(.all)
            
            Rectangle().foregroundColor(Color(red: 249/255, green: 105/255, blue: 105/255)).rotationEffect(Angle(degrees: 45)).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                Spacer()
                
                // Heading Title
                HStack {
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    
                    Text("SwiftUI SLOTS")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                
                Spacer()
                
                // Number of credits available
                Text("Credits: " + String(credits))
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)
                    
                
                Spacer()
                
                // Slot images and grid for slots
                
                VStack {
                    
                    // Top Row
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[0]], background: $backgrounds[0])
                            
                        CardView(symbol: $symbols[numbers[1]], background:
                            $backgrounds[1])
                        
                        CardView(symbol: $symbols[numbers[2]], background: $backgrounds[2])
                        
                        Spacer()
                    }
                    
                    // Middle Row
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[3]], background: $backgrounds[3])
                            
                        CardView(symbol: $symbols[numbers[4]], background:
                            $backgrounds[4])
                        
                        CardView(symbol: $symbols[numbers[5]], background: $backgrounds[5])
                        
                        Spacer()
                    }
                    
                    // Bottom Row
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[6]], background: $backgrounds[6])
                            
                        CardView(symbol: $symbols[numbers[7]], background:
                            $backgrounds[7])
                        
                        CardView(symbol: $symbols[numbers[8]], background: $backgrounds[8])
                        
                        Spacer()
                    }
                }
                
                
                Spacer()
                
                // Button for normal spin
                HStack (spacing: 20){
                    VStack {
                        Button(action: {
                            
                            // Process a single spin
                            self.processResults()
                            
                            
                        }, label: {
                            
                            // Spin button
                            Text("Spin")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.all)
                                .padding([.leading, .trailing], 20)
                                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.yellow/*@END_MENU_TOKEN@*/)
                                .cornerRadius(25.0)
                                .shadow(radius: 5)
                            
                            
                    })
                        Text("Cost: \(betAmount)")
                            .padding(.top, 10)
                            .foregroundColor(.white)
                        
                    }
                    // Max Spin button that checks for all 3 rows and diagonals
                    VStack {
                        Button(action: {
                            
                            // Code Max Spin here
                            self.processResults(true)
                            
                        }, label: {
                            Text("Max Spin")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.all)
                                .padding([.leading, .trailing], 20)
                                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.yellow/*@END_MENU_TOKEN@*/)
                                .cornerRadius(25.0)
                                .shadow(radius: 5)
                    })
                        Text("Cost: 25")
                            .padding(.top, 10)
                            .foregroundColor(.white)
                    }
                }
                
                //
                
                Spacer()
            }
        }
        
        
    }
    
    func processResults(_ isMax:Bool = false) {
        // Set the backgrounds back to white
        // Map that represents the element to replace in all elements
        self.backgrounds =  self.backgrounds.map { _ in
            Color.white
        }
        
        // Randomiser for the slots (isMax is true and we need to spin all cards)
        if isMax {
            self.numbers = self.numbers.map({ _ in
                Int.random(in: 0...self.symbols.count - 1)
            })
            
        }
        else {
            // Only spins the middle row
            self.numbers[3] = Int.random(in: 0...self.symbols.count - 1)
            self.numbers[4] = Int.random(in: 0...self.symbols.count - 1)
            self.numbers[5] = Int.random(in: 0...self.symbols.count - 1)
        }
        
        // Check Winnings
        processWin(isMax)
        
    
    }
    
    // Checks to see if the random roll contains matches or wins
    func processWin(_ isMax:Bool = false) {
        
        var matches = 0
        
        
        // Process a normal single spin
        if !isMax {
            
            if isMatch(3, 4, 5 ) {
                matches += 1
            }
            else {
                self.credits -= self.betAmount
            }
        }
        else {
            // Process for a max spin
            
            // Top row matches
            if isMatch(0, 1, 2) {
                matches += 1
            }
            
            // Middle row matches
            if isMatch(3, 4, 5) {
                matches += 1
            }
            
            // Bottom row matches
            if isMatch(6, 7, 8) {
                matches += 1
            }
            
            
            // Diagonal left to right
            if isMatch(0, 4, 8) {
                matches += 1
            }
            
            // Diagonal right to left
            if isMatch(2, 4, 6) {
                matches += 1
            }
            
        }
        
        // Check number of matches and reward user with appropriate credits
        if matches > 0 {
            // At least 1 win
            self.credits += matches * betAmount * 5
        }
        else if !isMax {
            // 0 Wins, single spin
            self.credits -= betAmount
        }
        else {
            // 0 Wins, max spin
            self.credits -= betAmount * 5
            
        }
        
    }
    
    // A function to simplify the matching to check if a win is required to be recorded
    func isMatch(_ index1:Int, _ index2:Int, _ index3:Int) -> Bool {
        
        if self.numbers[index1] == self.numbers[index2] && self.numbers[index2] == self.numbers[index3] {
            
            self.backgrounds[index1] = Color.green
            self.backgrounds[index2] = Color.green
            self.backgrounds[index3] = Color.green
            
            return true
        }
        
        return false
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
