#!/usr/bin/env bash
set -e

echo "🚀 Развертывание полного проекта Nexus Notes..."

mkdir -p .github/workflows
mkdir -p app/src/main/java/com/nexus/notes
mkdir -p app/src/main/res/mipmap-anydpi-v26
mkdir -p app/src/main/res/drawable-nodpi
mkdir -p app/src/main/res/drawable

cat << 'GRADLE_SETTINGS' > settings.gradle.kts
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "NexusNotes"
include(":app")
GRADLE_SETTINGS

cat << 'ROOT_GRADLE' > build.gradle.kts
plugins {
    id("com.android.application") version "8.2.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}
ROOT_GRADLE

cat << 'GRADLE_PROPS' > gradle.properties
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
kotlin.code.style=official
android.nonTransitiveRClass=true
GRADLE_PROPS

cat << 'APP_GRADLE' > app/build.gradle.kts
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("kotlin-kapt")
}

android {
    namespace = "com.nexus.notes"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.nexus.notes"
        minSdk = 26
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.10"
    }
    kotlinOptions {
        jvmTarget = "17"
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

dependencies {
    val composeBom = platform("androidx.compose:compose-bom:2024.02.02")
    implementation(composeBom)
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0")
    implementation("androidx.lifecycle:lifecycle-runtime-compose:2.7.0")

    val roomVersion = "2.6.1"
    implementation("androidx.room:room-runtime:$roomVersion")
    implementation("androidx.room:room-ktx:$roomVersion")
    kapt("androidx.room:room-compiler:$roomVersion")
}
APP_GRADLE

cat << 'MANIFEST' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.nexus.notes">

    <uses-permission android:name="android.permission.RECORD_AUDIO" />

    <application
        android:allowBackup="true"
        android:label="Nexus Notes"
        android:icon="@mipmap/ic_desktop_launcher"
        android:roundIcon="@mipmap/ic_desktop_launcher"
        android:supportsRtl="true"
        android:theme="@android:style/Theme.Material.Light.NoActionBar">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:icon="@mipmap/ic_desktop_launcher"
            android:roundIcon="@mipmap/ic_desktop_launcher"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
MANIFEST

if [ -f "icon.png" ]; then
    cp icon.png app/src/main/res/drawable-nodpi/ic_desktop_nexus.png
    cat << 'ADAPTIVE_PNG' > app/src/main/res/mipmap-anydpi-v26/ic_desktop_launcher.xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background>
        <color android:color="#26272B" />
    </background>
    <foreground>
        <inset
            android:drawable="@drawable/ic_desktop_nexus"
            android:insetLeft="-12%"
            android:insetTop="-12%"
            android:insetRight="-12%"
            android:insetBottom="-12%" />
    </foreground>
</adaptive-icon>
ADAPTIVE_PNG
    echo "✅ Использован твой icon.png для иконки рабочего стола."
else
    cat << 'VECTOR_ICON' > app/src/main/res/drawable/ic_desktop_nexus_vector.xml
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <group android:pivotX="54" android:pivotY="55" android:rotation="-6">
        <path android:fillColor="#FF52545A" android:pathData="M34,25 L72,25 A6,6 0 0,1 78,31 L78,79 A6,6 0 0,1 72,85 L34,85 A6,6 0 0,1 28,79 L28,31 A6,6 0 0,1 34,25 Z" />
    </group>
    <path android:fillColor="#FFF2F3F5" android:pathData="M34,25 L72,25 A6,6 0 0,1 78,31 L78,79 A6,6 0 0,1 72,85 L34,85 A6,6 0 0,1 28,79 L28,31 A6,6 0 0,1 34,25 Z" />
    <path android:fillColor="#FFD4D6DC" android:pathData="M34,25 L72,25 A6,6 0 0,1 78,31 L78,37 L28,37 L28,31 A6,6 0 0,1 34,25 Z" />
    <path android:fillColor="#FF52555C" android:pathData="M38.5,20.5 A1.8,1.8 0 0,1 42.1,20.5 L42.1,28.5 A1.8,1.8 0 0,1 38.5,28.5 Z" />
    <path android:fillColor="#FF52555C" android:pathData="M48.5,20.5 A1.8,1.8 0 0,1 52.1,20.5 L52.1,28.5 A1.8,1.8 0 0,1 48.5,28.5 Z" />
    <path android:fillColor="#FF52555C" android:pathData="M58.5,20.5 A1.8,1.8 0 0,1 62.1,20.5 L62.1,28.5 A1.8,1.8 0 0,1 58.5,28.5 Z" />
    <path android:fillColor="#FF52555C" android:pathData="M68.5,20.5 A1.8,1.8 0 0,1 72.1,20.5 L72.1,28.5 A1.8,1.8 0 0,1 68.5,28.5 Z" />
    <path android:fillColor="#FF52555C" android:pathData="M35.5,43 L39.5,43 A1.5,1.5 0 0,1 41,44.5 L41,48.5 A1.5,1.5 0 0,1 39.5,50 L35.5,50 A1.5,1.5 0 0,1 34,48.5 L34,44.5 A1.5,1.5 0 0,1 35.5,43 Z" />
    <path android:fillColor="#00000000" android:pathData="M35.6,46.6 L37.1,48.1 L39.6,45.1" android:strokeWidth="1.2" android:strokeColor="#FFFFFFFF" android:strokeLineCap="round" android:strokeLineJoin="round" />
    <path android:fillColor="#FF6E717A" android:pathData="M45.5,45 L67.5,45 A1.5,1.5 0 0,1 69,46.5 A1.5,1.5 0 0,1 67.5,48 L45.5,48 A1.5,1.5 0 0,1 44,46.5 A1.5,1.5 0 0,1 45.5,45 Z" />
    <path android:fillColor="#00000000" android:pathData="M35.5,53 L39.5,53 A1.5,1.5 0 0,1 41,54.5 L41,58.5 A1.5,1.5 0 0,1 39.5,60 L35.5,60 A1.5,1.5 0 0,1 34,58.5 L34,54.5 A1.5,1.5 0 0,1 35.5,53 Z" android:strokeWidth="1.1" android:strokeColor="#FF979AA1" />
    <path android:fillColor="#FF979AA1" android:pathData="M45.5,55 L63.5,55 A1.5,1.5 0 0,1 65,56.5 A1.5,1.5 0 0,1 63.5,58 L45.5,58 A1.5,1.5 0 0,1 44,56.5 A1.5,1.5 0 0,1 45.5,55 Z" />
    <path android:fillColor="#FF979AA1" android:pathData="M35.5,64 L66.5,64 A1.3,1.3 0 0,1 67.8,65.3 A1.3,1.3 0 0,1 66.5,66.6 L35.5,66.6 A1.3,1.3 0 0,1 34.2,65.3 A1.3,1.3 0 0,1 35.5,64 Z" />
    <path android:fillColor="#FF979AA1" android:pathData="M35.5,70 L60.5,70 A1.3,1.3 0 0,1 61.8,71.3 A1.3,1.3 0 0,1 60.5,72.6 L35.5,72.6 A1.3,1.3 0 0,1 34.2,71.3 A1.3,1.3 0 0,1 35.5,70 Z" />
    <path android:fillColor="#FFD4D6DC" android:pathData="M35.5,76 L51.5,76 A1.3,1.3 0 0,1 52.8,77.3 A1.3,1.3 0 0,1 51.5,78.6 L35.5,78.6 A1.3,1.3 0 0,1 34.2,77.3 A1.3,1.3 0 0,1 35.5,76 Z" />
    <group android:pivotX="68" android:pivotY="60" android:rotation="38">
        <path android:fillColor="#FF3B3D42" android:pathData="M65,38h6v28h-6z" />
        <path android:fillColor="#FF979AA1" android:pathData="M65,33 A3,3 0 0,1 71,33 L71,38 L65,38 Z" />
        <path android:fillColor="#FFD4D6DC" android:pathData="M65,66 L71,66 L68,73 Z" />
        <path android:fillColor="#FF1C1D20" android:pathData="M67,70.5 L69,70.5 L68,73 Z" />
    </group>
</vector>
VECTOR_ICON

    cat << 'ADAPTIVE_VEC' > app/src/main/res/mipmap-anydpi-v26/ic_desktop_launcher.xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background>
        <color android:color="#26272B" />
    </background>
    <foreground android:drawable="@drawable/ic_desktop_nexus_vector" />
</adaptive-icon>
ADAPTIVE_VEC
    echo "✅ Создана векторная копия твоей иконки."
fi

cat << 'NOTE_DB' > app/src/main/java/com/nexus/notes/NoteDatabase.kt
package com.nexus.notes

import android.content.Context
import androidx.room.*
import kotlinx.coroutines.flow.Flow
import org.json.JSONArray
import org.json.JSONObject
import java.util.UUID

enum class NoteType {
    TEXT, CHECKLIST, VOICE
}

data class ChecklistItem(
    val id: String = UUID.randomUUID().toString(),
    val text: String,
    val isChecked: Boolean
)

@Entity(tableName = "notes")
data class NoteEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val title: String,
    val content: String = "",
    val type: NoteType = NoteType.TEXT,
    val checklistItems: List<ChecklistItem> = emptyList(),
    val audioFilePath: String? = null,
    val audioDurationMs: Long = 0L,
    val timestamp: Long = System.currentTimeMillis()
)

