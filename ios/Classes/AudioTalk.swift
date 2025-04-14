import UIKit
import AudioUnit
import AudioToolbox
import AVFoundation
import Foundation



public class AudioTalk : NSObject {
    let TAG : String = "AudioTalk"
    var mAudioCodec :Int = 0
    var mAudioFormat :Int = 0
    var mAudioRate :Double = 0.0
    var audioUnit: AudioComponentInstance? = nil
    var g711encode: G711Manager?
    var isSpeaking: Bool = false
    
    //static var sharedInstance = AudioTalk()

    public var onRecordData: ((Data) -> ())?

    public func initAudioTalk(audioCode: Int, audioFormat: Int, audioRate:Double) -> Int {
        mAudioCodec = audioCode
        mAudioFormat = audioFormat
        mAudioRate = audioRate
        g711encode = G711Manager()
        
        print("initAudioTalk audioCode:\(audioCode), audioFormat:\(audioFormat), audioRate:\(audioRate)");
        return Int(initAudioComponent())
    }

    public func closeAudio() -> Void {
        g711encode = nil
        AudioOutputUnitStop(audioUnit!)
        AudioComponentInstanceDispose(audioUnit!)

        audioUnit = nil
    }

    private func initAudioComponent() -> OSStatus{
        
        if let existingUnit = audioUnit {
            print("AudioUnit already exists, stopping and disposing...")
            AudioOutputUnitStop(existingUnit)
            AudioComponentInstanceDispose(existingUnit)
            audioUnit = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        let sampleRate = audioSession.sampleRate
        let preferredSampleRate = audioSession.preferredSampleRate
        
        print("AudioUnit sample rate = \(sampleRate)")
        print("AudioUnit preferred sample rate = \(preferredSampleRate)")
        
        let kDefaultBufferDurationSeconds = 0.02
        
        do {
            if (mAudioRate != preferredSampleRate) {
                try audioSession.setPreferredSampleRate(mAudioRate)
                
                print("AudioUnit current preferred sample rate = \(audioSession.preferredSampleRate)")
                print("AudioUnit current sample rate = \(audioSession.sampleRate)")
            }
            
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat)
            
            try audioSession.setPreferredIOBufferDuration(kDefaultBufferDurationSeconds)
            try audioSession.setActive(true)
        } catch {
            print("AudioSession setup error: \(error)")
            return -1 // 或者回傳對應的 OSStatus / Int 表示失敗
        }
        var audioDesc: AudioComponentDescription = AudioComponentDescription()
        audioDesc.componentType         = kAudioUnitType_Output
        audioDesc.componentSubType      = kAudioUnitSubType_VoiceProcessingIO
        audioDesc.componentManufacturer = kAudioUnitManufacturer_Apple
        audioDesc.componentFlags        = 0
        audioDesc.componentFlagsMask    = 0
        
        let inputComponent = AudioComponentFindNext(nil, &audioDesc)!
        
        var status: OSStatus
        
        status = AudioComponentInstanceNew(inputComponent, &audioUnit)
        
        if (status != noErr) {
            audioUnit = nil
            print("couldn't create a new instance of AURemoteIO, status : %d \n",status)
            return status
        }
        
        let bus1 : AudioUnitElement = 1
        var flag:UInt32 = 1
        
        status = AudioUnitSetProperty(audioUnit!,
                                      kAudioOutputUnitProperty_EnableIO,
                                      kAudioUnitScope_Input,
                                      bus1,
                                      &flag,
                                      UInt32(MemoryLayout<UInt32>.size))
        if (status != noErr) {
            print("AudioUnitSetProperty Input error : %d", status)
            return status
        }
        
        flag = 0
        status = AudioUnitSetProperty(audioUnit!,
                                      kAudioOutputUnitProperty_EnableIO,
                                      kAudioUnitScope_Output,
                                      0,
                                      &flag,
                                      UInt32(MemoryLayout<UInt32>.size))
        if (status != noErr) {
            print("AudioUnitSetProperty Output error : %d", status)
            return status
        }
        
        let finalSampleRate = audioSession.sampleRate
        if abs(finalSampleRate - mAudioRate) > 0.1 {
            print("Warning: Hardware sample rate is \(finalSampleRate), not \(mAudioRate)")
            // 你可以視情況來決定要不要強制讓 AudioStreamBasicDescription 跟 finalSampleRate 同步
            // format.mSampleRate = finalSampleRate
            //mAudioRate = finalSampleRate;
        }
        
        var format: AudioStreamBasicDescription = AudioStreamBasicDescription()
        format.mSampleRate = mAudioRate
        format.mFormatID = kAudioFormatLinearPCM
        format.mChannelsPerFrame = 1
        
        format.mFormatFlags     = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
        format.mBitsPerChannel  = 16;
        format.mBytesPerFrame = (format.mBitsPerChannel / 8) * format.mChannelsPerFrame
        format.mBytesPerPacket  = format.mBytesPerFrame
        format.mFramesPerPacket = 1
        
        status = AudioUnitSetProperty(audioUnit!,
                                      kAudioUnitProperty_StreamFormat,
                                      kAudioUnitScope_Output,
                                      bus1,
                                      &format,
                                      UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
        
        if (status != noErr) {
            print("AudioUnitSetProperty Output format error : %d", status)
            return status
        }
        
        // Set the recording callback
        var callbackStruct = AURenderCallbackStruct()
        
        callbackStruct.inputProc = recordingCallback;
        callbackStruct.inputProcRefCon = Unmanaged.passUnretained(self).toOpaque()
        status = AudioUnitSetProperty(audioUnit!,
                                      kAudioOutputUnitProperty_SetInputCallback,
                                      kAudioUnitScope_Global,
                                      bus1,
                                      &callbackStruct,
                                      UInt32(MemoryLayout<AURenderCallbackStruct>.size))
        
        var maxFramesPerSlice :UInt32  = 4096
        
        AudioUnitSetProperty (audioUnit!,
                              kAudioUnitProperty_MaximumFramesPerSlice,
                              kAudioUnitScope_Global,
                              0,
                              &maxFramesPerSlice,
                              UInt32(MemoryLayout<UInt32>.size))
        
        // Initialize the RemoteIO unit
        status = AudioUnitInitialize(audioUnit!)
        if status != noErr {
            print("AudioUnitInitialize failed with status: \(status)")
            return status
        }
        print("Initialize the RemoteIO unit succsessionfully.\n");
        
        status = AudioOutputUnitStart(audioUnit!)

        if status != noErr {
            print("AudioOutputUnitStart failed with status: \(status)")
            return status
        }
        return status;
    }

    func processSampleData(_ data:Data) -> Void {
        if (!isSpeaking) {
            return
        }
    
        var g711data : Data?
        let code = mAudioCodec;
        
        if (code == 1) {
            //aLaw
            g711data = g711encode?.encodeG711(data, codecType: 0)
        } else if (code == 2){
            //uLaw
            g711data = g711encode?.encodeG711(data, codecType: 1)
        } else {
            onRecordData?(data)
        }
        
        //TODO push data
        if (g711data != nil) {
            if let g711data = g711data {
                onRecordData?(g711data)
            }

        }
        
    }
}

func recordingCallback(inRefCon: UnsafeMutableRawPointer,
                       ioActionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
                       inTimeStamp: UnsafePointer<AudioTimeStamp>,
                       inBusNumber: UInt32,
                       inNumberFrames: UInt32,
                       ioData: UnsafeMutablePointer<AudioBufferList>?) -> OSStatus {
    
    let recorder = Unmanaged<AudioTalk>.fromOpaque(inRefCon).takeUnretainedValue()
    
    guard let audioUnit = recorder.audioUnit else {
        print("audioUnit not initialize? \n audioUnit: \(String(describing: recorder.audioUnit))")
        return noErr
    }
    
    if inBusNumber != 1 {
        print("Unexpected bus number: \(inBusNumber). Skipping render.")
        return noErr
    }
    
    var status = noErr

    let bufferSize = Int(inNumberFrames) * 2
    let audioBufferListMemory = UnsafeMutableRawPointer.allocate(
        byteCount: MemoryLayout<AudioBufferList>.size + MemoryLayout<AudioBuffer>.size * 0,
        alignment: MemoryLayout<AudioBufferList>.alignment
    )
    let audioBufferList = audioBufferListMemory.bindMemory(to: AudioBufferList.self, capacity: 1)
    audioBufferList.pointee.mNumberBuffers = 1
    audioBufferList.pointee.mBuffers.mNumberChannels = 1
    audioBufferList.pointee.mBuffers.mDataByteSize = UInt32(bufferSize)
    audioBufferList.pointee.mBuffers.mData = malloc(bufferSize)

    status = AudioUnitRender(audioUnit,
                             ioActionFlags,
                             inTimeStamp,
                             inBusNumber,
                             inNumberFrames,
                             audioBufferList)

    if status != noErr {
        return status
    }

    if let mData = audioBufferList.pointee.mBuffers.mData {
        let data = Data(bytes: mData, count: Int(audioBufferList.pointee.mBuffers.mDataByteSize))
        recorder.processSampleData(data)
        free(mData)
    }
    audioBufferListMemory.deallocate()

    
    return noErr
}
