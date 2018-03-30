function updateNoteList() {
    var lastIdx = noteListView.currentIndex;
    if (lastIdx<0) lastIdx =0;

    window.fetch('get-notes-list')
    .then(function(data){
        noteListModel.clear()
        for (var k in data) {
            noteListModel.append(data[k]);
        }


        if (noteListView.currentIndex<0) noteListView.currentIndex = lastIdx;
        if (lastIdx == noteListView.currentIndex) {
            getNoteText(data[noteListView.currentIndex].id);
        }

    });

}

function getNoteText(id) {
    window.fetch('get-note', id)
    .then(function(data){
        noteText.text = data.body
        noteText.noteColor = data.color
        noteText.noteId = data.id

        window.toolSaveButton.enabled = true
        window.toolDeleteButton.enabled = true
    });
}

function newNote() {
    noteListView.currentIndex = -1
    noteText.text = "";
    noteText.noteColor = "#cc0000";
    noteText.noteId = -1;
    noteText.focus = true

    window.toolSaveButton.enabled = true
    window.toolDeleteButton.enabled = false
}

function saveNote() {
    if (noteText.noteId<0) {
        createNote();
    } else {
        updateNote();
    }
}

function createNote(){
    var postdata = {
        color: noteText.noteColor,
        body: noteText.text
    };

    window.fetch("create-note", undefined, "post", postdata).then(updateNoteList);
}

function updateNote() {
    var postdata = {
        color: noteText.noteColor,
        body: noteText.text
    };

    window.fetch("update-note", noteText.noteId, "post", postdata).then(updateNoteList);

}

function deleteNote() {
    window.fetch("delete-note", noteText.noteId).then(updateNoteList);
}
