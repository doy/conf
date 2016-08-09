// XXX need to figure out how to not need these helper functions to be
// duplicated
let isEditableInput = (e) => {
    let tag = e.tagName.split(':').pop().toLowerCase();
    // XXX
    return tag == "input" || tag == "textarea";
};
let insertAtCursor = (e, text) => {
    text = text || "";
    var before = e.value.substring(0, e.selectionStart);
    var after = e.value.substring(e.selectionEnd, e.value.length);
    e.value = before + text + after;
    e.selectionStart = e.selectionEnd = before.length + text.length;
};
vimfx.listen('paste', (text, cb) => {
    let active = content.document.activeElement;
    if (active && isEditableInput(active)) {
        insertAtCursor(active, text);
    }
})

sendAsyncMessage('VimFx-config:tabCreated');
