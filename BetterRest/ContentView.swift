//
//  ContentView.swift
//  BetterRest
//
//  Created by David Ilenwabor on 28/10/2019.
//  Copyright © 2019 Davidemi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeupTime
    @State private var coffeeAmount = 1
    @State private var sleepAmount = 8.0
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isShown = false
    
    static var defaultWakeupTime : Date{
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    var body: some View {
        NavigationView{
            Form{
                VStack(alignment: .leading, spacing: 0){
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time",selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                Section(header : Text("Desired amount of sleep")){
                    Stepper(value : $sleepAmount, in: 4...12, step: 0.25){
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header : Text("Daily coffee intake")){
                    Picker("Number of cups", selection: $coffeeAmount){
                        ForEach(1..<21){
                            if $0 == 1{
                                Text("1 cup")
                            } else{
                                Text("\($0) cups")
                            }
                            
                        }
                    }
                }
                
                Group{
                    HStack(alignment : .center){
                        Text("Your ideal bed time is \(estimatedBedTime)")
                        .foregroundColor(.green)
                            .font(.headline)
                    }
                    
                }
            }
            .navigationBarTitle("BetterRest")
            .alert(isPresented: $isShown) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private var estimatedBedTime : String{
        let model = SleepCalculator()
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (dateComponent.hour ?? 0) * 60 * 60
        let minute = (dateComponent.hour ?? 0) * 60
        
        do{
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
        } catch{
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            isShown = true
            return ""
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