class NoteTypeConverters {
    @TypeConverter
    fun fromNoteType(type: NoteType): String = type.name

    @TypeConverter
    fun toNoteType(value: String): NoteType = runCatching { NoteType.valueOf(value) }.getOrDefault(NoteType.TEXT)

    @TypeConverter
    fun fromChecklist(items: List<ChecklistItem>): String {
        val array = JSONArray()
        items.forEach { item ->
            val obj = JSONObject().apply {
                put("id", item.id)
                put("text", item.text)
                put("isChecked", item.isChecked)
            }
            array.put(obj)
        }
        return array.toString()
    }

    @TypeConverter
    fun toChecklist(data: String): List<ChecklistItem> {
        if (data.isBlank()) return emptyList()
        return runCatching {
            val array = JSONArray(data)
            val list = mutableListOf<ChecklistItem>()
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                list.add(
                    ChecklistItem(
                        id = obj.optString("id", UUID.randomUUID().toString()),
                        text = obj.optString("text", ""),
                        isChecked = obj.optBoolean("isChecked", false)
                    )
                )
            }
            list
        }.getOrDefault(emptyList())
    }
}

@Dao
interface NoteDao {
    @Query("SELECT * FROM notes ORDER BY timestamp DESC")
    fun getAllNotes(): Flow<List<NoteEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertNote(note: NoteEntity): Long

