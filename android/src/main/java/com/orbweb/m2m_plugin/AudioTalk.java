package com.orbweb.m2m_plugin;

import android.annotation.SuppressLint;
import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.media.audiofx.AcousticEchoCanceler;
import android.media.audiofx.AutomaticGainControl;
import android.media.audiofx.NoiseSuppressor;

import android.util.Log;



public class AudioTalk{
    public interface RecordAudioListener{
        void onRecord(byte[] data);
    }

    private static final String TAG = "AudioTalk";

    public final static int AUDIO_CODEC_PCM = 0;
    public final static int AUDIO_CODEC_ALAW = 1;
    public final static int AUDIO_CODEC_ULAW = 2;
    public final static int AUDIO_CODEC_AAC = 3;

    private int record_size = 640;

    private int mAudioCodec = AUDIO_CODEC_PCM;
    private int mAudioFormat = AudioFormat.ENCODING_PCM_16BIT;
    private int mAudioSampleRate = 8000;

    private AudioRecord audioRecord;
    private AcousticEchoCanceler m_canceler = null;
    private NoiseSuppressor m_noise = null;
    private AutomaticGainControl m_gain = null;

    private Thread recordThread = null;

    public boolean isSpeaking = false;

    private RecordAudioListener mRecordAudioListener = null;

    public void setRecordAudioListener(RecordAudioListener listener) {
        mRecordAudioListener = listener;
    }

    public AudioTalk setCodec(int code) {
        mAudioCodec = code;
        return this;
    }

    public AudioTalk setSampleRate(int rate) {
        mAudioSampleRate = rate;
        return this;
    }

    public AudioTalk setFormat(int format) {
        mAudioFormat = format;
        return this;
    }

    public int init() {
        if (audioRecord != null) {
            closeAudio();
        }

        audioRecord = findAudioRecord();

        if (audioRecord != null) {
            if (AcousticEchoCanceler.isAvailable()) {
                if (!initAEC(audioRecord.getAudioSessionId()))
                    m_canceler = null;
                Log.i(TAG, "AcousticEchoCanceler support");
            }

            if (NoiseSuppressor.isAvailable()){
                if (!initNS(audioRecord.getAudioSessionId()))
                    m_noise = null;
                Log.i(TAG, "NoiseSuppressor support");
            }

            if (AutomaticGainControl.isAvailable()) {
                if (!initGain(audioRecord.getAudioSessionId()))
                    m_gain = null;
                Log.i(TAG, "AutomaticGainControl support");
            }

            audioRecord.startRecording();
            recordAudio();

            return audioRecord.getAudioSessionId();
        }

        return -1;
    }

    public int getAudioSessionId() {
        if (audioRecord != null) {
            return audioRecord.getAudioSessionId();
        }
        return -1;
    }

    public void closeAudio() {
        m_canceler = null;
        m_noise = null;
        m_gain = null;
        record_size = 0;

        if (audioRecord != null) {
            audioRecord.stop();
            audioRecord.release();
            audioRecord = null;
        }

        mRecordAudioListener = null;
    }

    private AudioRecord findAudioRecord() {
        int mAudioChannel = AudioFormat.CHANNEL_IN_MONO;
        Log.i(TAG, "Attempting rate " + mAudioSampleRate + "Hz, bits: " + mAudioFormat + ", channel: "
                + mAudioChannel);
        try {
            int bufferSize = AudioRecord.getMinBufferSize(mAudioSampleRate, mAudioChannel, mAudioFormat);
            if (bufferSize != AudioRecord.ERROR_BAD_VALUE) {
                @SuppressLint("MissingPermission")
                AudioRecord _recorder = new AudioRecord(MediaRecorder.AudioSource.MIC,
                        mAudioSampleRate,
                        mAudioChannel,
                        mAudioFormat,
                        bufferSize);

                if (mAudioCodec == AUDIO_CODEC_AAC)
                    record_size = bufferSize;

                Log.i(TAG, "BufferSize " + bufferSize );
                if (_recorder.getState() == AudioRecord.STATE_INITIALIZED)
                    return _recorder;
                else Log.w(TAG, "recorder.getState() " + _recorder.getState());
            }
        } catch (Exception e) {
            Log.e(TAG, "getMinBufferSize fail " + e.getMessage());
        }

        return null;
    }

    private boolean initAEC(int audioSession)
    {
        if (m_canceler != null)
        {
            return false;
        }
        m_canceler = AcousticEchoCanceler.create(audioSession);
        if (m_canceler != null) {
            m_canceler.setEnabled(true);
            return m_canceler.getEnabled();
        }
        return false;
    }

    private boolean initNS(int audioSession) {
        if (m_noise != null) return true;
        m_noise = NoiseSuppressor.create(audioSession);
        if (m_noise != null) {
            m_noise.setEnabled(true);
            return m_noise.getEnabled();
        }
        return false;
    }

    private boolean initGain(int audioSession) {
        if (m_gain != null) return true;
        m_gain = AutomaticGainControl.create(audioSession);
        if (m_gain != null) {
            m_gain.setEnabled(true);
            return m_gain.getEnabled();
        }
        return false;
    }

    private void recordAudio() {
        if (recordThread == null) {
            recordThread = new Thread(() -> {
                while (record_size > 0) {
                    int size = record_size;
                    short[] buffer = null;
                    byte[] bytes;
                    byte[] G711 = null;

                    if (mAudioCodec == AUDIO_CODEC_AAC || mAudioCodec == AUDIO_CODEC_PCM) {
                        bytes = new byte[size];
                        audioRecord.read(bytes, 0, size);
                    }
                    else {
                        buffer = new short[size];
                        audioRecord.read(buffer, 0, size);
                    }

                    if (isSpeaking) {
                        if (mAudioCodec == AUDIO_CODEC_ALAW) {
                            G711 = new byte[size];
                            G711Tools.linear2alaw(buffer, 0, G711, size);
                        } else if (mAudioCodec == AUDIO_CODEC_ULAW) {
                            G711 = new byte[size];
                            G711Tools.linear2ulaw(buffer, 0, G711, size);
                        }

                        if (mRecordAudioListener != null && G711 != null) {
                            mRecordAudioListener.onRecord(G711);
                        }
                    }

                }

                Log.i(TAG, "stop audio recording");
                recordThread = null;
            });

            recordThread.start();
        }
    }

}
