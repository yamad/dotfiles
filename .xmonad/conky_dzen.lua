conky.config = {
   background = false,
   out_to_x = false,
   out_to_console = true,
   cpu_avg_samples = 2,
   net_avg_samples = 2,
   update_interval = 2.0,
   total_run_times = 0
}

colors = {
   separator = "tan",
   icon = "lightblue",
}

spacers = {
   small = 2,
   medium = 4,
   large = 5
}

part = {}

function part.spacer(size)
   return '^p(' .. spacers[size] .. ')'
end

function part.separator()
   return part.spacer('large')
      .. '^fg(' .. colors.separator .. ')' .. '|' .. '^fg()'
      .. part.spacer('large')
end

function part.icon(name)
   local path_prefix = '$HOME/.xmonad/icons/'
   return '^fg(' .. colors.icon .. ')'
      .. '^i(' .. path_prefix .. name .. ".xbm)"
      .. '^fg()'
end

function part.cpu(num)
   return part.icon('cpu') .. part.spacer('large')
      .. '${cpu cpu' .. num .. '}%'
end

function part.mem()
   return part.icon('mem') .. part.spacer('large')
      .. '${memperc}%'
end

function part.battery()
   return part.icon('bat_full_01') .. part.spacer('large')
      .. '${battery_percent}%'
end

function part.date()
   return ''
      --.. '${time %a},' .. part.spacer('small')
      .. '${time %d}' .. part.spacer('medium')
      .. '${time %b}' .. part.spacer('medium')
      .. '${time %Y}'
end

function part.time()
   return '^fg(' .. colors.icon .. ')'
      .. '${time %l:%M}' .. part.spacer('small')
      .. '${time %p}' .. '^fg()'
end

conky.text = ""
   .. part.cpu(0)
   .. part.separator()
   .. part.mem()
   .. part.separator()
   .. part.battery()
   .. part.separator()
   .. part.date()
   .. part.spacer('small')
   .. part.time()
   .. part.spacer('large')
