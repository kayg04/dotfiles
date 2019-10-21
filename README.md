
# Table of Contents

1.  [Bootstrap](#orgaae43b6)
2.  [Awesome](#org0838f74)
    1.  [rc.lua](#orgaae6cde)
    2.  [Themes](#org3740bf4)
        1.  [Default](#org2276ef4)
3.  [Autostart](#org6e4a981)
    1.  [Scripts](#orgecefd9a)
        1.  [SSH](#orgbf312a8)
4.  [Compton](#orgdddb412)
5.  [Desktop](#org4a652e4)
    1.  [Deezer](#orga584807)
    2.  [Invidious](#org5f6817b)
    3.  [Riot](#org496a5f5)
    4.  [Saavn](#orgc5cd2de)
    5.  [Slack](#org0dfb489)
    6.  [Wire](#org670f4da)
6.  [Emacs](#org6e6d9d6)
    1.  [Init](#org5982f90)
    2.  [Config](#org75373ea)
7.  [Firefox](#orgb06a74c)
    1.  [Profiles](#orgc2462ee)
    2.  [Policies](#org46b2595)
    3.  [UserJS](#org6adcc70)
        1.  [General](#orgd697f5b)
        2.  [Themes](#org9e6565a)
    4.  [Setup](#org472dff4)
8.  [Plasma](#org29156cf)
    1.  [Environment](#org9748b84)
    2.  [PAM](#org768007f)
9.  [Systemd](#org88cbb65)
    1.  [SSH Agent](#orgf3c98e6)
10. [Thunderbird](#orgf45f83c)
    1.  [Profiles](#org8cafccd)
11. [Ungoogled Chromium](#orge07ece5)
    1.  [Environment Variables](#org4cbf211)
    2.  [Flags](#org3909704)
12. [Utility](#org5f6d019)
    1.  [Ungoogled Chromium Extension Updater](#org28a28de)
    2.  [Virtual Desktop Bar (KDE)](#org1aed3d4)
    3.  [KWin Tiling Script (Faho)](#orgfb338b2)
    4.  [Wallpaper Index](#orgc912831)
13. [VSCodium](#org07014b2)
    1.  [Settings](#org4e0058c)
    2.  [Keybindings](#orgf780ebb)
14. [ZSH](#org96d3fad)
    1.  [Oh-my-zsh stuff](#org2dafbfb)
    2.  [Functions](#orge3fd1aa)
        1.  [Weather](#org2df05f8)
    3.  [Variables](#orgb5bab62)
    4.  [Aliases](#org20563bd)



<a id="orgaae43b6"></a>

# Bootstrap

    # import sanity
    set -euo pipefail
    
    # global declarations
    SCRIPT_PATH=$(dirname $(realpath "$0"))
    ZSH="${HOME}/.config/omz"
    ZSH_CUSTOM="${HOME}/.config/omz/custom"
    
    update() {
        case "${1}" in
            "awesome")
                updateAwesomeWM
                ;;
            "compton")
                updateCompton
                ;;
            "desktop")
                updateDesktop
                ;;
            "doom"|"emacs")
                updateEmacs
                ;;
            "firefox")
                updateFirefox
                ;;
            "plasma")
                updatePlasma
                ;;
            "systemd")
                updateSystemd
                ;;
            "thunderbird")
                updateThunderbird
                ;;
            "chromium")
                updateChromium
                ;;
            "utilsh")
                updateUtilsh
                ;;
            "zsh")
                updateZSH
                ;;
        esac
    }
    
    updateAwesomeWM() {
        ln -sf "${SCRIPT_PATH}"/.config/awesome/*.lua "${HOME}"/.config/awesome/
        ln -sf "${SCRIPT_PATH}"/.config/awesome/themes/default/*.lua "${HOME}"/.config/awesome/themes/default/
    }
    
    updateCompton() {
        ln -sf "${SCRIPT_PATH}"/.config/compton/*.conf "${HOME}"/.config/compton/
    }
    
    updateDesktop() {
        ln -sf "${SCRIPT_PATH}"/.local/share/applications/*.desktop "${HOME}"/.local/share/applications/
    }
    
    updateEmacs() {
        ln -sf "${SCRIPT_PATH}"/.config/doom/* "${HOME}"/.config/doom/
        "${HOME}"/.emacs.d/bin/doom refresh
    }
    
    updateFirefox() {
        source "${SCRIPT_PATH}"/.mozilla/firefox/bootstrap.sh
    
        applyPolicies
        applyProfilesINI
        updateUserJS
        applyUserJS
        cleanUp
    }
    
    updatePlasma() {
        ln -sf "${SCRIPT_PATH}"/.config/autostart-scripts/*.sh "${HOME}"/.config/autostart-scripts/
        ln -sf "${SCRIPT_PATH}"/.config/plasma-workspace/env/*.sh "${HOME}"/.config/plasma-workspace/env/
        ln -sf "${SCRIPT_PATH}"/.pam_environment "${HOME}"/
    }
    
    updateSystemd() {
        ln -sf "${SCRIPT_PATH}"/.config/systemd/user/*.service "${HOME}"/.config/systemd/user/
    
        for service in $(ls -1 "${HOME}/.config/systemd/user" | cut -d '.' -f1); do
            systemctl --user enable --now "${service}"
        done
    }
    
    updateThunderbird() {
        ln -sf "${SCRIPT_PATH}"/.thunderbird/profiles.ini "${HOME}"/.thunderbird/
    }
    
    updateVSCodium() {
        ln -sf "${SCRIPT_PATH}"/.config/VSCodium/User/*.json "${HOME}"/.config/VSCodium/User/
    }
    
    updateChromium() {
        ln -sf "${SCRIPT_PATH}"/.config/chromium-flags.conf "${HOME}"/.config/
    }
    
    updateUtilsh() {
        ln -sf "${SCRIPT_PATH}"/.local/bin/* "${HOME}"/.local/bin/
    }
    
    updateZSH() {
        if [[ ! -d "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting ]]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
        fi
    
        if [[ ! -d "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions ]]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
        fi
    
        ln -sf "${SCRIPT_PATH}"/.zshrc "${HOME}"/
    }
    
    setup() {
        case "${1}" in
            "awesome")
                setupAwesomeWM
                ;;
            "compton")
                setupCompton
                ;;
            "desktop")
                setupDesktop
                ;;
            "doom"|"emacs")
                setupEmacs
                ;;
            "firefox")
                setupFirefox
                ;;
            "plasma")
                setupPlasma
                ;;
            "systemd")
                setupSystemd
                ;;
            "thunderbird")
                setupThunderbird
                ;;
            "chromium")
                setupChromium
                ;;
            "utilsh")
                setupUtilsh
                ;;
            "zsh")
                setupZSH
                ;;
        esac
    }
    
    setupAwesomeWM() {
        mkdir -p "${HOME}"/.config/awesome
        mkdir -p "${HOME}"/.config/awesome/themes/default
        updateAwesomeWM
    }
    
    setupCompton() {
        mkdir -p "${HOME}"/.config/compton
        updateCompton
    }
    
    setupDesktop() {
        mkdir -p "${HOME}"/.local/share/applications
        updateDesktop
    }
    
    setupEmacs() {
        echo -e "Creating doom emacs directory..."
        if mkdir -p "${HOME}"/.config/doom; then
            printf '\u2714\n'
        else
            printf '\u274c\n'
        fi
    
        echo -ne "Cloning doom emacs source..."
        if git clone https://github.com/hlissner/doom-emacs ~/.emacs.d; then
            printf '\u2714\n'
        else
            printf '\u274c\n'
        fi
    
        echo -e "Unleashing doom..."
        "${HOME}"/.emacs.d/bin/doom install
    
        updateEmacs
    }
    
    setupFirefox() {
        source "${SCRIPT_PATH}"/.mozilla/firefox/bootstrap.sh
    
        applyPolicies
        createProfilesINIDir
        applyProfilesINI
        createProfiles
        updateUserJS
        applyUserJS
        cleanUp
        startFirefox
    }
    
    setupPlasma() {
        updatePlasma
    }
    
    setupSystemd() {
        mkdir -p "${HOME}/.config/systemd/user"
    }
    
    setupThunderbird() {
        mkdir -p "${HOME}"/.config/thunderbird/primary
        updateThunderbird
    }
    
    setupVSCodium() {
        updateVSCodium
    }
    
    setupChromium() {
        updateChromium
    }
    
    setupUtilsh() {
        updateUtilsh
    }
    
    setupZSH() {
        if [[ ! upgrade_oh_my_zsh || ! -d "${HOME}/.oh-my-zsh" ]]; then
            export ZSH="${HOME}/.config/omz"
            sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        else
            exit 1
        fi
    }
    
    addToPath() {
        echo -e "Adding this program to \$PATH so that it is globally available."
        mkdir -p "${HOME}"/.local/bin
        ln -sf "${SCRIPT_PATH}"/dot "${HOME}"/.local/bin/
    }
    
    refresh() {
        git --git-dir="${SCRIPT_PATH}/.git" --work-tree="${SCRIPT_PATH}" pull
    }
    
    main() {
        case "${1}" in
            "setup")
                setup "${2}"
                ;;
            "update")
                update "${2}"
                ;;
            "set")
                addToPath
                ;;
            "refresh")
                refresh
                ;;
            *)
                echo -e "Invalid option."
                ;;
        esac
    }
    
    main "${@}"


<a id="org0838f74"></a>

# Awesome


<a id="orgaae6cde"></a>

## rc.lua

    -- If LuaRocks is installed, make sure that packages installed through it are
    -- found (e.g. lgi). If LuaRocks is not installed, do nothing.
    pcall(require, "luarocks.loader")
    
    -- Standard awesome library
    local gears = require("gears")
    local awful = require("awful")
    require("awful.autofocus")
    -- Widget and layout library
    local wibox = require("wibox")
    -- Theme handling library
    local beautiful = require("beautiful")
    -- Notification library
    local naughty = require("naughty")
    local menubar = require("menubar")
    local hotkeys_popup = require("awful.hotkeys_popup")
    -- Enable hotkeys help widget for VIM and other apps
    -- when client with a matching name is opened:
    require("awful.hotkeys_popup.keys")
    
    -- {{{ Error handling
    -- Check if awesome encountered an error during startup and fell back to
    -- another config (This code will only ever execute for the fallback config)
    if awesome.startup_errors then
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, there were errors during startup!",
                         text = awesome.startup_errors })
    end
    
    -- Handle runtime errors after startup
    do
        local in_error = false
        awesome.connect_signal("debug::error", function (err)
            -- Make sure we don't go into an endless error loop
            if in_error then return end
            in_error = true
    
            naughty.notify({ preset = naughty.config.presets.critical,
                             title = "Oops, an error happened!",
                             text = tostring(err) })
            in_error = false
        end)
    end
    -- }}}
    
    -- {{{ Variable definitions
    -- Themes define colours, icons, font and wallpapers.
    beautiful.init("/home/kayg/.config/awesome/themes/default/theme.lua")
    
    -- This is used later as the default terminal and editor to run.
    terminal = "xterm"
    editor = os.getenv("EDITOR") or "nano"
    editor_cmd = terminal .. " -e " .. editor
    
    -- Default modkey.
    -- Usually, Mod4 is the key with a logo between Control and Alt.
    -- If you do not like this or do not have such a key,
    -- I suggest you to remap Mod4 to another key using xmodmap or other tools.
    -- However, you can use another modifier like Mod1, but it may interact with others.
    modkey = "Mod4"
    
    -- Table of layouts to cover with awful.layout.inc, order matters.
    awful.layout.layouts = {
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier,
        awful.layout.suit.corner.nw,
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,
    }
    -- }}}
    
    -- {{{ Menu
    -- Create a launcher widget and a main menu
    myawesomemenu = {
       { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
       { "manual", terminal .. " -e man awesome" },
       { "edit config", editor_cmd .. " " .. awesome.conffile },
       { "restart", awesome.restart },
       { "quit", function() awesome.quit() end },
    }
    
    mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "open terminal", terminal }
                                      }
                            })
    
    mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                         menu = mymainmenu })
    
    -- Menubar configuration
    menubar.utils.terminal = terminal -- Set the terminal for applications that require it
    -- }}}
    
    -- Keyboard map indicator and switcher
    mykeyboardlayout = awful.widget.keyboardlayout()
    
    -- {{{ Wibar
    -- Create a textclock widget
    mytextclock = wibox.widget.textclock()
    
    -- Create a wibox for each screen and add it
    local taglist_buttons = gears.table.join(
                        awful.button({ }, 1, function(t) t:view_only() end),
                        awful.button({ modkey }, 1, function(t)
                                                  if client.focus then
                                                      client.focus:move_to_tag(t)
                                                  end
                                              end),
                        awful.button({ }, 3, awful.tag.viewtoggle),
                        awful.button({ modkey }, 3, function(t)
                                                  if client.focus then
                                                      client.focus:toggle_tag(t)
                                                  end
                                              end),
                        awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                        awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                    )
    
    local tasklist_buttons = gears.table.join(
                         awful.button({ }, 1, function (c)
                                                  if c == client.focus then
                                                      c.minimized = true
                                                  else
                                                      c:emit_signal(
                                                          "request::activate",
                                                          "tasklist",
                                                          {raise = true}
                                                      )
                                                  end
                                              end),
                         awful.button({ }, 3, function()
                                                  awful.menu.client_list({ theme = { width = 250 } })
                                              end),
                         awful.button({ }, 4, function ()
                                                  awful.client.focus.byidx(1)
                                              end),
                         awful.button({ }, 5, function ()
                                                  awful.client.focus.byidx(-1)
                                              end))
    
    local function set_wallpaper(s)
        -- Wallpaper
        if beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper
            -- If wallpaper is a function, call it with the screen
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end
    
    -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
    screen.connect_signal("property::geometry", set_wallpaper)
    
    awful.screen.connect_for_each_screen(function(s)
        -- Wallpaper
        set_wallpaper(s)
    
        -- Each screen has its own tag table.
        awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    
        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()
        -- Create an imagebox widget which will contain an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(gears.table.join(
                               awful.button({ }, 1, function () awful.layout.inc( 1) end),
                               awful.button({ }, 3, function () awful.layout.inc(-1) end),
                               awful.button({ }, 4, function () awful.layout.inc( 1) end),
                               awful.button({ }, 5, function () awful.layout.inc(-1) end)))
        -- Create a taglist widget
        s.mytaglist = awful.widget.taglist {
            screen  = s,
            filter  = awful.widget.taglist.filter.all,
            buttons = taglist_buttons
        }
    
        -- Create a tasklist widget
        s.mytasklist = awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons
        }
    
        -- Create the wibox
        s.mywibox = awful.wibar({ position = "top", screen = s })
    
        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                mykeyboardlayout,
                wibox.widget.systray(),
                mytextclock,
                s.mylayoutbox,
            },
        }
    end)
    -- }}}
    
    -- {{{ Mouse bindings
    root.buttons(gears.table.join(
        awful.button({ }, 3, function () mymainmenu:toggle() end),
        awful.button({ }, 4, awful.tag.viewnext),
        awful.button({ }, 5, awful.tag.viewprev)
    ))
    -- }}}
    
    -- {{{ Key bindings
    globalkeys = gears.table.join(
        awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
                  {description="show help", group="awesome"}),
        awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
                  {description = "view previous", group = "tag"}),
        awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
                  {description = "view next", group = "tag"}),
        awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
                  {description = "go back", group = "tag"}),
    
        awful.key({ modkey,           }, "j",
            function ()
                awful.client.focus.byidx( 1)
            end,
            {description = "focus next by index", group = "client"}
        ),
        awful.key({ modkey,           }, "k",
            function ()
                awful.client.focus.byidx(-1)
            end,
            {description = "focus previous by index", group = "client"}
        ),
        awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
                  {description = "show main menu", group = "awesome"}),
    
        -- Layout manipulation
        awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
                  {description = "swap with next client by index", group = "client"}),
        awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
                  {description = "swap with previous client by index", group = "client"}),
        awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
                  {description = "focus the next screen", group = "screen"}),
        awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
                  {description = "focus the previous screen", group = "screen"}),
        awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
                  {description = "jump to urgent client", group = "client"}),
        awful.key({ modkey,           }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
            {description = "go back", group = "client"}),
    
        -- Standard program
        awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
                  {description = "open a terminal", group = "launcher"}),
        awful.key({ modkey, "Control" }, "r", awesome.restart,
                  {description = "reload awesome", group = "awesome"}),
        awful.key({ modkey, "Shift"   }, "q", awesome.quit,
                  {description = "quit awesome", group = "awesome"}),
    
        awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
                  {description = "increase master width factor", group = "layout"}),
        awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
                  {description = "decrease master width factor", group = "layout"}),
        awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
                  {description = "increase the number of master clients", group = "layout"}),
        awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
                  {description = "decrease the number of master clients", group = "layout"}),
        awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
                  {description = "increase the number of columns", group = "layout"}),
        awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
                  {description = "decrease the number of columns", group = "layout"}),
        awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
                  {description = "select next", group = "layout"}),
        awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
                  {description = "select previous", group = "layout"}),
    
        awful.key({ modkey, "Control" }, "n",
                  function ()
                      local c = awful.client.restore()
                      -- Focus restored client
                      if c then
                        c:emit_signal(
                            "request::activate", "key.unminimize", {raise = true}
                        )
                      end
                  end,
                  {description = "restore minimized", group = "client"}),
    
        -- Prompt
        awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
                  {description = "run prompt", group = "launcher"}),
    
        awful.key({ modkey }, "x",
                  function ()
                      awful.prompt.run {
                        prompt       = "Run Lua code: ",
                        textbox      = awful.screen.focused().mypromptbox.widget,
                        exe_callback = awful.util.eval,
                        history_path = awful.util.get_cache_dir() .. "/history_eval"
                      }
                  end,
                  {description = "lua execute prompt", group = "awesome"}),
        -- Menubar
        awful.key({ modkey }, "p", function() menubar.show() end,
                  {description = "show the menubar", group = "launcher"})
    )
    
    clientkeys = gears.table.join(
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
                  {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                  {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                  {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                  {description = "move to screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                  {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"})
    )
    
    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it work on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, 9 do
        globalkeys = gears.table.join(globalkeys,
            -- View tag only.
            awful.key({ modkey }, "#" .. i + 9,
                      function ()
                            local screen = awful.screen.focused()
                            local tag = screen.tags[i]
                            if tag then
                               tag:view_only()
                            end
                      end,
                      {description = "view tag #"..i, group = "tag"}),
            -- Toggle tag display.
            awful.key({ modkey, "Control" }, "#" .. i + 9,
                      function ()
                          local screen = awful.screen.focused()
                          local tag = screen.tags[i]
                          if tag then
                             awful.tag.viewtoggle(tag)
                          end
                      end,
                      {description = "toggle tag #" .. i, group = "tag"}),
            -- Move client to tag.
            awful.key({ modkey, "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus then
                              local tag = client.focus.screen.tags[i]
                              if tag then
                                  client.focus:move_to_tag(tag)
                              end
                         end
                      end,
                      {description = "move focused client to tag #"..i, group = "tag"}),
            -- Toggle tag on focused client.
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus then
                              local tag = client.focus.screen.tags[i]
                              if tag then
                                  client.focus:toggle_tag(tag)
                              end
                          end
                      end,
                      {description = "toggle focused client on tag #" .. i, group = "tag"})
        )
    end
    
    clientbuttons = gears.table.join(
        awful.button({ }, 1, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end),
        awful.button({ modkey }, 1, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ modkey }, 3, function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )
    
    -- Set keys
    root.keys(globalkeys)
    -- }}}
    
    -- {{{ Rules
    -- Rules to apply to new clients (through the "manage" signal).
    awful.rules.rules = {
        -- All clients will match this rule.
        { rule = { },
          properties = { border_width = beautiful.border_width,
                         border_color = beautiful.border_normal,
                         focus = awful.client.focus.filter,
                         raise = true,
                         keys = clientkeys,
                         buttons = clientbuttons,
                         screen = awful.screen.preferred,
                         placement = awful.placement.no_overlap+awful.placement.no_offscreen
         }
        },
    
        -- Floating clients.
        { rule_any = {
            instance = {
              "DTA",  -- Firefox addon DownThemAll.
              "copyq",  -- Includes session name in class.
              "pinentry",
            },
            class = {
              "Arandr",
              "Blueman-manager",
              "Gpick",
              "Kruler",
              "MessageWin",  -- kalarm.
              "Sxiv",
              "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
              "Wpa_gui",
              "veromix",
              "xtightvncviewer"},
    
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
              "Event Tester",  -- xev.
            },
            role = {
              "AlarmWindow",  -- Thunderbird's calendar.
              "ConfigManager",  -- Thunderbird's about:config.
              "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
          }, properties = { floating = true }},
    
        -- Add titlebars to normal clients and dialogs
        { rule_any = {type = { "normal", "dialog" }
          }, properties = { titlebars_enabled = false }
        },
    
        -- Set Firefox to always map on the tag named "2" on screen 1.
        -- { rule = { class = "Firefox" },
        --   properties = { screen = 1, tag = "2" } },
    }
    -- }}}
    
    -- {{{ Signals
    -- Signal function to execute when a new client appears.
    client.connect_signal("manage", function (c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end
    
        if awesome.startup
          and not c.size_hints.user_position
          and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end)
    
    -- Add a titlebar if titlebars_enabled is set to true in the rules.
    client.connect_signal("request::titlebars", function(c)
        -- buttons for the titlebar
        local buttons = gears.table.join(
            awful.button({ }, 1, function()
                c:emit_signal("request::activate", "titlebar", {raise = true})
                awful.mouse.client.move(c)
            end),
            awful.button({ }, 3, function()
                c:emit_signal("request::activate", "titlebar", {raise = true})
                awful.mouse.client.resize(c)
            end)
        )
    
        awful.titlebar(c) : setup {
            { -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            { -- Middle
                { -- Title
                    align  = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout  = wibox.layout.flex.horizontal
            },
            { -- Right
                awful.titlebar.widget.floatingbutton (c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton   (c),
                awful.titlebar.widget.ontopbutton    (c),
                awful.titlebar.widget.closebutton    (c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end)
    
    -- Enable sloppy focus, so that focus follows mouse.
    client.connect_signal("mouse::enter", function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end)
    
    client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
    client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
    client.connect_signal("manage", function (c, startup) c.shape = function (cr, w, h) gears.shape.rounded_rect(cr,w,h,60)
                                                                    end
    end)
    -- }}}


<a id="org3740bf4"></a>

## Themes


<a id="org2276ef4"></a>

### Default

    ---------------------------
    -- Default awesome theme --
    ---------------------------
    
    local theme_assets = require("beautiful.theme_assets")
    local xresources = require("beautiful.xresources")
    local dpi = xresources.apply_dpi
    
    local gfs = require("gears.filesystem")
    local themes_path = gfs.get_themes_dir()
    
    local theme = {}
    
    theme.font          = "sans 8"
    
    theme.bg_normal     = "#222222"
    theme.bg_focus      = "#535d6c"
    theme.bg_urgent     = "#ff0000"
    theme.bg_minimize   = "#444444"
    theme.bg_systray    = theme.bg_normal
    
    theme.fg_normal     = "#aaaaaa"
    theme.fg_focus      = "#ffffff"
    theme.fg_urgent     = "#ffffff"
    theme.fg_minimize   = "#ffffff"
    
    theme.useless_gap   = dpi(20)
    theme.border_width  = dpi(0)
    theme.border_normal = "#000000"
    theme.border_focus  = "#535d6c"
    theme.border_marked = "#91231c"
    
    -- There are other variable sets
    -- overriding the default one when
    -- defined, the sets are:
    -- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
    -- tasklist_[bg|fg]_[focus|urgent]
    -- titlebar_[bg|fg]_[normal|focus]
    -- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
    -- mouse_finder_[color|timeout|animate_timeout|radius|factor]
    -- prompt_[fg|bg|fg_cursor|bg_cursor|font]
    -- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
    -- Example:
    --theme.taglist_bg_focus = "#ff0000"
    
    -- Generate taglist squares:
    local taglist_square_size = dpi(4)
    theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
        taglist_square_size, theme.fg_normal
    )
    theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
        taglist_square_size, theme.fg_normal
    )
    
    -- Variables set for theming notifications:
    -- notification_font
    -- notification_[bg|fg]
    -- notification_[width|height|margin]
    -- notification_[border_color|border_width|shape|opacity]
    
    -- Variables set for theming the menu:
    -- menu_[bg|fg]_[normal|focus]
    -- menu_[border_color|border_width]
    theme.menu_submenu_icon = themes_path.."default/submenu.png"
    theme.menu_height = dpi(15)
    theme.menu_width  = dpi(100)
    
    -- You can add as many variables as
    -- you wish and access them by using
    -- beautiful.variable in your rc.lua
    --theme.bg_widget = "#cc0000"
    
    -- Define the image to load
    theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
    theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"
    
    theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
    theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"
    
    theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
    theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
    theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
    theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"
    
    theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
    theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
    theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
    theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"
    
    theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
    theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
    theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
    theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"
    
    theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
    theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
    theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
    theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"
    
    theme.wallpaper = "./background.png"
    
    -- You can use your own layout icons like this:
    theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
    theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
    theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
    theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
    theme.layout_max = themes_path.."default/layouts/maxw.png"
    theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
    theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
    theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
    theme.layout_tile = themes_path.."default/layouts/tilew.png"
    theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
    theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
    theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
    theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
    theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
    theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
    theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"
    
    -- Generate Awesome icon:
    theme.awesome_icon = theme_assets.awesome_icon(
        theme.menu_height, theme.bg_focus, theme.fg_focus
    )
    
    -- Define the icon theme for application icons. If not set then the icons
    -- from /usr/share/icons and /usr/share/icons/hicolor will be used.
    theme.icon_theme = nil
    
    return theme
    
    -- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80


<a id="org6e4a981"></a>

# Autostart


<a id="orgecefd9a"></a>

## Scripts


<a id="orgbf312a8"></a>

### SSH

    # Enable extended globbing
    shopt -s extglob dotglob nullglob
    
    # Add all files in $HOME/.ssh/keys that do not end
    # with .pub
    ssh-add "${HOME}"/.ssh/keys/!(*.pub) </dev/null


<a id="orgdddb412"></a>

# Compton

    # Shadow
    shadow = true;
    no-dnd-shadow = true;
    no-dock-shadow = true;
    clear-shadow = true;
    shadow-radius = 10;
    shadow-offset-x = -1;
    shadow-offset-y = -1;
    shadow-opacity = 0.4;
    # shadow-red = 0.0;
    # shadow-green = 0.0;
    # shadow-blue = 0.0;
    shadow-exclude = [
        "name = 'Notification'",
        "class_g = 'Conky'",
        "class_g ?= 'Notify-osd'",
        "class_g = 'Cairo-clock'",
        "_GTK_FRAME_EXTENTS@:c",
        "bounding_shaped"
    ];
    # shadow-exclude = "n:e:Notification";
    # shadow-exclude-reg = "x10+0+0";
    # xinerama-shadow-crop = true;
    
    # Opacity
    menu-opacity = 0.8;
    inactive-opacity = 0.8;
    # active-opacity = 0.8;
    frame-opacity = 1.0;
    inactive-opacity-override = false;
    alpha-step = 0.06;
    # inactive-dim = 0.2;
    # inactive-dim-fixed = true;
    blur-background = true;
    blur-background-frame = true;
    blur-method = "kawase";
    blur-strength = 7;
    blur-kern = "7x7box";
    # blur-kern = "5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1";
    # blur-background-fixed = true;
    blur-background-exclude = [
        "window_type = 'dock'",
        "window_type = 'desktop'",
        "_GTK_FRAME_EXTENTS@:c"
    ];
    # opacity-rule = [ "80:class_g = 'URxvt'" ];
    
    # Fading
    fading = true;
    # fade-delta = 30;
    fade-in-step = 0.05;
    fade-out-step = 0.05;
    # no-fading-openclose = true;
    # no-fading-destroyed-argb = true;
    fade-exclude = [ ];
    
    # Other
    backend = "glx";
    mark-wmwin-focused = true;
    mark-ovredir-focused = true;
    use-ewmh-active-win = true;
    detect-rounded-corners = true;
    detect-client-opacity = true;
    refresh-rate = 60;
    vsync = "opengl-swc";
    dbe = false;
    paint-on-overlay = true;
    sw-opti = true;
    unredir-if-possible = true;
    # unredir-if-possible-delay = 5000;
    # unredir-if-possible-exclude = [ ];
    focus-exclude = [ "class_g = 'Cairo-clock'" ];
    detect-transient = true;
    detect-client-leader = true;
    invert-color-include = [ ];
    # resize-damage = 1;
    
    # GLX backend
    # glx-no-stencil = true;
    # glx-copy-from-front = false;
    # glx-use-copysubbuffermesa = true;
    # glx-no-rebind-pixmap = true;
    glx-swap-method = "undefined";
    # glx-use-gpushader4 = true;
    # xrender-sync = true;
    # xrender-sync-fence = true;
    
    # Window type settings
    wintypes:
    {
      tooltip = { fade = true; shadow = true; opacity = 0.75; focus = true; };
    };
    
    # Transitions
    transition-length = 150;


<a id="org4a652e4"></a>

# Desktop


<a id="orga584807"></a>

## Deezer

    [Desktop Entry]
    Name=Deezer
    StartupNotify=true
    Icon=/home/kayg/Pictures/Icons/deezer.svg
    Comment=Deezer audio streaming service
    Exec=chromium --user-data-dir=${HOME}/.config/chromium/Apps --app=https://www.deezer.com/
    Terminal=false
    Type=Application
    MimeType=x-scheme-handler/deezer;
    StartupWMClass=deezer
    Categories=Audio;Music;Player;AudioVideo;


<a id="org5f6817b"></a>

## Invidious

    [Desktop Entry]
    Name=Invidious
    StartupNotify=true
    Icon=/home/kayg/Pictures/Icons/youtube.png
    Comment=Most popular video streaming platform
    Exec=chromium --user-data-dir=${HOME}/.config/chromium/Apps --app=https://tube.kayg.org/
    Terminal=false
    Type=Application
    MimeType=x-scheme-handler/youtube;
    StartupWMClass=invidious
    Categories=Audio;Music;Player;AudioVideo;


<a id="org496a5f5"></a>

## Riot

    [Desktop Entry]
    Name=Riot
    Comment=A feature-rich client for Matrix.org
    Exec=chromium --user-data-dir=${HOME}/.config/chromium/Apps --app=https://riot.im/app/
    Terminal=false
    Type=Application
    Icon=/home/kayg/Pictures/Icons/riot.png
    StartupWMClass="Riot"
    Categories=Network;InstantMessaging;Chat;IRCClient


<a id="orgc5cd2de"></a>

## Saavn

    [Desktop Entry]
    Name=Saavn
    StartupNotify=true
    Icon=/home/kayg/Pictures/Icons/jiosaavn.png
    Comment=Saavn audio streaming service
    Exec=chromium --user-data-dir=${HOME}/.config/chromium/Apps --app=https://www.jiosaavn.com/
    Terminal=false
    Type=Application
    MimeType=x-scheme-handler/saavn;
    StartupWMClass=saavn
    Categories=Audio;Music;Player;AudioVideo;


<a id="org0dfb489"></a>

## Slack

    [Desktop Entry]
    Name=Slack
    StartupWMClass=Slack
    Comment=Where work happens
    GenericName=Slack Desktop
    Exec=chromium --user-data-dir=${HOME}/.config/chromium/Apps --app=https://iiit-bhcoding.slack.com/
    Icon=slack
    Terminal=false
    Type=Application
    MimeType=x-scheme-handler/slack;
    StartupNotify=true
    Categories=GNOME;GTK;Network;InstantMessaging;


<a id="org670f4da"></a>

## Wire

    [Desktop Entry]
    Name=Wire
    Comment=The most secure collaboration platform.
    Exec=chromium --user-data-dir=$HOME/.config/chromium/Apps --app=https://app.wire.com
    Terminal=false
    Type=Application
    Icon=/home/kayg/Pictures/Icons/wire.png
    StartupWMClass=Wire
    Categories=Network;
    GenericName=Secure messenger
    Keywords=chat;encrypt;e2e;messenger;videocall
    MimeType=x-scheme-handler/wire
    Version=1.1


<a id="org6e6d9d6"></a>

# Emacs

After an year of configuring Emacs, I have somehow reached
exactly at a point which mimics the style and philosophy of
Doom Emacs without realizing it. Although my configuration
was, at heart, a doomacs; in performance and functionality,
it lagged behind by a significant margin.

I have found myself frustrated by the fact that I have to
bake in functionality of every kind when I&rsquo;m in *need* of
that particular functionality, and hence, a lot of time was
spent in adding functionality rather than being creative or
productive. My first train of thought was to try something
which abstracted all of this functionality into a single
click &#x2013; something like VSCodium &#x2013; but the problem with
that particular editor is it isn&rsquo;t particularly hackable.
Apart from a hundred or so rants about how lacking VSCodium
is to my pal [Anwes](https://pandacowbat.com), one particular thing that irked me a lot
was the incessant need to reach for the mouse for something
or the other. I would have to change the whole keyboard
shortcuts layout to customize it to my needs and what was
worse is that I would have to remember two of those layouts
&#x2013; one which worked with the vim emulation and one which
worked with native VSCodium &#x2013; and the latter doesn&rsquo;t even
support three key chord bindings at the time of writing
this.

What VSCodium excels at, though, is the autocompletion,
intellisense, *almost* baked-in like support for linting,
checking, debugging. LSP is a first class citizen in
VSCodium and VSCodium is the first (and perhaps the only?)
editor that LSP is tested on. All of this makes LSP on
something like Emacs a slow, tedious hog; adding further
disappointment given the time taken to configure it.

The solution &#x2013; or perhaps &#x2013; the best balance that I could
find was in ****doom**** (pun intended). Doom Emacs (for now, at
least) seems to do everything I need, OOTB; has a
trouble-free way of adding language support. So I am
throwing away (or refactoring?) my 1 year-in-the-making
configuration of Emacs to find my peace in doom.


<a id="org5982f90"></a>

## Init

    ;;; init.el -*- lexical-binding: t; -*-
    
    ;; Copy this file to ~/.doom.d/init.el or ~/.config/doom/init.el ('doom install'
    ;; will do this for you). The `doom!' block below controls what modules are
    ;; enabled and in what order they will be loaded. Remember to run 'doom refresh'
    ;; after modifying it.
    ;;
    ;; More information about these modules (and what flags they support) can be
    ;; found in modules/README.org.
    
    (doom! :input
           ;;chinese
           ;;japanese
    
           :completion
           company           ; the ultimate code completion backend
           ;;helm              ; the *other* search engine for love and life
           ;;ido               ; the other *other* search engine...
           ivy               ; a search engine for love and life
    
           :ui
           ;;deft              ; notational velocity for Emacs
           doom              ; what makes DOOM look the way it does
           doom-dashboard    ; a nifty splash screen for Emacs
           doom-quit         ; DOOM quit-message prompts when you quit Emacs
           ;;fill-column       ; a `fill-column' indicator
           hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
           ;;hydra
           indent-guides     ; highlighted indent columns
           modeline          ; snazzy, Atom-inspired modeline, plus API
           nav-flash         ; blink the current line after jumping
           ;;neotree           ; a project drawer, like NERDTree for vim
           ophints           ; highlight the region an operation acts on
           (popup            ; tame sudden yet inevitable temporary windows
            +all             ; catch all popups that start with an asterix
            +defaults)       ; default popup rules
           ;;pretty-code       ; replace bits of code with pretty symbols
           tabs              ; an tab bar for Emacs
           treemacs          ; a project drawer, like neotree but cooler
           ;;unicode           ; extended unicode support for various languages
           vc-gutter         ; vcs diff in the fringe
           vi-tilde-fringe   ; fringe tildes to mark beyond EOB
           window-select     ; visually switch windows
           workspaces        ; tab emulation, persistence & separate workspaces
    
           :editor
           (evil +everywhere); come to the dark side, we have cookies
           file-templates    ; auto-snippets for empty files
           ;;god               ; run Emacs commands without modifier keys
           fold              ; (nigh) universal code folding
           ;;(format +onsave)  ; automated prettiness
           ;;lispy             ; vim for lisp, for people who dont like vim
           multiple-cursors  ; editing in many places at once
           ;;objed             ; text object editing for the innocent
           ;;parinfer          ; turn lisp into python, sort of
           rotate-text       ; cycle region at point between text candidates
           snippets          ; my elves. They type so I don't have to
           ;;word-wrap         ; soft wrapping with language-aware indent
    
           :emacs
           dired             ; making dired pretty [functional]
           electric          ; smarter, keyword-based electric-indent
           ibuffer           ; interactive buffer management
           vc                ; version-control and Emacs, sitting in a tree
    
           :term
           eshell            ; a consistent, cross-platform shell (WIP)
           ;;shell             ; a terminal REPL for Emacs
           ;;term              ; terminals in Emacs
           vterm             ; another terminals in Emacs
    
           :tools
           ;;ansible
           ;;debugger          ; FIXME stepping through code, to help you add bugs
           ;;direnv
           ;;docker
           ;;editorconfig      ; let someone else argue about tabs vs spaces
           ;;ein               ; tame Jupyter notebooks with emacs
           eval              ; run code, run (also, repls)
           flycheck          ; tasing you for every semicolon you forget
           ;;flyspell          ; tasing you for misspelling mispelling
           ;;gist              ; interacting with github gists
           (lookup           ; helps you navigate your code and documentation
            +docsets)        ; ...or in Dash docsets locally
           lsp
           ;;macos             ; MacOS-specific commands
           magit             ; a git porcelain for Emacs
           ;;make              ; run make tasks from Emacs
           ;;pass              ; password manager for nerds
           ;;pdf               ; pdf enhancements
           ;;prodigy           ; FIXME managing external services & code builders
           ;;rgb               ; creating color strings
           ;;terraform         ; infrastructure as code
           ;;tmux              ; an API for interacting with tmux
           ;;upload            ; map local to remote projects via ssh/ftp
           ;;wakatime
    
           :lang
           ;;agda              ; types of types of types of types...
           ;;assembly          ; assembly for fun or debugging
           cc                ; C/C++/Obj-C madness
           ;;clojure           ; java with a lisp
           ;;common-lisp       ; if you've seen one lisp, you've seen them all
           ;;coq               ; proofs-as-programs
           ;;crystal           ; ruby at the speed of c
           ;;csharp            ; unity, .NET, and mono shenanigans
           data              ; config/data formats
           ;;erlang            ; an elegant language for a more civilized age
           ;;elixir            ; erlang done right
           ;;elm               ; care for a cup of TEA?
           emacs-lisp        ; drown in parentheses
           ;;ess               ; emacs speaks statistics
           ;;faust             ; dsp, but you get to keep your soul
           ;;fsharp           ; ML stands for Microsoft's Language
           go                ; the hipster dialect
           (haskell +intero) ; a language that's lazier than I am
           ;;hy                ; readability of scheme w/ speed of python
           ;;idris             ;
           (java +meghanada) ; the poster child for carpal tunnel syndrome
           ;;javascript        ; all(hope(abandon(ye(who(enter(here))))))
           ;;julia             ; a better, faster MATLAB
           ;;kotlin            ; a better, slicker Java(Script)
           ;;latex             ; writing papers in Emacs has never been so fun
           ;;lean
           ;;ledger            ; an accounting system in Emacs
           ;;lua               ; one-based indices? one-based indices
           markdown          ; writing docs for people to ignore
           ;;nim               ; python + lisp at the speed of c
           nix               ; I hereby declare "nix geht mehr!"
           ;;ocaml             ; an objective camel
           (org              ; organize your plain life in plain text
            +dragndrop       ; drag & drop files/images into org buffers
            ;+hugo            ; use Emacs for hugo blogging
            +ipython         ; ipython/jupyter support for babel
            +pandoc          ; export-with-pandoc support
            ;+pomodoro        ; be fruitful with the tomato technique
            +present)        ; using org-mode for presentations
           ;;perl              ; write code no one else can comprehend
           ;;php               ; perl's insecure younger brother
           ;;plantuml          ; diagrams for confusing people more
           ;;purescript        ; javascript, but functional
           python            ; beautiful is better than ugly
           ;;qt                ; the 'cutest' gui framework ever
           ;;racket            ; a DSL for DSLs
           ;;rest              ; Emacs as a REST client
           ;;ruby              ; 1.step {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}
           ;;rust              ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
           ;;scala             ; java, but good
           ;;scheme            ; a fully conniving family of lisps
           sh                ; she sells {ba,z,fi}sh shells on the C xor
           ;;solidity          ; do you need a blockchain? No.
           ;;swift             ; who asked for emoji variables?
           ;;terra             ; Earth and Moon in alignment for performance.
           ;;web               ; the tubes
    
           :email
           ;;(mu4e +gmail)       ; WIP
           ;;notmuch             ; WIP
           ;;(wanderlust +gmail) ; WIP
    
           ;; Applications are complex and opinionated modules that transform Emacs
           ;; toward a specific purpose. They may have additional dependencies and
           ;; should be loaded late.
           :app
           ;;calendar
           ;;irc               ; how neckbeards socialize
           ;;(rss +org)        ; emacs as an RSS reader
           ;;twitter           ; twitter client https://twitter.com/vnought
           ;;(write            ; emacs for writers (fiction, notes, papers, etc.)
           ;; +wordnut         ; wordnet (wn) search
           ;; +langtool)       ; a proofreader (grammar/style check) for Emacs
    
           :config
           ;; For literate config users. This will tangle+compile a config.org
           ;; literate config in your `doom-private-dir' whenever it changes.
           ;;literate
    
           ;; The default module sets reasonable defaults for Emacs. It also
           ;; provides a Spacemacs-inspired keybinding scheme and a smartparens
           ;; config. Use it as a reference for your own modules.
           (default +bindings +smartparens))


<a id="org75373ea"></a>

## Config

-   Set theme
-   Do not preserve indentation while tangling code blocks.

    (setq doom-theme 'doom-Iosevkem)
    (setq org-src-preserve-indentation nil)


<a id="orgb06a74c"></a>

# Firefox


<a id="orgc2462ee"></a>

## Profiles

-   `StartWithLastProfile` ensures a profile choice isn&rsquo;t
    asked at startup.

Sometimes Firefox amazes me by how customizable it is. I
have <del>two</del> three profiles with Firefox; one for browsing,
one for *research* and one for web applications. Since a lot
of my research gets lost and I&rsquo;m unable to refer to previous
findings, it helps to have a separate profile. All profiles
are stored in a standardized XDG configuration directory
(`~/.config/firefox`) rather than the default
(`~/.mozilla/firefox/`). I would also rather name my own
profiles than let firefox name them randomly.

<del>I tried running Electron Apps with it but sadly, things</del>
<del>like pasting images from clipboard and downloading files</del>
<del>from Skype (yes, my workplace uses **Skype** in 2019, **groan**)</del>
<del>do not work. Hence I now rely on Ungoogled Chromium to do my</del>
<del>dirty work.</del>

<del>I tried using ungoogled chromium for dirty web apps but</del>
<del>recently, on Arch Linux, `libjsoncpp` got an update and</del>
<del>broke chromium which isn&rsquo;t as regularly built as the</del>
<del>upstream binaries. So though, clipboard interaction was a</del>
<del>sweet feature to have, I can let it go for relatively good</del>
<del>stability.</del>

Ungoogled Chromium works again!

Although things work fine with UC, I&rsquo;m unsure if Chromium
profiles actually provide a *temporary-container* sort of
isolation. I say this because tabs on different profiles
show up as normal tabs in the task manager which would mean
that an application running on one profile is externally
aware. Please correct me on this if you have more
information. I also miss the declarative configuration that
Firefox offers as I reinstall often.

    [General]
    StartWithLastProfile=1
    
    [Profile0]
    Name=Browse
    IsRelative=1
    Path=../../.config/firefox/browse
    Default=1
    
    [Profile1]
    Name=Research
    IsRelative=1
    Path=../../.config/firefox/research
    Default=0


<a id="org46b2595"></a>

## Policies

Mozilla&rsquo;s Policies&rsquo; explanation can be found [here](https://github.com/mozilla/policy-templates/blob/master/README.md).

    {
      "policies": {
        "CaptivePortal": true,
        "Cookies": {
          "Default": true,
          "AcceptThirdParty": "never",
          "ExpireAtSessionEnd": true
        },
        "DisableAppUpdate": false,
        "DisableDeveloperTools": false,
        "DisableFeedbackCommands": true,
        "DisableFirefoxAccounts": false,
        "DisableFirefoxScreenshots": true,
        "DisableFirefoxStudies": true,
        "DisableMasterPasswordCreation": true,
        "DisablePocket": true,
        "DisableProfileImport": false,
        "DisableSetDesktopBackground": false,
        "DisableSystemAddonUpdate": true,
        "DisableTelemetry": true,
        "DNSOverHTTPS": {
          "Enabled": true,
          "ProviderURL": "https://dns.quad9.net/dns-query",
          "Locked": false
        },
        "Extensions": {
          "Install": [
                       "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/httpz/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/invidition/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/peertubeify/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/umatrix/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/user-agent-string-switcher/latest.xpi"
                     ],
          "Uninstall": [
                         "amazondotcom@search.mozilla.org",
                         "bing@search.mozilla.org",
                         "ebay@search.mozilla.org",
                         "google@search.mozilla.org",
                         "twitter@search.mozilla.org"
                   ],
          "Locked":  [""]
        },
        "ExtensionUpdate": true,
        "HardwareAcceleration": true,
        "NetworkPrediction": false,
        "NoDefaultBookmarks": true,
        "OfferToSaveLogins": false,
        "SanitizeOnShutdown": {
            "Cache": true,
            "Cookies": false,
            "Downloads": false,
            "FormData": false,
            "History": false,
            "Sessions": true,
            "SiteSettings": false,
            "OfflineApps": true
        },
        "SearchBar": "unified",
        "SSLVersionMin": "tls1.2"
      }
    }


<a id="org6adcc70"></a>

## UserJS


<a id="orgd697f5b"></a>

### General

I use GHacks&rsquo; UserJS which I think is an excellent beginner
point towards making your own customizations as it allows
you to focus on tweaking for usablity from an already
privacy-centered configuration.

    /// GPU Acceleration ///
    
    // Force enable hardware acceleration
    user_pref("layers.acceleration.force-enabled", true);
    // WebRender is automatically disabled for screens < 4K
    user_pref("gfx.webrender.all", true);
    // Enable accelerated azure canvas
    user_pref("gfx.canvas.azure.accelerated", true);
    
    /// GPU Acceleration ///
    
    /// Storage ///
    
    // Do caching in RAM instead of disk
    user_pref("browser.cache.disk.enable", false);
    user_pref("browser.cache.memory.enable", true);
    
    // Save session data every 5 minutes instead of every 15 seconds
    user_pref("browser.sessionstore.interval", 300000);
    
    /// Storage ///
    
    /// Search ///
    
    // Search via address bar
    user_pref("keyword.enabled", true);
    
    // Enable suggestion of searches; safe since I use SearX
    user_pref("browser.search.suggest.enabled", true);
    user_pref("browser.urlbar.suggest.searches", true);
    
    /// Search ///
    
    
    /// Misc ///
    
    // Disable letterboxing
    user_pref("privacy.resistFingerprinting.letterboxing", false);
    
    // Enable WebAssembly
    user_pref("javascript.options.wasm", true);
    
    /// Misc ///


<a id="org9e6565a"></a>

### Themes

1.  MaterialFox

        /// MaterialFox ///
        
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        user_pref("svg.context-properties.content.enabled", true);
        user_pref("browser.tabs.tabClipWidth", 83);
        user_pref("materialFox.reduceTabOverflow", true);
        user_pref("security.insecure_connection_text.enabled", true);
        
        /// MaterialFox ///

2.  GNOME

        /// GNOME ///
        
        /* user.js
         * https://github.com/rafaelmardojai/firefox-gnome-theme/
         */
        
        // Enable customChrome.css
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        
        // Enable CSD
        user_pref("browser.tabs.drawInTitlebar", true);
        
        // Set UI density to normal
        user_pref("browser.uidensity", 0);
        
        /// GNOME ///


<a id="org472dff4"></a>

## Setup

Functions:

-   `createWorkDir`: checks if the work directory already
    exists, removes it if it does exist (which it will, in
    case non-zero termination of the script), to start afresh.
-   `fetchGHacksJS`: fetches the source from upstream and
    navigates into the folder
-   `mkTweaks`: makes the custom user.js tweaks according to the
    option passed. Currently, supported themes are *MaterialFox*
    and *GNOME*.
-   `applyToProfiles`: reads `profiles.ini` and creates the
    specified profiles, thereafter copying the modified
    user.js files into those profiles.
-   `cleanUp`: removes the created work directory.

This script sets up my firefox profiles and custom userJS that
builds upon the GHacksUserJS.

    #!/usr/bin/env bash
    
    # import sanity
    set -euo pipefail
    
    # global declarations
    SCRIPT_PATH=$(dirname $(realpath "${BASH_SOURCE}"))
    
    mkWorkDir() {
        if [[ -d "${SCRIPT_PATH}"/workdir ]]; then
            rm -rf "${SCRIPT_PATH}"/workdir
        fi
    
        echo "Creating Work Directory..."
        mkdir -p "${SCRIPT_PATH}"/workdir
    }
    
    fetchGHacksJS() {
        echo "Fetching ghacks user.js..."
        git clone https://github.com/ghacksuserjs/ghacks-user.js.git "${SCRIPT_PATH}"/workdir/ghjs 2>/dev/null 1>&2
    }
    
    mkTweaks() {
        cp "${SCRIPT_PATH}"/*.js "${SCRIPT_PATH}"/workdir/ghjs
    
        echo "Applying userchrome tweaks..."
        case "${1}" in
            -m | --materialFox)
                cat "${SCRIPT_PATH}"/workdir/ghjs/materialfox.js >> "${SCRIPT_PATH}"/workdir/ghjs/user-overrides.js
                ;;
            -g | --gnome)
                cat "${SCRIPT_PATH}"/workdir/ghjs/gnome.js >> "${SCRIPT_PATH}"/workdir/ghjs/user-overrides.js
                ;;
            -n | --none)
                ;;
            -h | --help)
                echo -ne "\\nFirefox UserJS helper:
                                     -g, --gnome: apply GNOME userchrome theme
                                     -h, --help: display this message
                                     -m, --materialFox: apply MaterialFox userchrome theme
                                     -n, --none: no theme\\n"
                ;;
            *)
                echo -ne "\\nInvalid flag. Pass -h or --help for usage.\\n"
                exit 1
        esac
    
        echo "Merging tweaks with ghacks user.js..."
        "${SCRIPT_PATH}"/workdir/ghjs/updater.sh -s 2>/dev/null 1>&2
    }
    
    updateUserJS() {
        mkWorkDir
        fetchGHacksJS
        mkTweaks -n
    }
    
    applyUserJS() {
        profileList=$(cat "${SCRIPT_PATH}"/profiles.ini | grep -i 'Name' | cut -d '=' -f 2 | awk '{print tolower($0)}')
    
        for profile in ${profileList}; do
            echo "-> Copying user.js to profile: ${profile}..."
            cp "${SCRIPT_PATH}"/workdir/ghjs/user.js "${HOME}/.config/firefox/${profile}"
        done
    }
    
    createProfilesINIDir() {
        mkdir -p "${HOME}/.mozilla/firefox"
    }
    
    applyProfilesINI() {
        ln -sf "${SCRIPT_PATH}"/profiles.ini "${HOME}/.mozilla/firefox/"
    }
    
    createProfiles() {
        profileList=$(cat "${SCRIPT_PATH}"/profiles.ini | grep -i 'Name' | cut -d '=' -f 2 | awk '{print tolower($0)}')
    
        echo "Making profile directories..."
        for profile in ${profileList}; do
            mkdir -p "${HOME}/.config/firefox/${profile}"
        done
    }
    
    applyPolicies() {
        echo "Copying policies.json (may need root permissions)..."
    
        if [[ -d /usr/lib/firefox ]]; then
            sudo ln -sf "${SCRIPT_PATH}"/policies.json /usr/lib/firefox/distribution
        elif [[ -d /opt/firefox-nightly ]]; then
            sudo chown -R ${USER}:${USER} /opt/firefox-nightly
            ln -sf "${SCRIPT_PATH}"/policies.json /opt/firefox-nightly/distribution
        elif [[ -d /opt/firefox-developer-edition ]]; then
            ln -sf "${SCRIPT_PATH}"/policies.json /opt/firefox-developer-edition/distribution
        elif [[ -d /usr/lib/firefox-developer-edition ]]; then
            sudo ln -sf "${SCRIPT_PATH}"/policies.json /usr/lib/firefox-developer-edition/distribution
        fi
    }
    
    cleanUp() {
        echo "Cleaning up after myself..."
        rm -rf "${SCRIPT_PATH}"/workdir
    }
    
    startFirefox() {
        $(command -v firefox) --ProfileManager 2> /dev/null || \
        $(command -v firefox-developer-edition) --ProfileManager 2> /dev/null
    
        echo "Firefox is setup and started. Have a good day!"
    }


<a id="org29156cf"></a>

# Plasma


<a id="org9748b84"></a>

## Environment

    export SSH_ASKPASS="$(command -v ksshaskpass)"
    export GIT_ASKPASS="$(command -v ksshaskpass)"


<a id="org768007f"></a>

## PAM

    SSH_AUTH_SOCK DEFAULT="${XDG_RUNTIME_DIR}/ssh-agent.socket"


<a id="org88cbb65"></a>

# Systemd


<a id="orgf3c98e6"></a>

## SSH Agent

    [Unit]
    Description=SSH key agent
    
    [Service]
    Type=simple
    Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
    ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK
    
    [Install]
    WantedBy=default.target


<a id="orgf45f83c"></a>

# Thunderbird


<a id="org8cafccd"></a>

## Profiles

This reads the same as the profiles section of Firefox.

    [General]
    StartWithLastProfile=1
    
    [Profile0]
    Name=Primary
    IsRelative=1
    Path=../.config/thunderbird/primary
    Default=1


<a id="orge07ece5"></a>

# Ungoogled Chromium


<a id="org4cbf211"></a>

## Environment Variables

From Debian bug tracker:

> As can be seen in the upstream discussion, this happens whenever mesa
> drivers are used since threads are used in their GLSL shader
> implementation.  This does have a consequence, chromium&rsquo;s GPU driver
> will not be sandboxed.  You can see this in about:gpu.
> 
> Also seen upstream, it should be possible to work around the problem
> by setting MESA<sub>GLSL</sub><sub>CACHE</sub><sub>DISABLE</sub>=true.
> 
> Best wishes,
> Mike

    MESA_GLSL_CACHE_DISABLE=true


<a id="org3909704"></a>

## Flags

A better explanation can be found [here](https://peter.sh/experiments/chromium-command-line-switches/).

    # Disable workarounds for various GPU driver bugs.
    # --disable-gpu-driver-bug-workarounds
    # Enable hardware acceleration
    --enable-accelerated-mjpeg-decode
    --enable-accelerated-video
    --enable-gpu-rasterization
    --enable-native-gpu-memory-buffers
    --enable-zero-copy
    --ignore-gpu-blacklist
    # Disables the crash reporting.
    --disable-breakpad
    # Disables cloud backup feature.
    --disable-cloud-import
    # Disables installation of default apps on first run. This is used during automated testing.
    --disable-default-apps
    # Disables the new Google favicon server for fetching favicons for Most Likely tiles on the New Tab Page.
    --disable-ntp-most-likely-favicons-from-server
    # Disables showing popular sites on the NTP.
    --disable-ntp-popular-sites
    # Disable auto-reload of error pages if offline.
    --disable-offline-auto-reload
    # Disables sign-in promo.
    --disable-signin-promo
    # The "disable" flag for kEnableSingleClickAutofill.
    --disable-single-click-autofill
    # Disables syncing browser data to a Google Account.
    --disable-sync
    # Disables the default browser check. Useful for UI/browser tests where we want to avoid having the default browser info-bar displayed.
    --no-default-browser-check
    # Don't send hyperlink auditing pings.
    --no-pings
    # Enable Dark Mode
    --force-dark-mode
    --enable-features=WebUIDarkMode


<a id="org5f6d019"></a>

# Utility

A crontab entry (as root, wherever needed) can be added to automate periodic builds / runs.

A few guidelines followed throughout these scripts:

-   Output is silenced and is replaced by friendly messages.
-   Errors are handled explicitly instead of letting the script fail.
-   Each task is divided into functions, no matter how small.
    The main function looks like nothing more than a series of steps (function calls).
-   Documentation for what the function does and why is provided.


<a id="org28a28de"></a>

## Ungoogled Chromium Extension Updater

-   `USER_DATA_DIR` is your data directory for Chromium.
    Normally, it is $HOME/.config/chromium. However since I
    sync my chromium profiles using Nextcloud and only use it
    for web applications; I like to keep it separated from the
    default installation.
-   `EXT_DIR` is the directory where extensions are stored.
-   `EXTID_LIST` is the list of all extensions you have
    installed currently. The list is fetched from the data
    directory, excluding the *Temp* directory.
-   `CHROMIUM_VERSION` fetches the major version of chromium
    that is installed.

For this function to work, you must set
`chrome://flags/#extension-mime-request-handling` to *Always
prompt for install* for automatic prompts. A truly
unattended way of updating extensions is not possible at
this moment.

    # import sanity
    set -euo pipefail
    
    # global declarations
    USER_DATA_DIR="${HOME}/.config/chromium/Apps"
    EXT_DIR="${USER_DATA_DIR}/Default/Extensions"
    EXTID_LIST=$(ls -1 "${EXT_DIR}" | grep -v Temp)
    CHROMIUM_VERSION=$($(command -v chromium) --version | grep -o '\s[0-9][0-9]\.[0-9]' | tr -d ' ')
    
    printDetails() {
        echo -e "Your Chromium version is ${CHROMIUM_VERSION}.\nYour profile is located at ${USER_DATA_DIR}."
    }
    
    checkForUpdate() {
        if [[ $((10#${1})) -gt $((10#${2})) ]]; then
            return 0
        else
            return 1
        fi
    }
    
    installExtension() {
        $(command -v chromium) --user-data-dir="${USER_DATA_DIR}" "${1}"
    }
    
    main() {
        printDetails
    
        for extID in ${EXTID_LIST}; do
            UPDATE_URL="https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${CHROMIUM_VERSION}&x=id%3D${extID}%26installsource%3Dondemand%26uc"
    
            if [[ -n $(ls -1 "${EXT_DIR}/${extID}") ]]; then
                oldVersion=$(ls -1 "${EXT_DIR}/${extID}" | tail -1 | sed 's/\.//g; s/\_//g')
                newVersion=$(curl -s "${UPDATE_URL}" | grep --only extension_[0-9]*_[0-9]*_[0-9]*.*.crx | sed -e 's/extension_//g; s/\.crx//g; s/\.//g; s/\_//g')
    
                if checkForUpdate "${newVersion}" "${oldVersion}"; then
                    installExtension "${UPDATE_URL}"
                fi
            else
                installExtension "${UPDATE_URL}"
            fi
        done
    }
    
    main "${@}"


<a id="org1aed3d4"></a>

## Virtual Desktop Bar (KDE)

-   `fetchSource` gets the latest master from github and
    places it in a subdirectory.
-   `installDeps` installs the missing dependencies required
    for building virtual desktop bar.
-   `buildTarget` executes a list of commands as mentioned on
    the github page for building the widget.
-   `installTarget` runs `make install` to copy the built
    target into the appropriate plasma directory.
-   Lastly, `cleanUp` removes the downloaded source.

    # import sanity
    set -euo pipefail
    
    # global declarations
    SCRIPT_PATH=$(dirname $(realpath "$0"))
    URL="https://github.com/wsdfhjxc/virtual-desktop-bar.git"
    
    fetchSource() {
        echo -e "Fetching source..."
        if git clone --quiet "${URL}" "${SCRIPT_PATH}"/virtual-desktop-bar; then
            echo -e "\t-> Source fetched successfully."
        else
            echo -e "\t-> Source couldn't be fetched."
        fi
    }
    
    installDeps() {
        echo -e "Installing dependencies (if any)..."
    
        if sudo pacman --sync --noconfirm --needed cmake extra-cmake-modules gcc 1> /dev/null 2>&1; then
            echo -e "\t-> Installed all required dependencies."
        else
            echo -e "\t-> All dependencies could not be installed!"
        fi
    }
    
    buildTarget() {
        cd "${SCRIPT_PATH}"/virtual-desktop-bar
        mkdir -p "${SCRIPT_PATH}"/virtual-desktop-bar/build
        cd "${SCRIPT_PATH}"/virtual-desktop-bar/build
    
        echo -e "Generating configuration..."
        if cmake "${SCRIPT_PATH}"/virtual-desktop-bar 1> /dev/null 2>&1; then
            echo -e "\t-> Configuration generated."
        else
            echo -e "\t-> Configuration generation failed!"
        fi
    
        echo -e "Building Virtual Desktop Bar..."
        if make -j$(nproc) 1> /dev/null; then
            echo -e "\t-> Building successful."
        else
            echo -e "\t-> Building failed!"
        fi
    }
    
    installTarget() {
        cd "${SCRIPT_PATH}"/virtual-desktop-bar/build
    
        echo -e "Installing target (need root permissions)..."
        if sudo make install 1> /dev/null 2>&1; then
            echo -e "\t-> Installing successful."
        else
            echo -e "\t-> Installing failed!"
        fi
    }
    
    cleanUp() {
        echo -e "Cleaning up all the cruft..."
        rm -rf "${SCRIPT_PATH}"/virtual-desktop-bar
    }
    
    main() {
        if [[ -d "${SCRIPT_PATH}"/virtual-desktop-bar ]]; then
            cleanUp
        fi
    
        fetchSource
        installDeps
        buildTarget
        installTarget
        cleanUp
    }
    
    main


<a id="orgfb338b2"></a>

## KWin Tiling Script (Faho)

Mostly the same as *Virtual Desktop Bar* sans the building.
The quirk here is to symlink a `.desktop` file for the gooey
configuration section to appear.

There is also an update step which is necessary if the
script has been previously installed.

    # import sanity
    set -euo pipefail
    
    # global declarations
    SCRIPT_PATH=$(dirname $(realpath "$0"))
    URL="https://github.com/kwin-scripts/kwin-tiling.git"
    
    fetchSource() {
        echo -e "Fetching source..."
        if git clone --quiet "${URL}" "${SCRIPT_PATH}"/kwin-tiling; then
            echo -e "\t-> Source fetched successfully."
        else
            echo -e "\t-> Source couldn't be fetched."
        fi
    }
    
    installScript() {
        echo -e "Installing KWin Tiling Script..."
        if plasmapkg2 --type kwinscript --install "${SCRIPT_PATH}"/kwin-tiling 1>/dev/null 2>&1; then
            echo -e "\t-> Installation successful."
        else
            echo -e "\t-> Installation failed!"
        fi
    }
    
    updateScript() {
        echo -e "Updating KWin Tiling Script..."
        if plasmapkg2 --type kwinscript --upgrade "${SCRIPT_PATH}"/kwin-tiling 1> /dev/null 2>&1; then
            echo -e "\t-> Update successful."
        else
            echo -e "\t-> Update failed!"
        fi
    }
    
    fixConf() {
        # necessary for configuration option in KWin Scripts menu
        mkdir -p "${HOME}"/.local/share/kservices5
        ln -sf "${HOME}"/.local/share/kwin/scripts/kwin-script-tiling/metadata.desktop "${HOME}"/.local/share/kservices5/kwin-script-tiling.desktop
    }
    
    cleanUp() {
        echo -e "Cleaning up all the cruft..."
        rm -rf "${SCRIPT_PATH}"/kwin-tiling
    }
    
    main() {
        if [[ -d "${SCRIPT_PATH}"/kwin-tiling ]]; then
            cleanUp
        fi
    
        fetchSource
        if [[ -d /home/kayg/.local/share/kwin/scripts/kwin-script-tiling ]]; then
            updateScript
        else
            installScript
        fi
    
        fixConf
        cleanUp
    }
    
    main


<a id="orgc912831"></a>

## Wallpaper Index

Variables:

-   `WALL_STORAGE_PATH` holds the location where the indexed
    wallpapers are kept. Default value is
    `$HOME/Pictures/Wallpapers/Wallhaven` (expected to change in
    the future).
-   `WALL_TEMP_PATH` holds the location where the wallpapers
    are downloaded or wherever they are kept unorganized.
    Default value is $HOME/Downloads.

Functions:

-   `changeWallStoragePath` prompts for a new location for
    `WALL_STORAGE_PATH` and proceeds normally if
    
    -   the response is any of &ldquo;y&rdquo;, &ldquo;Y&rdquo;, &ldquo;yes&rdquo;, &ldquo;YES&rdquo;, etc and the entered path exists
    -   the response is any of &ldquo;n&rdquo;, &ldquo;N&rdquo;, &ldquo;no&rdquo;, &ldquo;NO&rdquo;, etc
    
    In case of an invalid response, the prompt is shown again.
-   `changeWallTempPath` is exactly the same as
    `changeWallStoragePath` but for `WALL_TEMP_PATH`.
-   `rename` does the following:
    -   reads the last index from `WALL_STORAGE_PATH` and
        wallpaper list from `WALL_TEMP_PATH`
    -   runs through the list of wallpapers, separates extension
        from name in order to preserve it in the renamed file
    -   renames files with a message saying so
    -   updates the index after each rename
-   `main`, unless either of &ldquo;-s&rdquo; or &ldquo;&#x2013;silent&rdquo; is passed,
    proceeds to invoke all functions.

    # import sanity
    set -euo pipefail
    
    # global declarations
    SCRIPT_PATH=$(dirname $(realpath "$0"))
    WALL_STORAGE_PATH="${HOME}/Pictures/Wallpapers/Wallhaven"
    WALL_TEMP_PATH="${HOME}/Downloads"
    
    changeWallStoragePath() {
        while true; do
            echo -ne "Wallpapers storage path is currently set to ${WALL_STORAGE_PATH}. Do you want to change it? "
            read -r resp
    
            echo
            case "${resp}" in
                [yY]|[yY][eE][Ss])
                    echo -ne "Please enter a path for wallpaper storage: "
                    read -r WALL_STORAGE_PATH
    
                    echo
                    if [[ ! -d "${WALL_STORAGE_PATH}" ]]; then
                        echo "You've entered a path that does not exist."
                        continue
                    else
                        break
                    fi
                    ;;
                [nN]|[nN][oO])
                    break
                    ;;
                *)
                    echo -e "Invalid response."
                    continue
            esac
        done
    }
    
    changeWallTempPath() {
        while true; do
            echo -ne "Wallpapers temporary storage path is currently set to ${WALL_TEMP_PATH}. Do you want to change it? "
            read -r resp
    
            echo
            case "${resp}" in
                [yY]|[yY][eE][Ss])
                    echo -ne "Please enter a path for wallpaper storage: "
                    read -r WALL_TEMP_PATH
    
                    echo
                    if [[ ! -d "${WALL_TEMP_PATH}" ]]; then
                        echo "You've entered a path that does not exist."
                        continue
                    else
                        break
                    fi
                    ;;
                [nN]|[nN][oO])
                    break
                    ;;
                *)
                    echo -e "Invalid response."
                    continue
            esac
        done
    }
    
    rename() {
        lastIndex=$(ls -1 --sort=version "${WALL_STORAGE_PATH}" | grep -E '^[0-9]+\.[a-z]+$' | tail -1 | cut -d '.' -f1)
        wallList=$(ls -1 --sort=time "${WALL_TEMP_PATH}" | grep -E '^[wW]allhaven.*')
    
        echo -e "Renaming wallpapers..."
        for wall in ${wallList}; do
            ext=$(echo "${wall}" | cut -d '.' -f2)
            if mv "${WALL_TEMP_PATH}/${wall}" "${WALL_STORAGE_PATH}/$((lastIndex + 1)).${ext}"; then
                echo -e "${WALL_TEMP_PATH}/${wall} has been renamed to ${WALL_STORAGE_PATH}/$((lastIndex + 1)).${ext}"
            else
                echo -e "File ${WALL_TEMP_PATH}/${wall} could not be renamed."
                exit 1
            fi
    
            lastIndex="$((lastIndex + 1))"
        done
    }
    
    main() {
        set +u
        case "${1}" in
            "-s"|"--silent")
                rename 1>/dev/null 2>&1
                ;;
        esac
        set -u
    
        changeWallStoragePath
        changeWallTempPath
        rename
    }
    
    main


<a id="org07014b2"></a>

# VSCodium

I tried VSCodium for a brief period of time but the fact
that a completely keyboard driven workflow cannot be
achieved with ease bothers me a lot. Don&rsquo;t get me wrong, the
autocompletion and the learning curve are simply amazing but
there&rsquo;s no other reason to choose VSCodium over something as
mature as Emacs.


<a id="org4e0058c"></a>

## Settings

    {
        "breadcrumbs.enabled": true,
        "editor.fontLigatures": true,
        "editor.fontSize": 20,
        "editor.lineNumbers": "relative",
        "editor.minimap.enabled": false,
        "editor.renderControlCharacters": false,
        "editor.renderWhitespace": "boundary",
        "editor.trimAutoWhitespace": true,
        // Vim features
        "vim.autoindent": true,
        "vim.hlsearch": false,
        "vim.highlightedyank.enable": true,
        // Vim plugins
        "vim.surround": true,
        "vim.camelCaseMotion.enable": false,
        // Vim keybindings
        "vim.leader": "space",
        "vim.insertModeKeyBindings": [
            {
                "before": ["j", "k"],
                "after": ["escape"],
            },
            {
                "before": ["k", "j"],
                "after": ["escape"],
            },
        ],
        "vim.normalModeKeyBindingsNonRecursive": [
            // navigation
           {
               "before": ["g", "h"],
               "commands": [
                   "cursorHome",
               ]
           },
           {
               "before": ["g", "j"],
               "commands": [
                   "cursorBottom",
               ],
           },
           {
               "before": ["g", "k"],
               "commands": [
                   "cursorTop",
               ],
           },
           {
               "before": ["g", "l"],
               "commands": [
                   "cursorEnd",
               ],
           },
            // helm
           {
               "before": ["<leader>", "<leader>"],
               "commands":  [
                   "workbench.action.showCommands",
               ],
           },
           {
               "before": ["<leader>", "h", "f"],
               "commands":  [
                   "workbench.action.quickOpen",
               ],
           },
           // buffers
           {
               "before": ["<leader>", "b", "w"],
               "commands": [
                   "workbench.action.files.save",
               ],
           },
           {
               "before": ["<leader>", "b", "q"],
               "commands": [
                   "workbench.action.closeActiveEditor",
               ],
           },
           // windows
           {
               "before": ["<leader>", "w", "/"],
               "commands": [
                   "workbench.action.splitEditorRight"
               ],
           },
           {
               "before": ["<leader>", "w", "-"],
               "commands": [
                   "workbench.action.splitEditorDown"
               ],
           },
           {
               "before": ["<leader>", "w", "h"],
               "commands": [
                   "workbench.action.focusLeftGroup"
               ],
           },
           {
               "before": ["<leader>", "w", "j"],
               "commands": [
                   "workbench.action.focusBelowGroup"
               ],
           },
           {
               "before": ["<leader>", "w", "k"],
               "commands": [
                   "workbench.action.focusAboveGroup"
               ],
           },
           {
               "before": ["<leader>", "w", "l"],
               "commands": [
                   "workbench.action.focusRightGroup"
               ],
           },
           // terminal
           {
               "before": ["<leader>", "t", "t"],
               "commands": [
                   "workbench.action.terminal.toggleTerminal"
               ],
           },
           // panels and sidebars
           {
               "before": ["<leader>", "p", "t"],
               "commands": [
                   "workbench.action.togglePanel"
               ],
           },
           {
               "before": ["<leader>", "s", "t"],
               "commands": [
                   "workbench.action.toggleSidebarVisibility"
               ],
           },
           // Run tasks
           {
               "before": ["<leader>", "r", "r"],
               "commands": [
                   "workbench.action.tasks.reRunTask"
               ],
           },
           {
               "before": ["<leader>", "r", "b"],
               "commands": [
                   "workbench.action.tasks.build"
               ],
           },
           {
               "before": ["<leader>", "r", "c"],
               "commands": [
                   "workbench.action.tasks.configureTaskRunner"
               ],
           },
        ],
        "vim.visualModeKeyBindingsNonRecursive": [
            {
                "before": [
                    "p",
                ],
                "after": [
                    "p",
                    "g",
                    "v",
                    "y",
                ],
            },
            {
                "before": [
                    ">"
                ],
                "commands": [
                    "editor.action.indentLines"
                ]
            },
            {
                "before": [
                    "<"
                ],
                "commands": [
                    "editor.action.outdentLines"
                ]
            },
        ],
        "vim.useSystemClipboard": true,
        "window.menuBarVisibility": "default",
        "window.zoomLevel": 0,
        "workbench.editor.showTabs": true,
        "workbench.activityBar.visible": false,
        "workbench.statusBar.visible": true,
        "C_Cpp.clang_format_fallbackStyle": "LLVM",
        "editor.hideCursorInOverviewRuler": true,
        "editor.overviewRulerBorder": false,
        "editor.scrollbar.horizontal": "hidden",
        "editor.scrollbar.vertical": "hidden"
    }


<a id="orgf780ebb"></a>

## Keybindings

    [
        {
            "key": "ctrl+space space",
            "command": "workbench.action.showCommands"
        },
        {
            "key": "ctrl+space s",
            "command": "workbench.action.toggleSidebarVisibility"
        },
        {
            "key": "ctrl+` t",
            "command": "workbench.action.terminal.toggleTerminal"
        },
        {
            "key": "ctrl+p t",
            "command": "workbench.action.togglePanel"
        },
        {
            "key": "ctrl+space f",
            "command": "workbench.action.quickOpen"
        },
        {
            "key": "ctrl+space /",
            "command": "workbench.action.findInFiles"
        },
        {
            "key": "ctrl+shift+f",
            "command": "-workbench.action.findInFiles"
        },
        {
            "key": "ctrl+space m",
            "command": "workbench.actions.view.problems"
        },
        {
            "key": "ctrl+shift+m",
            "command": "-workbench.actions.view.problems"
        },
        {
            "key": "ctrl+`",
            "command": "-workbench.action.terminal.toggleTerminal"
        },
        {
            "key": "ctrl+shift+space t",
            "command": "workbench.action.terminal.new"
        },
        {
            "key": "ctrl+shift+`",
            "command": "-workbench.action.terminal.new"
        },
        {
            "key": "tab",
            "command": "selectNextSuggestion",
            "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
        },
        {
            "key": "ctrl+down",
            "command": "-selectNextSuggestion",
            "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
        },
        {
            "key": "shift+tab",
            "command": "selectPrevSuggestion",
            "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
        },
        {
            "key": "ctrl+up",
            "command": "-selectPrevSuggestion",
            "when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus"
        }
    ]


<a id="org96d3fad"></a>

# ZSH


<a id="org2dafbfb"></a>

## Oh-my-zsh stuff

Settings specific to OMZ.

    # Path to oh-my-zsh installation.
    export ZSH="/home/kayg/.config/omz"
    
    # Set OMZ theme
    ZSH_THEME="agnoster"
    
    # _ and - will be interchangeable.
    HYPHEN_INSENSITIVE="true"
    
    # Enable command auto-correction.
    ENABLE_CORRECTION="true"
    
    # Display red dots whilst waiting for completion.
    COMPLETION_WAITING_DOTS="true"
    
    # Too many plugins slow down shell startup.
    # Plugins can be found in $ZSH/plugins
    plugins=(
        copyfile
        git
        vi-mode
        z
        zsh-syntax-highlighting
        zsh-autosuggestions
    )
    
    source "${ZSH}"/oh-my-zsh.sh


<a id="orge3fd1aa"></a>

## Functions


<a id="org2df05f8"></a>

### Weather

Fetches the current weather from wttr.in, assumes my city
unless specified otherwise.

    wttr() {
        curl https://wttr.in/${1:-Bhubaneswar}
    }


<a id="orgb5bab62"></a>

## Variables

    # PATH
    export PATH="${HOME}/.emacs.d/bin:${HOME}/.local/bin:${PATH}"
    
    # GO
    export GOPATH="${HOME}/.go"
    export GOBIN="${HOME}/.local/bin"
    
    # ZSH
    # Fetch suggestions asynchronously
    export ZSH_AUTOSUGGEST_USE_ASYNC=1
    # order of strategies to try
    export ZSH_AUTOSUGGEST_STRATEGY=(
        match_prev_cmd
        completion
    )
    # Avoid autosuggestions for buffers that are too large
    export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20


<a id="org20563bd"></a>

## Aliases

    if command -v kitty 2>/dev/null 1>&2; then
        alias icat="kitty +kitten icat"
    fi
    
    alias vim='emacsclient -nw'

