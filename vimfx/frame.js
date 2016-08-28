let {utils: Cu} = Components;
let {
    isEditableInput,
    insertAtCursor,
    killBackwardFromCursor,
    cleanTagName,
} = Cu.import(`${__dirname}/shared.js`, {});

let findActiveElement = (document) => {
    let inner = (document) => {
        let active = document.activeElement;
        if (active) {
            let tag = cleanTagName(active);
            if (tag == "iframe") {
                return inner(active.contentDocument);
            }
            else {
                return active;
            }
        }
    };
    return inner(document);
};

vimfx.listen('paste', (text, cb) => {
    let active = findActiveElement(content.document);
    if (active && isEditableInput(active)) {
        insertAtCursor(active, text);
    }
});

vimfx.listen('kill_backward', (data, cb) => {
    let active = findActiveElement(content.document);
    if (active && isEditableInput(active)) {
        killBackwardFromCursor(active);
    }
});

sendAsyncMessage('VimFx-config:tabCreated');
