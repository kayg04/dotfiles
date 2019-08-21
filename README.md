
# Table of Contents

1.  [Awesome](#orga453cb0)
    1.  [rc.lua](#org17e71fc)
    2.  [Themes](#org4e6ff54)
        1.  [Default](#orgab1e7b8)
2.  [Compton](#orgc9d7dac)
3.  [Emacs](#org3171845)
4.  [Firefox](#orgcd3b157)
    1.  [Profiles](#org2c67d52)
    2.  [Policies](#org50c9661)
    3.  [UserJS](#orgb0f0e45)
        1.  [General](#org2de409a)
        2.  [Themes](#org835b8ed)
    4.  [Bootstrap](#org0c5d804)
5.  [ZSH](#orgded6857)
    1.  [Setup](#orgbee2f0a)
    2.  [Template](#orgbdc27cb)
    3.  [Functions](#org581e603)
        1.  [Weather](#org2735ad3)



<a id="orga453cb0"></a>

# Awesome


<a id="org17e71fc"></a>

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


<a id="org4e6ff54"></a>

## Themes


<a id="orgab1e7b8"></a>

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


<a id="orgc9d7dac"></a>

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


<a id="org3171845"></a>

# Emacs

Since Emacs' settings are already managed through an org
file, there is no need to go meta. This is the init.el file
which emacs first reads and uses it tangle its full
configuration elsewhere.

    (require 'org)
    (setq-default user-emacs-directory "~/.config/emacs/")
    (org-babel-load-file
     (expand-file-name "settings.org"
                       user-emacs-directory))


<a id="orgcd3b157"></a>

# Firefox


<a id="org2c67d52"></a>

## Profiles

-   `StartWithLastProfile` ensures a profile choice isn't
    asked at startup.

Sometimes Firefox amazes me by how customizable it is. I
have two profiles with Firefox; one for browsing and one for
*research*. Since a lot of my research gets lost and I'm
unable to refer to previous findings, it helps to have a
separate profile. Both profiles are stored in a standardized
XDG configuration directory (`~/.config/firefox`) rather
than the default (`~/.mozilla/firefox/`). I would also
rather name my own profiles than let firefox name them
randomly.

I tried running Electron Apps with it but sadly, things like
pasting images from clipboard and downloading files from
Skype (yes, my workplace uses **Skype** in 2019, **groan**) do
not work. Hence I now rely on Ungoogled Chromium to do my
dirty work.

Although things work fine with UC, I'm unsure if Chromium
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


<a id="org50c9661"></a>

## Policies

Mozilla's Policies' explanation can be found [here](https://github.com/mozilla/policy-templates/blob/master/README.md).

    {
      "policies": {
        "CaptivePortal": true,
        "Cookies": {
          "Default": true,
          "AcceptThirdParty": "never",
          "ExpireAtSessionEnd": false
        },
        "DisableAppUpdate": false,
        "DisableDeveloperTools": false,
        "DisableFeedbackCommands": true,
        "DisableFirefoxAccounts": false,
        "DisableFirefoxScreenshots": true,
        "DisableFirefoxStudies": false,
        "DisableMasterPasswordCreation": true,
        "DisablePocket": true,
        "DisableProfileImport": false,
        "DisableSetDesktopBackground": false,
        "DisableSystemAddonUpdate": true,
        "DisableTelemetry": false,
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
                       "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi",
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
            "SiteSettings": true,
            "OfflineApps": true
        },
        "SearchBar": "unified",
        "SSLVersionMin": "tls1.2"
      }
    }


<a id="orgb0f0e45"></a>

## UserJS


<a id="org2de409a"></a>

### General

I use GHacks' UserJS which I think is an excellent beginner
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


<a id="org835b8ed"></a>

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


<a id="org0c5d804"></a>

## Bootstrap

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
    
    set -euo pipefail
    
    createWorkDir() {
        if [[ -d ./workdir ]]; then
            rm -rf ./workdir
        fi
    
        echo "Creating Work Directory..."
        mkdir -p ./workdir
        cd ./workdir
    }
    
    fetchGHacksJS() {
        echo "Fetching ghacks user.js..."
        git clone https://github.com/ghacksuserjs/ghacks-user.js.git ./ghjs 2>/dev/null 1>&2
        cd ./ghjs
    }
    
    mkTweaks() {
        cp ../../*.js ./
    
        echo "Applying userchrome tweaks..."
        case "${1}" in
            -m | --materialFox)
                cat ./materialfox.js >> ./user-overrides.js
                ;;
            -g | --gnome)
                cat ./gnome.js >> ./user-overrides.js
                ;;
            -h | --help)
                echo -ne "\\nFirefox UserJS helper:
                                     -g, --gnome: apply GNOME userchrome theme
                                     -h, --help: display this message
                                     -m, --materialFox: apply MaterialFox userchrome theme\\n"
                ;;
            *)
                echo -ne "\\nInvalid flag. Pass -h or --help for usage.\\n"
                exit 1
        esac
    
        echo "Merging tweaks with ghacks user.js..."
        ./updater.sh -s 2>/dev/null 1>&2
    }
    
    applyToProfiles() {
        profileList=$(cat ../../profiles.ini | grep -i 'Name' | cut -d '=' -f 2 | awk '{print tolower($0)}')
    
        echo "Making profile directories..."
        for profile in ${profileList}; do
            mkdir -p "${HOME}/.config/firefox/${profile}"
            cp ./user.js "${HOME}/.config/firefox/${profile}"
        done
    
        echo "Copying profiles.ini..."
        mkdir -p "${HOME}/.mozilla/firefox"
        cp ../../profiles.ini "${HOME}/.mozilla/firefox/"
    
        echo "Copying policies.json..."
        if ! cp ../../policies.json /opt/firefox-nightly/distribution/; then
            echo "Please fix permissions on the firefox-nightly directory by executing:
                         sudo chown -R $USER:$USER /opt/firefox-nightly/"
        fi
    }
    
    cleanUp() {
        cd ../../
        echo "Cleaning up after myself..."
        rm -rf ./workdir
    }
    
    main() {
        createWorkDir
        fetchGHacksJS
        mkTweaks "${1}"
        applyToProfiles
        cleanUp
    
        echo "Firefox is setup. Have a good day!"
    }
    
    main "${1}"


<a id="orgded6857"></a>

# ZSH


<a id="orgbee2f0a"></a>

## Setup

This script sets up OH-MY-ZSH on a system if it doesn't
previously exist. It also imports all of my custom aliases
and functions.

    #!/usr/bin/env bash
    
    set -euo pipefail
    
    installOMZ() {
        if [[ ! upgrade_oh_my_zsh || ! -d "${HOME}/.oh-my-zsh" ]]; then
            sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        else
            exit 1
        fi
    }
    
    importDef() {
        echo 'source ${HOME}/.config/zsh/*.zsh 2>/dev/null 1>&2' >> "${HOME}/.zshrc"
    }
    
    main() {
        installOMZ
        importDef
    }
    
    main


<a id="orgbdc27cb"></a>

## Template

    # If you come from bash you might have to change your $PATH.
    # export PATH=$HOME/bin:/usr/local/bin:$PATH
    
    # Path to your oh-my-zsh installation.
    export ZSH="/home/kayg/.oh-my-zsh"
    
    # Set name of the theme to load --- if set to "random", it will
    # load a random theme each time oh-my-zsh is loaded, in which case,
    # to know which specific one was loaded, run: echo $RANDOM_THEME
    # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
    ZSH_THEME="agnoster"
    
    # Set list of themes to pick from when loading at random
    # Setting this variable when ZSH_THEME=random will cause zsh to load
    # a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
    # If set to an empty array, this variable will have no effect.
    # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
    
    # Uncomment the following line to use case-sensitive completion.
    # CASE_SENSITIVE="true"
    
    # Uncomment the following line to use hyphen-insensitive completion.
    # Case-sensitive completion must be off. _ and - will be interchangeable.
    HYPHEN_INSENSITIVE="true"
    
    # Uncomment the following line to disable bi-weekly auto-update checks.
    # DISABLE_AUTO_UPDATE="true"
    
    # Uncomment the following line to automatically update without prompting.
    # DISABLE_UPDATE_PROMPT="true"
    
    # Uncomment the following line to change how often to auto-update (in days).
    # export UPDATE_ZSH_DAYS=13
    
    # Uncomment the following line if pasting URLs and other text is messed up.
    # DISABLE_MAGIC_FUNCTIONS=true
    
    # Uncomment the following line to disable colors in ls.
    # DISABLE_LS_COLORS="true"
    
    # Uncomment the following line to disable auto-setting terminal title.
    # DISABLE_AUTO_TITLE="true"
    
    # Uncomment the following line to enable command auto-correction.
    ENABLE_CORRECTION="true"
    
    # Uncomment the following line to display red dots whilst waiting for completion.
    COMPLETION_WAITING_DOTS="true"
    
    # Uncomment the following line if you want to disable marking untracked files
    # under VCS as dirty. This makes repository status check for large repositories
    # much, much faster.
    # DISABLE_UNTRACKED_FILES_DIRTY="true"
    
    # Uncomment the following line if you want to change the command execution time
    # stamp shown in the history command output.
    # You can set one of the optional three formats:
    # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
    # or set a custom format using the strftime function format specifications,
    # see 'man strftime' for details.
    # HIST_STAMPS="mm/dd/yyyy"
    
    # Would you like to use another custom folder than $ZSH/custom?
    # ZSH_CUSTOM=/path/to/new-custom-folder
    
    # Which plugins would you like to load?
    # Standard plugins can be found in ~/.oh-my-zsh/plugins/*
    # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.
    plugins=(git)
    
    source $ZSH/oh-my-zsh.sh
    
    # User configuration
    
    # export MANPATH="/usr/local/man:$MANPATH"
    
    # You may need to manually set your language environment
    # export LANG=en_US.UTF-8
    
    # Preferred editor for local and remote sessions
    # if [[ -n $SSH_CONNECTION ]]; then
    #   export EDITOR='vim'
    # else
    #   export EDITOR='mvim'
    # fi
    
    # Compilation flags
    # export ARCHFLAGS="-arch x86_64"
    
    # Set personal aliases, overriding those provided by oh-my-zsh libs,
    # plugins, and themes. Aliases can be placed here, though oh-my-zsh
    # users are encouraged to define aliases within the ZSH_CUSTOM folder.
    # For a full list of active aliases, run `alias`.
    #
    # Example aliases
    # alias zshconfig="mate ~/.zshrc"
    # alias ohmyzsh="mate ~/.oh-my-zsh"


<a id="org581e603"></a>

## Functions


<a id="org2735ad3"></a>

### Weather

    wttr() {
        curl https://wttr.in/${1:-Bhubaneswar}
    }

