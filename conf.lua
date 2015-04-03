function love.conf(t)
    t.identity = nil                   -- The name of the save directory (string)
    t.version = "0.9.2"                -- The LÖVE version this game was made for (string)
    t.console = false                  -- Attach a console (boolean, Windows only)

    t.window = nil

    t.modules.audio = false            -- Enable the audio module (boolean)
    t.modules.event = false            -- Enable the event module (boolean)
    t.modules.graphics = false         -- Enable the graphics module (boolean)
    t.modules.image = false            -- Enable the image module (boolean)
    t.modules.joystick = false         -- Enable the joystick module (boolean)
    t.modules.keyboard = false         -- Enable the keyboard module (boolean)
    t.modules.math = false             -- Enable the math module (boolean)
    t.modules.mouse = false            -- Enable the mouse module (boolean)
    t.modules.physics = false          -- Enable the physics module (boolean)
    t.modules.sound = false            -- Enable the sound module (boolean)
    t.modules.system = true            -- Enable the system module (boolean)
    t.modules.timer = false            -- Enable the timer module (boolean)
    t.modules.window = true            -- Enable the window module (boolean)
    t.modules.thread = true            -- Enable the thread module (boolean)
end