    @Update
    suspend fun updateNote(note: NoteEntity)

    @Delete
    suspend fun deleteNote(note: NoteEntity)
}

@Database(entities = [NoteEntity::class], version = 1, exportSchema = false)
@TypeConverters(NoteTypeConverters::class)
abstract class NexusDatabase : RoomDatabase() {
    abstract fun noteDao(): NoteDao

    companion object {
        @Volatile
        private var INSTANCE: NexusDatabase? = null

        fun getInstance(context: Context): NexusDatabase {
            return INSTANCE ?: synchronized(this) {
                Room.databaseBuilder(
                    context.applicationContext,
                    NexusDatabase::class.java,
                    "nexus_notes.db"
                ).build().also { INSTANCE = it }
            }
        }
    }
}
NOTE_DB

cat << 'AUDIO_HELPER' > app/src/main/java/com/nexus/notes/AudioHelper.kt
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
AUDIO_HELPER

cat << 'VIEWMODEL' > app/src/main/java/com/nexus/notes/NotesViewModel.kt
package com.nexus.notes

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import java.io.File

class NotesViewModel(application: Application) : AndroidViewModel(application) {
    private val dao = NexusDatabase.getInstance(application).noteDao()
    val audioHelper = AudioHelper(application)

    private val _searchQuery = MutableStateFlow("")
    val searchQuery: StateFlow<String> = _searchQuery.asStateFlow()

