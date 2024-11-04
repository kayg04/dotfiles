import {
  duoLayer,
  hyperLayer,
  ifVar,
  layer,
  map,
  modifierLayer,
  NumberKeyValue,
  rule,
  simlayer,
  toApp,
  withMapper,
  withModifier,
  writeToProfile,
} from 'karabiner.ts'

writeToProfile('kayg-primary', [
  navigationLayer(),
  applicationLayer(),
  numberLayer(),
  raycastLayer(),
  symbolLayer(),
  windowLayoutLayer(),
  windowManagementLayer(),
  essentialModifiers(),
  qwertyToColemakDH(),
])

/* I am using Colemak-DH MATRIX on MacOS so apart from the navigation layer, everything else might seem odd.
That's because Karabiner Elements recognizes keycodes from the physical keyboard and then they go to MacOS.
That means that the keys' physical location matters. If I want colemak DH specific keys then I need to use the
key on the physical keyboard that corresponds to COLEMAK DH on QWERTY. Here's a map:
 
  a → a
  b → t
  c → c
  d → s
  e → f
  f → b
  ...

Here's QWERTY: https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Apple_Magic_Keyboard_-_US_remix_transparent.png/1394px-Apple_Magic_Keyboard_-_US_remix_transparent.png
Here's Colemak DH: https://colemakmods.github.io/mod-dh/gfx/about/colemak_dh_main_matrix.png
*/

function applicationLayer() {
  return hyperLayer('a')
    .description('Application layer')
    .notification()
    .manipulators([
      map('t').toApp("Arc"),
      map('e').toApp("Finder"),
      map('l').toApp("Iterm"),
      map('h').toApp("Mail"),
      map('d').toApp("Spotify"),
      map('b').toApp("Visual studio code"),
      map('f').toApp("Telegram"),
    ])
}

function essentialModifiers() {
  return rule('Essential Modifiers').manipulators([

    // 
    // Tab → Meh                                                         ] → Meh
    // Caps → Hyper                                                      " → Hyper
    //                                                                   / → Left Control
    //            Left ⌘ → Esc                     Right ⌘ → Left Option

    // left hand
    map('tab').toMeh().toIfAlone('tab'),
    map('caps_lock').toHyper().toIfAlone('escape'),
    map('left_command').to('left_command').toIfAlone('escape'),

    // right hand
    map('right_command').to('left_option').toIfAlone('delete_or_backspace'),
    map('slash').to('left_control').toIfAlone('slash'),
    map('quote').toHyper().toIfAlone('quote'),
    map(']').toMeh().toIfAlone(']'),
  ])
}

function navigationLayer() {
  return hyperLayer('spacebar')
    .description('Navigation Layer')
    .notification()
    .manipulators([
      // left half of the keyboard //
      // first row //
      map('q').to$('open -g raycast://extensions/abielzulio/chatgpt/ask'),
      map('w').to$('open -g raycast://extensions/raycast/navigation/switch-windows'),
      map('e').to$('open -g raycast://extensions/raycast/file-search/search-files'),

      // second row // 
      map('a').to$('open -g raycast://extensions/the-browser-company/arc/search'),
      map('f').to$('open -g raycast://extensions/raycast/navigation/search-menu-items'),
      map('g').to$('open -g raycast://extensions/josephschmitt/gif-search/search'),
      
      // bottom row
      map('c').to$('open -g raycast://extensions/thomas/visual-studio-code/index'),
      map('b').to$('open -g raycast://extensions/tonka3000/youtube/search-videos'), 

      // -- right half of the keyboard -- //
      // arrow keys, inspired by Max Stoiber and vim
      map('h').to('left_arrow'),
      map('j').to('down_arrow'),
      map('k').to('up_arrow'),
      map('l').to('right_arrow'),
      map(';').to('delete_or_backspace'),

      // move left by one word
      map('n').to('left_arrow', 'left_option'),
      // move to the beginning and end of the document
      map('m').to('up_arrow', 'left_command'),
      map(',').to('down_arrow', 'left_command'),
      // move right by one word
      map('.').to('right_arrow', 'left_option'),

      // move to the beginning / end of the line
      map('y').to('left_arrow', 'left_command'),
      map('u').to('down_arrow', 'fn'),
      map('i').to('up_arrow', 'fn'),
      map('o').to('right_arrow', 'left_command'),
    ])
}

