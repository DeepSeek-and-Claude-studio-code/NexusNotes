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
