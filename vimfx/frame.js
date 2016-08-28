let {utils: Cu} = Components;
let {
    isEditableInput,
    insertAtCursor,
    killBackwardFromCursor,
} = Cu.import(`${__dirname}/shared.js`, {});

vimfx.listen('paste', (text, cb) => {
    let active = content.document.activeElement;
    if (active && isEditableInput(active)) {
        insertAtCursor(active, text);
    }
});

vimfx.listen('kill_backward', (data, cb) => {
    let active = content.document.activeElement;
    if (active && isEditableInput(active)) {
        killBackwardFromCursor(active);
    }
});

sendAsyncMessage('VimFx-config:tabCreated');