function numberLayer() {
  return hyperLayer('j')
  .description('Number Pad Layer')
  .notification()
  .manipulators([
    // implement numpad on the left hand side
    // [ 7 8 9 ]
    // ; 4 5 6 =
    // 0 1 2 3 \
    map('q').to('-'),
    map('w').to('7'),
    map('e').to('8'),
    map('r').to('9'),
    map('a').to('='),
    map('s').to('4'),
    map('d').to('5'),
    map('f').to('6'),
    map('z').to('0'),
    map('x').to('1'),
    map('c').to('2'),
    map('v').to('3'),
  ])
}

function raycastLayer() {
  return hyperLayer('q')
    .description('Raycast Layer')
    .notification()
    .manipulators([
      map(';').to$('open raycast://extensions/benvp/audio-device/set-output-device'),
      map('l').to$('open raycast://extensions/benvp/audio-device/set-input-device'),
      map('r').to$('open raycast://extensions/raycast/typing-practice/start-typing-practice'),
    ])
}

function qwertyToColemakDH() {
  return rule('Colemak DH').manipulators([
    withModifier('optionalAny')([
      // top row
      map('q').to('q'),
      map('w').to('w'),
      map('e').to('f'),
      map('r').to('p'),
      map('t').to('b'),
      map('y').to('j'),
      map('u').to('l'),
      map('i').to('u'),
      map('o').to('y'),
      map('p').to(';'),
      // middle row
      map('a').to('a'),
      map('s').to('r'),
      map('d').to('s'),
      map('f').to('t'),
      map('g').to('g'),
      map('h').to('m'),
      map('j').to('n'),
      map('k').to('e'),
      map('l').to('i'),
      map(';').to('o'),
      // bottom row
      map('z').to('z'),
      map('x').to('x'),
      map('c').to('c'),
      map('v').to('d'),
      map('b').to('v'),
      map('n').to('k'),
      map('m').to('h'),
    ]),
  ])
}

function symbolLayer() {
  return hyperLayer('d')
    .description('Symbol Layer')
    .notification()
    .manipulators([
      // implement numpad on the left hand side
      // [ 7 8 9 ]
      map('q').to('-'),
      map('w').to('7'),
      map('e').to('8'),
      map('r').to('9'),
      //  ; 4 5 6 =
      map('a').to('='),
      map('s').to('4'),
      map('d').to('5'),
      map('f').to('6'),
      // ` 0 1 2 3 \
      map('z').to('0'),
      map('x').to('1'),
      map('c').to('2'),
      map('v').to('3'),
    ])
}

function functionKeyLayer() {
    return hyperLayer('e')
    .notification()
    .description('Function Key Layer')
    .manipulators([
      // Top 30%
    ])
}

function windowManagementLayer() {
  return hyperLayer('w')
    .notification()
    .description('Window Management Layer')
    .manipulators([
      // Top 30%
      map('y').to$("open -g 'btt://trigger_named/?trigger_name=Move/Resize: Top Major Left'"),
      map('p').to$("open -g 'btt://trigger_named/?trigger_name=Move/Resize: Top Major Right'"),
      // Bottom 70%
      map('h').to$("open -g 'btt://trigger_named/?trigger_name=Move/Resize: Major Left'"),
      map('j').to$("open -g 'btt://trigger_named/?trigger_name=Move/Resize: Minor Left'"),
      map('k').to$("open -g 'btt://trigger_named/?trigger_name=Move/Resize: Major Center'"),
      map('l').to$("open -g 'btt://trigger_named/?trigger_name=Move/Resize: Minor Right'"),
      map(';').to$("open -g 'btt://trigger_named/?trigger_name=Move/Resize: Major Right'"),
    ])
}