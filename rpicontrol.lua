started = 0
our_id = 0
path = os.getenv("HOME").."/telegram"
function vardump(value, depth, key)
  local linePrefix = ""
  local spaces = ""
  
  if key ~= nil then
    linePrefix = "["..key.."] = "
  end
  
  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for i=1, depth do spaces = spaces .. "  " end
  end
  
  if type(value) == 'table' then
    mTable = getmetatable(value)
    if mTable == nil then
      print(spaces ..linePrefix.."(table) ")
    else
      print(spaces .."(metatable) ")
        value = mTable
    end		
    for tableKey, tableValue in pairs(value) do
      vardump(tableValue, depth, tableKey)
    end
  elseif type(value)	== 'function' or 
      type(value)	== 'thread' or 
      type(value)	== 'userdata' or
      value		== nil
  then
    print(spaces..tostring(value))
  else
    print(spaces..linePrefix.."("..type(value)..") "..tostring(value))
  end
end

print ("HI, this is lua script")
print ("Python scripts, photo.jpg and rpicontrol.lua should be in "..path)

function ok_cb(extra, success, result)
end

-- Notification code {{{

function get_title (P, Q)
  if (Q.type == 'user') then
    return P.first_name .. " " .. P.last_name
  elseif (Q.type == 'chat') then
    return Q.title
  elseif (Q.type == 'encr_chat') then
    return 'Secret chat with ' .. P.first_name .. ' ' .. P.last_name
  else
    return ''
  end
end

local lgi = require ('lgi')
local notify = lgi.require('Notify')
notify.init ("Telegram updates")
local icon = os.getenv("HOME") .. "/.telegram-cli/telegram-pics/telegram_64.png"

function do_notify (user, msg)
  local n = notify.Notification.new(user, msg, icon)
  n:show ()
end

-- }}}

function on_msg_receive (msg)
  if started == 0 then
    return
  end
  if msg.out then
    return
  end
  do_notify (get_title (msg.from, msg.to), msg.text)

  if (msg.text == 'ping') then
    if (msg.to.id == our_id) then
      send_msg (msg.from.print_name, 'pong', ok_cb, false)
    else
      send_msg (msg.to.print_name, 'pong', ok_cb, false)
    end
    return
  end
  if (msg.text == 'PING') then
    if (msg.to.id == our_id) then
      fwd_msg (msg.from.print_name, msg.id, ok_cb, false)
    else
      fwd_msg (msg.to.print_name, msg.id, ok_cb, false)
    end
    return
  end
  if (msg.text == 'Sendphoto') then
    os.execute('python /home/pi/takepic.py')
    send_photo (msg.from.print_name, path..'/photo.jpg',ok_cb,false)
    return
  end
  if (msg.text == 'LedOnRed') then
    os.execute('sudo python /home/pi/LedSet.py OnR')
    send_msg (msg.from.print_name, 'Red Led turned on', ok_cb, false)
    return
  end
  if (msg.text == 'LedOffRed') then
    os.execute('sudo python /home/pi/LedSet.py OffR')
    send_msg (msg.from.print_name, 'Red Led turned off', ok_cb, false)
    return
  end
  if (msg.text == 'LedOnBlue') then
    os.execute('sudo python /home/pi/LedSet.py OnB')
    send_msg (msg.from.print_name, 'Blue Led turned on', ok_cb, false)
    return
  end
  if (msg.text == 'LedOffBlue') then
    os.execute('sudo python /home/pi/LedSet.py OffB')
    send_msg (msg.from.print_name, 'Blue Led turned off', ok_cb, false)
    return
  end
  if (msg.text == 'LedOnBoth') then
    os.execute('sudo python /home/pi/LedSet.py OnBoth')
    send_msg (msg.from.print_name, 'Both Leds turned on', ok_cb, false)
    return
  end
  if (msg.text == 'LedOffBoth') then
    os.execute('sudo python /home/pi/LedSet.py OffBoth')
    send_msg (msg.from.print_name, 'Both Leds turned off', ok_cb, false)
    return
  end
  if (msg.text == 'LedFlashRed') then
    os.execute('sudo python /home/pi/LedSet.py FlashR')
    send_msg (msg.from.print_name, 'Red Led Flashed 5 times', ok_cb, false)
    return
  end
  if (msg.text == 'LedFlashBlue') then
    os.execute('sudo python /home/pi/LedSet.py FlashB')
    send_msg (msg.from.print_name, 'Blue Led Flashed 5 times', ok_cb, false)
    return
  end
  if (msg.text == 'LedFlashBoth') then
    os.execute('sudo python /home/pi/LedSet.py FlashBoth')
    send_msg (msg.from.print_name, 'Both Leds Flashed 5 times', ok_cb, false)
    return
  end
  if (msg.text == 'Buzz') then
    os.execute('sudo python /home/pi/Buzz.py')
    send_msg (msg.from.print_name, 'Buzzer alert sent', ok_cb, false)
    return
  end
  if (msg.text == 'f') then
    os.execute('sudo python /home/pi/LedSet.py f')
    send_msg (msg.from.print_name, 'Car moved forward', ok_cb, false)
    return
  end
  if (msg.text == 'b') then
    os.execute('sudo python /home/pi/LedSet.py b')
    send_msg (msg.from.print_name, 'Car moved backward', ok_cb, false)
    return
  end
  if (msg.text == 'r') then
    os.execute('sudo python /home/pi/LedSet.py r')
    send_msg (msg.from.print_name, 'Car turned right', ok_cb, false)
    return
  end
  if (msg.text == 'l') then
    os.execute('sudo python /home/pi/LedSet.py l')
    send_msg (msg.from.print_name, 'Car turned left', ok_cb, false)
    return
  end
end

function on_our_id (id)
  our_id = id
end

function on_user_update (user, what)
  --vardump (user)
end

function on_chat_update (chat, what)
  --vardump (chat)
end

function on_secret_chat_update (schat, what)
  --vardump (schat)
end

function on_get_difference_end ()
end

function cron()
  -- do something
  postpone (cron, false, 1.0)
end

function on_binlog_replay_end ()
  started = 1
  postpone (cron, false, 1.0)
end