    private val _playingFilePath = MutableStateFlow<String?>(null)
    val playingFilePath: StateFlow<String?> = _playingFilePath.asStateFlow()

    val notes: StateFlow<List<NoteEntity>> = combine(
        dao.getAllNotes(),
        _searchQuery
    ) { allNotes, query ->
        if (query.isBlank()) {
            allNotes
        } else {
            val q = query.trim().lowercase()
            allNotes.filter { note ->
                note.title.lowercase().contains(q) ||
                note.content.lowercase().contains(q) ||
                note.checklistItems.any { it.text.lowercase().contains(q) }
            }
        }
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    fun updateSearchQuery(query: String) {
        _searchQuery.value = query
    }

    fun saveNote(
        id: Long = 0,
        title: String,
        content: String,
        type: NoteType,
        checklistItems: List<ChecklistItem>,
        audioPath: String?,
        audioDurationMs: Long
    ) {
        if (title.isBlank() && content.isBlank() && checklistItems.isEmpty() && audioPath == null) {
            return
        }

        viewModelScope.launch(Dispatchers.IO) {
            val note = NoteEntity(
                id = id,
                title = title.trim(),
                content = content.trim(),
                type = type,
                checklistItems = checklistItems.filter { it.text.isNotBlank() },
                audioFilePath = audioPath,
                audioDurationMs = audioDurationMs,
                timestamp = System.currentTimeMillis()
            )
            dao.insertNote(note)
        }
    }

    fun toggleChecklistItem(note: NoteEntity, itemId: String) {
        viewModelScope.launch(Dispatchers.IO) {
            val updatedList = note.checklistItems.map { item ->
                if (item.id == itemId) item.copy(isChecked = !item.isChecked) else item
            }
            dao.updateNote(note.copy(checklistItems = updatedList))
        }
    }

    fun deleteNote(note: NoteEntity) {
        if (_playingFilePath.value == note.audioFilePath) {
            audioHelper.stopPlayback()
            _playingFilePath.value = null
        }
        viewModelScope.launch(Dispatchers.IO) {
            note.audioFilePath?.let { path ->
                runCatching { File(path).delete() }
            }
            dao.deleteNote(note)
        }
    }

    fun toggleAudioPlayback(filePath: String) {
        val isNowPlaying = audioHelper.togglePlayback(filePath) {
            _playingFilePath.value = null
        }
        _playingFilePath.value = if (isNowPlaying) filePath else null
    }

    override fun onCleared() {
        super.onCleared()
        audioHelper.releaseAll()
    }
}
VIEWMODEL

cat << 'MAIN_ACTIVITY' > app/src/main/java/com/nexus/notes/MainActivity.kt
package com.nexus.notes

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid
import androidx.compose.foundation.lazy.staggeredgrid.StaggeredGridCells
import androidx.compose.foundation.lazy.staggeredgrid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.CheckBox
import androidx.compose.material.icons.outlined.Description
import androidx.compose.material.icons.outlined.Mic
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.delay
import java.io.File
import java.util.Locale

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            NexusNotesTheme {
                NexusNotesApp()
            }
        }
    }
}

