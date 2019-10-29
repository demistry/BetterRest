//
//  ContentView.swift
//  BetterRest
//
//  Created by David Ilenwabor on 28/10/2019.
//  Copyright © 2019 Davidemi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date()
    @State private var coffeeAmount = 1
    @State private var sleepAmount = 8.0
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isShown = false
    var body: some View {
        NavigationView{
            VStack{
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time",selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper(value : $sleepAmount, in: 4...12, step: 0.25){
                    Text("\(sleepAmount, specifier: "%g") hours")
                }
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(value : $coffeeAmount, in: 1...20){
                    if coffeeAmount == 1 {
                        Text("1 cup")
                    } else{
                        Text("\(coffeeAmount) cups")
                    }
                }
                
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing: Button(action : calculateBedtime){
                Text("Calculate")
            })
            .alert(isPresented: $isShown) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func calculateBedtime(){
        let model = SleepCalculator()
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (dateComponent.hour ?? 0) * 60 * 60
        let minute = (dateComponent.hour ?? 0) * 60
        
        do{
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is..."
        } catch{
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        isShown = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
