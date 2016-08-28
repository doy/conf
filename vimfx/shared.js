const EXPORTED_SYMBOLS = [
    'isEditableInput',
    'insertAtCursor',
    'killBackwardFromCursor',
];

function isEditableInput(e) {
    let tag = e.tagName.split(':').pop().toLowerCase();
    // XXX
    return tag == "input" || tag == "textarea";
}

function insertAtCursor(e, text) {
    text = text || "";
    var before = e.value.substring(0, e.selectionStart);
    var after = e.value.substring(e.selectionEnd, e.value.length);
    e.value = before + text + after;
    e.selectionStart = e.selectionEnd = before.length + text.length;
}

function killBackwardFromCursor(e) {
    var before = e.value.substring(0, e.selectionStart);
    var start = before.lastIndexOf('\n') + 1;
    before = before.substring(0, start);
    var after = e.value.substring(e.selectionEnd, e.value.length);
    e.value = before + after;
    e.selectionStart = e.selectionEnd = start;
}