@Composable
fun NexusNotesTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val context = LocalContext.current
    val colorScheme = when {
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        darkTheme -> darkColorScheme()
        else -> lightColorScheme()
    }
    MaterialTheme(colorScheme = colorScheme, content = content)
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NexusNotesApp(viewModel: NotesViewModel = viewModel()) {
    val notes by viewModel.notes.collectAsStateWithLifecycle()
    val searchQuery by viewModel.searchQuery.collectAsStateWithLifecycle()
    val playingFilePath by viewModel.playingFilePath.collectAsStateWithLifecycle()

    var activeSheetType by remember { mutableStateOf<NoteType?>(null) }
    var editingNote by remember { mutableStateOf<NoteEntity?>(null) }

    Scaffold(
        topBar = {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .statusBarsPadding()
                    .padding(horizontal = 16.dp, vertical = 8.dp)
            ) {
                OutlinedTextField(
                    value = searchQuery,
                    onValueChange = viewModel::updateSearchQuery,
                    placeholder = { Text("Поиск в Nexus Notes...") },
                    leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
                    trailingIcon = {
                        if (searchQuery.isNotEmpty()) {
                            IconButton(onClick = { viewModel.updateSearchQuery("") }) {
                                Icon(Icons.Default.Close, contentDescription = "Очистить")
                            }
                        }
                    },
                    singleLine = true,
                    shape = RoundedCornerShape(28.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedContainerColor = MaterialTheme.colorScheme.surfaceContainerHigh,
                        unfocusedContainerColor = MaterialTheme.colorScheme.surfaceContainerHigh,
                        focusedBorderColor = MaterialTheme.colorScheme.primary,
                        unfocusedBorderColor = MaterialTheme.colorScheme.outlineVariant
                    ),
                    modifier = Modifier.fillMaxWidth()
                )
            }
        },
        bottomBar = {
            BottomAppBar(
                actions = {
                    IconButton(onClick = {
                        editingNote = null
                        activeSheetType = NoteType.CHECKLIST
                    }) {
                        Icon(Icons.Outlined.CheckBox, contentDescription = "Новый список")
                    }
                    IconButton(onClick = {
                        editingNote = null
                        activeSheetType = NoteType.VOICE
                    }) {
                        Icon(Icons.Outlined.Mic, contentDescription = "Голосовая заметка")
                    }
                },
                floatingActionButton = {
                    FloatingActionButton(
                        onClick = {
                            editingNote = null
                            activeSheetType = NoteType.TEXT
                        },
                        containerColor = MaterialTheme.colorScheme.primaryContainer,
                        contentColor = MaterialTheme.colorScheme.onPrimaryContainer
                    ) {
                        Icon(Icons.Default.Add, contentDescription = "Создать заметку")
                    }
                }
            )
        }
    ) { innerPadding ->
        if (notes.isEmpty()) {
            Box(
                modifier = Modifier.fillMaxSize().padding(innerPadding),
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(
                        imageVector = Icons.Outlined.Description,
                        contentDescription = null,
                        modifier = Modifier.size(64.dp),
                        tint = MaterialTheme.colorScheme.outline
                    )
                    Spacer(modifier = Modifier.height(12.dp))
                    Text(
                        text = if (searchQuery.isBlank()) "Заметок пока нет" else "Ничего не найдено",
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        } else {
            LazyVerticalStaggeredGrid(
                columns = StaggeredGridCells.Fixed(2),
                contentPadding = PaddingValues(12.dp),
                horizontalArrangement = Arrangement.spacedBy(10.dp),
                verticalItemSpacing = 10.dp,
                modifier = Modifier.fillMaxSize().padding(innerPadding)
            ) {
                items(notes, key = { it.id }) { note ->
                    NoteCard(
                        note = note,
                        isPlaying = playingFilePath == note.audioFilePath && note.audioFilePath != null,
                        onCardClick = {
                            if (note.type != NoteType.VOICE) {
                                editingNote = note
                                activeSheetType = note.type
                            }
                        },
                        onDelete = { viewModel.deleteNote(note) },
                        onToggleCheck = { itemId -> viewModel.toggleChecklistItem(note, itemId) },
                        onTogglePlay = {
                            note.audioFilePath?.let { viewModel.toggleAudioPlayback(it) }
                        }
                    )
                }
            }
        }
    }

    if (activeSheetType != null) {
        NoteEditorSheet(
            noteType = activeSheetType!!,
            existingNote = editingNote,
            audioHelper = viewModel.audioHelper,
            onDismiss = {
                activeSheetType = null
                editingNote = null
            },
            onSave = { id, title, content, type, checklist, audioPath, duration ->
                viewModel.saveNote(id, title, content, type, checklist, audioPath, duration)
                activeSheetType = null
                editingNote = null
            }
        )
    }
}

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun NoteCard(
    note: NoteEntity,
    isPlaying: Boolean,
    onCardClick: () -> Unit,
    onDelete: () -> Unit,
    onToggleCheck: (String) -> Unit,
    onTogglePlay: () -> Unit
) {
    ElevatedCard(
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.elevatedCardColors(
            containerColor = MaterialTheme.colorScheme.surfaceContainerLow
        ),
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .combinedClickable(onClick = onCardClick, onLongClick = onDelete)
    ) {
        Column(modifier = Modifier.padding(14.dp)) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth()
            ) {
                if (note.title.isNotBlank()) {
                    Text(
                        text = note.title,
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.SemiBold,
                        maxLines = 2,
                        overflow = TextOverflow.Ellipsis,
                        modifier = Modifier.weight(1f)
                    )
                } else {
                    Spacer(modifier = Modifier.weight(1f))
                }
                IconButton(onClick = onDelete, modifier = Modifier.size(28.dp)) {
                    Icon(
                        imageVector = Icons.Default.DeleteOutline,
                        contentDescription = "Удалить",
                        tint = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.size(18.dp)
                    )
                }
            }

            if (note.title.isNotBlank()) Spacer(modifier = Modifier.height(6.dp))

            when (note.type) {
                NoteType.TEXT -> {
                    Text(
                        text = note.content,
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        maxLines = 10,
                        overflow = TextOverflow.Ellipsis
                    )
                }
                NoteType.CHECKLIST -> {
                    val sortedItems = remember(note.checklistItems) {
                        note.checklistItems.sortedBy { it.isChecked }
                    }
                    Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                        sortedItems.take(8).forEach { item ->
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Checkbox(
                                    checked = item.isChecked,
                                    onCheckedChange = { onToggleCheck(item.id) },
                                    modifier = Modifier.size(24.dp)
                                )
                                Spacer(modifier = Modifier.width(8.dp))
                                Text(
                                    text = item.text,
                                    style = MaterialTheme.typography.bodyMedium,
                                    textDecoration = if (item.isChecked) TextDecoration.LineThrough else TextDecoration.None,
                                    color = if (item.isChecked) MaterialTheme.colorScheme.outline else MaterialTheme.colorScheme.onSurface,
                                    maxLines = 1,
                                    overflow = TextOverflow.Ellipsis
                                )
                            }
                        }
                    }
                }
                NoteType.VOICE -> {
                    Surface(
                        shape = RoundedCornerShape(12.dp),
                        color = MaterialTheme.colorScheme.secondaryContainer,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.padding(horizontal = 8.dp, vertical = 6.dp)
                        ) {
                            FilledIconButton(
                                onClick = onTogglePlay,
                                modifier = Modifier.size(36.dp)
                            ) {
                                Icon(
                                    imageVector = if (isPlaying) Icons.Default.Stop else Icons.Default.PlayArrow,
                                    contentDescription = "Воспроизвести"
                                )
                            }
                            Spacer(modifier = Modifier.width(10.dp))
                            Column {
                                Text(
                                    text = if (isPlaying) "Воспроизведение..." else "Голосовая запись",
                                    style = MaterialTheme.typography.labelMedium,
                                    fontWeight = FontWeight.Medium
                                )
                                Text(
                                    text = formatDuration(note.audioDurationMs),
                                    style = MaterialTheme.typography.labelSmall,
                                    color = MaterialTheme.colorScheme.onSecondaryContainer.copy(alpha = 0.7f)
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NoteEditorSheet(
    noteType: NoteType,
    existingNote: NoteEntity?,
    audioHelper: AudioHelper,
    onDismiss: () -> Unit,
    onSave: (Long, String, String, NoteType, List<ChecklistItem>, String?, Long) -> Unit
) {
    val context = LocalContext.current
    var title by remember { mutableStateOf(existingNote?.title ?: "") }
    var content by remember { mutableStateOf(existingNote?.content ?: "") }
    var checklist by remember {
        mutableStateOf(
            existingNote?.checklistItems ?: listOf(ChecklistItem(text = "", isChecked = false))
        )
    }

    var isRecording by remember { mutableStateOf(false) }
    var recordedFilePath by remember { mutableStateOf(existingNote?.audioFilePath) }
    var recordedDurationMs by remember { mutableStateOf(existingNote?.audioDurationMs ?: 0L) }
    var elapsedSeconds by remember { mutableIntStateOf(0) }

    LaunchedEffect(isRecording) {
        if (isRecording) {
            elapsedSeconds = 0
            while (isRecording) {
                delay(1000L)
                elapsedSeconds++
            }
        }
    }

    val permissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestPermission()
    ) { granted ->
        if (granted) {
            val file = audioHelper.startRecording()
            if (file != null) isRecording = true
        } else {
            Toast.makeText(context, "Для записи нужен доступ к микрофону", Toast.LENGTH_SHORT).show()
        }
    }

    ModalBottomSheet(
        onDismissRequest = {
            if (isRecording) {
                val (path, _) = audioHelper.stopRecording()
                path?.let { File(it).delete() }
            }
            onDismiss()
        }
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .navigationBarsPadding()
                .imePadding()
                .padding(horizontal = 20.dp)
                .padding(bottom = 20.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth()
            ) {
                Text(
                    text = when (noteType) {
                        NoteType.TEXT -> if (existingNote == null) "Новая заметка" else "Редактировать"
                        NoteType.CHECKLIST -> "Список задач"
                        NoteType.VOICE -> "Голосовая заметка"
                    },
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold
                )
                Button(
                    onClick = {
                        if (isRecording) {
                            val (path, duration) = audioHelper.stopRecording()
                            isRecording = false
                            recordedFilePath = path
                            recordedDurationMs = duration
                        }
                        val finalTitle = if (title.isBlank() && noteType == NoteType.VOICE) {
                            "Голосовая заметка"
                        } else title

                        onSave(
                            existingNote?.id ?: 0L,
                            finalTitle,
                            content,
                            noteType,
                            checklist,
                            recordedFilePath,
                            recordedDurationMs
                        )
                    }
                ) {
                    Text("Сохранить")
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            OutlinedTextField(
                value = title,
                onValueChange = { title = it },
                label = { Text("Заголовок") },
                singleLine = true,
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(12.dp))

            when (noteType) {
                NoteType.TEXT -> {
                    OutlinedTextField(
                        value = content,
                        onValueChange = { content = it },
                        label = { Text("Текст заметки...") },
                        minLines = 5,
                        maxLines = 12,
                        modifier = Modifier.fillMaxWidth()
                    )
                }
                NoteType.CHECKLIST -> {
                    LazyColumn(
                        verticalArrangement = Arrangement.spacedBy(8.dp),
                        modifier = Modifier.fillMaxWidth().heightIn(max = 320.dp)
                    ) {
                        itemsIndexed(checklist, key = { _, item -> item.id }) { index, item ->
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Checkbox(
                                    checked = item.isChecked,
                                    onCheckedChange = { checked ->
                                        checklist = checklist.toMutableList().also {
                                            it[index] = item.copy(isChecked = checked)
                                        }
                                    }
                                )
                                OutlinedTextField(
                                    value = item.text,
                                    onValueChange = { newText ->
                                        checklist = checklist.toMutableList().also {
                                            it[index] = item.copy(text = newText)
                                        }
                                    },
                                    placeholder = { Text("Пункт списка...") },
                                    singleLine = true,
                                    modifier = Modifier.weight(1f)
                                )
                                IconButton(
                                    onClick = {
                                        checklist = checklist.toMutableList().also { it.removeAt(index) }
                                    }
                                ) {
                                    Icon(Icons.Default.Close, contentDescription = "Удалить пункт")
                                }
                            }
                        }
                    }

                    TextButton(
                        onClick = { checklist = checklist + ChecklistItem(text = "", isChecked = false) },
                        modifier = Modifier.padding(top = 8.dp)
                    ) {
                        Icon(Icons.Default.Add, contentDescription = null)
                        Spacer(modifier = Modifier.width(6.dp))
                        Text("Добавить пункт")
                    }
                }
                NoteType.VOICE -> {
                    Card(
                        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Column(
                            horizontalAlignment = Alignment.CenterHorizontally,
                            modifier = Modifier.fillMaxWidth().padding(24.dp)
                        ) {
                            Text(
                                text = when {
                                    isRecording -> "Идет запись: ${formatDuration(elapsedSeconds * 1000L)}"
                                    recordedFilePath != null -> "Запись готова (${formatDuration(recordedDurationMs)})"
                                    else -> "Нажмите на микрофон для старта"
                                },
                                style = MaterialTheme.typography.titleMedium
                            )
                            Spacer(modifier = Modifier.height(16.dp))
                            FilledIconButton(
                                onClick = {
                                    if (isRecording) {
                                        val (path, duration) = audioHelper.stopRecording()
                                        isRecording = false
                                        recordedFilePath = path
                                        recordedDurationMs = duration
                                    } else {
                                        val hasPerm = ContextCompat.checkSelfPermission(
                                            context,
                                            Manifest.permission.RECORD_AUDIO
                                        ) == PackageManager.PERMISSION_GRANTED

                                        if (hasPerm) {
                                            recordedFilePath?.let { File(it).delete() }
                                            val file = audioHelper.startRecording()
                                            if (file != null) isRecording = true
                                        } else {
                                            permissionLauncher.launch(Manifest.permission.RECORD_AUDIO)
                                        }
                                    }
                                },
                                colors = IconButtonDefaults.filledIconButtonColors(
                                    containerColor = if (isRecording) MaterialTheme.colorScheme.error else MaterialTheme.colorScheme.primary
                                ),
                                modifier = Modifier.size(64.dp)
                            ) {
                                Icon(
                                    imageVector = if (isRecording) Icons.Default.Stop else Icons.Default.Mic,
                                    contentDescription = "Запись",
                                    modifier = Modifier.size(32.dp)
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

private fun formatDuration(durationMs: Long): String {
    val totalSeconds = (durationMs / 1000).coerceAtLeast(0)
    val minutes = totalSeconds / 60
    val seconds = totalSeconds % 60
    return String.format(Locale.getDefault(), "%02d:%02d", minutes, seconds)
}
MAIN_ACTIVITY

cat << 'WORKFLOW' > .github/workflows/build_apk.yml
name: Build Nexus Notes APK

on:
  push:
    branches: [ "*" ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Setup Gradle
        uses: gradle/actions/setup-gradle@v3
        with:
          gradle-version: '8.5'

      - name: Build Release APK
        run: gradle assembleRelease --no-daemon

      - name: Upload Ready APK
        uses: actions/upload-artifact@v4
        with:
          name: Nexus-Notes-APK
          path: app/build/outputs/apk/release/app-release.apk
WORKFLOW

git add .
git commit -m "Initialize Nexus Notes & Trigger APK Build"
git push

echo "🎉 Все файлы созданы и отправлены в GitHub! Зайди во вкладку Actions в своём репозитории и скачай готовый APK."
