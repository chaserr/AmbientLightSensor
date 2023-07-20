//
//  ContentView.swift
//  Created on 2023/6/1
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2023 Zepp Health. All rights reserved.
//  @author tongxing(tongxing@zepp.com)   
//

import SwiftUI

struct ContentView: View {
    @State private var ambientLight: Double = 0.0

    var body: some View {
        VStack {
            Text("Ambient Light: \(ambientLight)")
                .padding()
        }
        .onAppear {
//            startMonitoringAmbientLight()
        }
    }

//    func startMonitoringAmbientLight() {
//        guard UIDevice.current.isAmbientLightSensorAvailable else {
//            print("Ambient light sensor is not available.")
//            return
//        }
//
//        let lightSensor = UIScreen.main.ambientLightSensor
//
//        lightSensor?.setUpdateHandler { lightLevel, _ in
//            ambientLight = lightLevel
//        }
//
//        lightSensor?.start()
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
