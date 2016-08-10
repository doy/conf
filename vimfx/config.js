let {commands} = vimfx.modes.normal;

const {classes: Cc, interfaces: Ci, utils: Cu} = Components;
const mm = Cc['@mozilla.org/globalmessagemanager;1']
    .getService(Ci.nsIMessageListenerManager);

vimfx.set('mode.normal.focus_search_bar', '');
vimfx.set('mode.normal.copy_current_url', 'y');
vimfx.set('mode.normal.history_back', '<force><C-h>');
vimfx.set('mode.normal.history_forward', '<force><C-l>');
vimfx.set('mode.normal.stop', '<force><C-c>');

vimfx.set('mode.normal.scroll_half_page_down', 'J');
vimfx.set('mode.normal.scroll_half_page_up', 'K');
vimfx.set('mode.normal.scroll_to_left', '0 ) _');
vimfx.set('mode.normal.scroll_to_mark', '\'');

vimfx.set('mode.normal.tab_new_after_current', '');
vimfx.set('mode.normal.tab_select_previous', 'H');
vimfx.set('mode.normal.tab_select_next', 'L');
vimfx.set('mode.normal.tab_close', 'd');
vimfx.set('mode.normal.tab_restore', 'u');

vimfx.set('mode.normal.quote', '<force><C-v>');
vimfx.set('mode.normal.enter_mode_ignore', '<force><C-z>');
vimfx.set('mode.normal.dev', ': ,');

vimfx.set('notify_entered_keys', true);
vimfx.set('scroll.last_position_mark', '\'');

let new_tab_url = null;
(function () {
    let onTabCreated = ({target: browser}) => {
        if (new_tab_url) {
            browser.ownerGlobal.gURLBar.value = new_tab_url;
            new_tab_url = null;
        }
    };
    mm.addMessageListener('VimFx-config:tabCreated', onTabCreated);
    vimfx.on('shutdown', () => {
        mm.removeMessageListener('VimFx-config:tabCreated', onTabCreated);
    });

    vimfx.addCommand({
        name: 'tab_new_with_url',
        description: 'New tab with URL',
        category: 'tabs',
        order: commands.tab_new_after_current.order + 1,
    }, (args) => {
        new_tab_url = args.vim.browser.currentURI.spec;
        commands.tab_new.run(args);
    });
    vimfx.set('custom.mode.normal.tab_new_with_url', 'T');
})();

vimfx.addCommand({
    name: 'tab_groups',
    description: 'Toggle tab groups',
    category: 'tabs',
}, ({vim}) => {
    vim.window.tabGroups.TabView.toggle();
});
vimfx.set('custom.mode.normal.tab_groups', '<BS>');

vimfx.addCommand({
    name: 'goto_tab',
    description: 'Goto tab',
    category: 'tabs',
}, (args) => {
    commands.focus_location_bar.run(args);
    args.vim.window.gURLBar.value = '% ';
});
vimfx.set('custom.mode.normal.goto_tab', 'b');

vimfx.addCommand({
    name: 'pocket',
    description: 'Save to Pocket',
}, ({vim}) => {
    vim.window.document.getElementById('pocket-button').click();
});
vimfx.set('custom.mode.normal.pocket', 's');

vimfx.addCommand({
    name: 'focus_unhighlighted_location_bar',
    description: 'Focus the location bar with the URL unhighlighted',
    category: 'location',
    order: commands.focus_location_bar.order + 1,
}, (args) => {
    commands.focus_location_bar.run(args);
    let active = args.vim.window.document.activeElement;
    active.selectionStart = active.selectionEnd;
});
vimfx.set('custom.mode.normal.focus_unhighlighted_location_bar', 'O');

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
let killBackwardFromCursor = (e) => {
    var before = e.value.substring(0, e.selectionStart);
    var start = before.lastIndexOf('\n') + 1;
    before = before.substring(0, start);
    var after = e.value.substring(e.selectionEnd, e.value.length);
    e.value = before + after;
    e.selectionStart = e.selectionEnd = start;
};

vimfx.addCommand({
    name: 'paste',
    description: 'paste',
}, ({vim}) => {
    let text = vim.window.readFromClipboard();
    let active = vim.window.document.activeElement;
    if (active && isEditableInput(active)) {
        insertAtCursor(active, text);
    }
    else {
        vimfx.send(vim, 'paste', text, null);
    }
});
vimfx.set('custom.mode.normal.paste', '<force><s-insert>');

vimfx.addCommand({
    name: 'kill_backward',
    description: 'delete line backward',
}, ({vim}) => {
    let active = vim.window.document.activeElement;
    if (active && isEditableInput(active)) {
        killBackwardFromCursor(active);
    }
    else {
        vimfx.send(vim, 'kill_backward', null, null);
    }
});
vimfx.set('custom.mode.normal.kill_backward', '<force><C-u>');

let {Preferences} = Cu.import('resource://gre/modules/Preferences.jsm', {});
Preferences.set({
    'accessibility.typeaheadfind.enablesound': false,
    'devtools.chrome.enabled': true,
    'privacy.donottrackheader.enabled': true,
    'toolkit.scrollbox.verticalScrollDistance': 1,
});
