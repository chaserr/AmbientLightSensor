//
//  AmbientLightSensorReader.swift
//  Created on 2023/6/1
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2023 Zepp Health. All rights reserved.
//  @author tongxing(tongxing@zepp.com)   
//

import Foundation
import Combine
import SensorKit

final class AmbientLightSensorReader: NSObject, ObservableObject {

    enum UpdateFrequency: TimeInterval {
        case realtime = 0.1
        case fast = 5
        case slow = 10
    }

    let sensorReader = SRSensorReader(sensor: .ambientLightSensor)
    let fetchRequest = SRFetchRequest()

    public var isSensorReady: Bool {
        if sensorReader.authorizationStatus != .authorized {
            requestAuthorization()
            return false
        }
        return true
    }

    @Published public var ambientLightValue: Double = 0


    public init(frequency: UpdateFrequency = .fast) {
        super.init()
        sensorReader.delegate = self
        /// 一般都有一个查找设备的过程        sensorReader.fetchDevices()
        /// 然后在delegate中处理查询到的设备进行fetch
        /// 这里因为是iPhone程序，只是使用当前设备即可
        fetchRequest.device = SRDevice.current
        /// SensorKit 在新记录的数据上放置 24 小时的保留期，然后应用才能访问它。
        /// 这使用户有机会删除他们不想与应用程序共享的任何数据。如果提取请求的时间范围与此保留期重叠，则提取请求不会返回任何结果。
        let currentDate = Date()
        let tenSecondsAgo = currentDate.addingTimeInterval(-10)
        let tenSecondsAgoTimestamp = tenSecondsAgo.timeIntervalSince1970
        fetchRequest.from = SRAbsoluteTime.fromCFAbsoluteTime(_cf: tenSecondsAgoTimestamp)
        fetchRequest.to = SRAbsoluteTime.fromCFAbsoluteTime(_cf: CFAbsoluteTimeGetCurrent())
        sensorReader.fetch(fetchRequest)
    }

    deinit { stopRecording() }

}

extension AmbientLightSensorReader {
    func startRecording() {
        sensorReader.startRecording()
    }

    func stopRecording() {
        sensorReader.stopRecording()
    }
}

extension AmbientLightSensorReader {
    func requestAuthorization() {
        SRSensorReader.requestAuthorization(sensors: [.ambientLightSensor]) { error in
            if let error {
                print("光环境传感器授权失败\(error)")
            } else {
                print("用户授权提示处理中，等待授权状态更改。")
            }
        }
    }
}

extension AmbientLightSensorReader : SRSensorReaderDelegate {

    func sensorReaderWillStartRecording(_ reader: SRSensorReader) {
        print("光环境传感器开始工作")
    }

    func sensorReader(_ reader: SRSensorReader, startRecordingFailedWithError error: Error) {
        print("光环境传感器启动失败\(error)")
    }

    func sensorReader(_ reader: SRSensorReader, didChange authorizationStatus: SRAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("用户未作出任何选择")
        case .authorized:
            print("用户授权成功")
        case .denied:
            print("用户拒绝授权")
        @unknown default:
            break
        }
    }

    func sensorReader(_ reader: SRSensorReader, fetching fetchRequest: SRFetchRequest, didFetchResult result: SRFetchResult<AnyObject>) -> Bool {
        switch result.sample {
        case let lightSample as SRAmbientLightSample:
            // 描述样本光亮度和色调的坐标对
            let chromaticity = lightSample.chromaticity
            // 描述样品光通量的对象
            let lux = lightSample.lux
            // 灯光相对于传感器的位置
            let placement = lightSample.placement
            print(lightSample)
        default:
            print("没有获取到数据")
            return false
        }
        return true
    }

    func sensorReader(_ reader: SRSensorReader, didCompleteFetch fetchRequest: SRFetchRequest) {
        print("Reader did complete fetch")
    }

    func sensorReader(_ reader: SRSensorReader, fetching fetchRequest: SRFetchRequest, failedWithError error: Error) {
        print("Reader fetch failed: \(error)")
    }
}
