//
//  ContentView.swift
//  HeyRest
//
//  Created by Максим on 25.12.2020.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepHours = 8.0
    @State private var badDate = timeOfWakeUp
    @State private var coffeeCups = 0
    @State private var timeToSleep = Date()
    @State private var alertTitle = ""
    @State var alertMessage = ""
    @State var showAlert = false
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.pink]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack(alignment: .center, spacing: 20){
                    Text("How much hours would you sleep")
                        .font(.title2)
                    Stepper(value: $sleepHours, in: 4...12, step: 0.25){
                        Text("\(sleepHours, specifier: "%g")")
                    }
                    Text("When do you want to wake up")
                        .font(.title2)
                    DatePicker("When do you want to wake up", selection: $badDate, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                    Stepper(value: $coffeeCups, in: 0...10, step: 1){
                        if coffeeCups <= 1 {
                            Text("\(coffeeCups) coffee cup for today")
                        }
                        else{
                            Text("\(coffeeCups) coffee cups for today")
                        }
                    }
                    Text("\(timeToSleep) is the best time to sleep")
                    Spacer()
                    Button(action: calculateSleepTime){
                        Text("Calculate").font(.largeTitle).lineLimit(nil).opacity(1).shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 4, x: 1.0, y: 1.0 )
                    }
                    Spacer()
                }.foregroundColor(.white)
                .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
            }.navigationBarTitle("HeyRest")
            //probably issue, but i ll choose something different
//             .navigationBarItems(trailing:
//                Button(action: calculateSleepTime) {
//                    Text("Calculate").lineLimit(nil).position().opacity(1).shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 4, x: 1.0, y: 1.0 ).font(.headline)
//                })
            .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Gotcha!")))
                 }
        }
    }
    static var timeOfWakeUp: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateSleepTime(){
        let model = HeyRest_1()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: badDate)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepHours, coffee: Double(coffeeCups))
            
            let sleepTime = badDate - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your sleep time is: "

        } catch {
            alertTitle = "That`s, was an error!"
            alertMessage = "With calculation your bad time"
        }
        showAlert = true
            }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
