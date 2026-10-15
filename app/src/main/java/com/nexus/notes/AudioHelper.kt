package com.nexus.notes

import android.content.Context
import android.media.MediaPlayer
import android.media.MediaRecorder
import android.os.Build
import java.io.File

class AudioHelper(private val context: Context) {
    private var mediaRecorder: MediaRecorder? = null
    private var mediaPlayer: MediaPlayer? = null
    private var currentOutputFile: File? = null
    private var recordingStartTime: Long = 0L

    var currentlyPlayingPath: String? = null
        private set

    fun startRecording(): File? {
        stopRecording()
        stopPlayback()

        val file = File(context.filesDir, "voice_${System.currentTimeMillis()}.m4a")
        currentOutputFile = file

        val recorder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            MediaRecorder(context)
        } else {
            @Suppress("DEPRECATION")
            MediaRecorder()
        }

        return try {
            recorder.apply {
                setAudioSource(MediaRecorder.AudioSource.MIC)
                setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
                setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
                setAudioEncodingBitRate(128000)
                setAudioSamplingRate(44100)
                setOutputFile(file.absolutePath)
                prepare()
                start()
            }
            mediaRecorder = recorder
            recordingStartTime = System.currentTimeMillis()
            file
        } catch (e: Exception) {
            recorder.release()
            file.delete()
            currentOutputFile = null
            null
        }
    }

    fun stopRecording(): Pair<String?, Long> {
        val recorder = mediaRecorder ?: return Pair(null, 0L)
        val duration = System.currentTimeMillis() - recordingStartTime
        val file = currentOutputFile

        return try {
            recorder.stop()
            Pair(file?.absolutePath, duration.coerceAtLeast(1000L))
        } catch (e: RuntimeException) {
            file?.delete()
            Pair(null, 0L)
        } finally {
            recorder.release()
            mediaRecorder = null
            currentOutputFile = null
        }
    }

    fun togglePlayback(filePath: String, onCompletion: () -> Unit): Boolean {
        if (currentlyPlayingPath == filePath && mediaPlayer?.isPlaying == true) {
            stopPlayback()
            return false
        }

        stopPlayback()
        val file = File(filePath)
        if (!file.exists()) {
            onCompletion()
            return false
        }

        return try {
            mediaPlayer = MediaPlayer().apply {
                setDataSource(filePath)
                prepare()
                start()
                setOnCompletionListener {
                    stopPlayback()
                    onCompletion()
                }
            }
            currentlyPlayingPath = filePath
            true
        } catch (e: Exception) {
            stopPlayback()
            onCompletion()
            false
        }
    }

    fun stopPlayback() {
        try {
            mediaPlayer?.stop()
        } catch (_: Exception) {}
        mediaPlayer?.release()
        mediaPlayer = null
        currentlyPlayingPath = null
    }

    fun releaseAll() {
        stopRecording()
        stopPlayback()
    }
}
