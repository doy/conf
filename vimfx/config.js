let {commands} = vimfx.modes.normal;

const {classes: Cc, interfaces: Ci, utils: Cu} = Components;
const mm = Cc['@mozilla.org/globalmessagemanager;1']
    .getService(Ci.nsIMessageListenerManager);

vimfx.set('mode.normal.copy_current_url', 'y');
vimfx.set('mode.normal.history_back', '<C-h>');
vimfx.set('mode.normal.history_forward', '<C-l>');
vimfx.set('mode.normal.stop', '<C-c>');

vimfx.set('mode.normal.scroll_half_page_down', 'J');
vimfx.set('mode.normal.scroll_half_page_up', 'K');
vimfx.set('mode.normal.scroll_to_left', '0 ) _');
vimfx.set('mode.normal.scroll_to_mark', '\'');

vimfx.set('mode.normal.tab_new_after_current', '');
vimfx.set('mode.normal.tab_select_previous', 'H');
vimfx.set('mode.normal.tab_select_next', 'L');
vimfx.set('mode.normal.tab_close', 'd');
vimfx.set('mode.normal.tab_restore', 'u');

vimfx.set('mode.normal.enter_mode_ignore', '<C-v>');
vimfx.set('mode.normal.dev', ': ,');

vimfx.set('notify_entered_keys', true);
vimfx.set('scroll.last_position_mark', '\'');

let new_tab_url = null;
(function () {
    let onTabCreated = ({target: browser}) => {
        console.log('called with ' + new_tab_url);
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
})
vimfx.set('custom.mode.normal.goto_tab', 'b');

vimfx.addCommand({
    name: 'pocket',
    description: 'Save to Pocket',
}, ({vim}) => {
    vim.window.document.getElementById('pocket-button').click();
})
vimfx.set('custom.mode.normal.pocket', 's');

let {Preferences} = Cu.import('resource://gre/modules/Preferences.jsm', {});
Preferences.set({
    'devtools.chrome.enabled': true,
    'privacy.donottrackheader.enabled': true,
    'toolkit.scrollbox.verticalScrollDistance': 1,
})
