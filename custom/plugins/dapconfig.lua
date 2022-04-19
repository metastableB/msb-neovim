-- Note that we are not using this file. Here for reference
print("WARNING DAP CONFIG IMPORTED")

local dap = require('dap')


function find_debugpy()
  local output = vim.fn.system({'ps', 'a'})
  local lines = vim.split(output, '\n')
  local procs = {}
  for _, line in pairs(lines) do
    -- output format
    --    " 107021 pts/4    Ss     0:00 /bin/zsh <args>"
    local parts = vim.fn.split(vim.fn.trim(line), ' \\+')
    local pid = parts[1]
    local name = table.concat({unpack(parts, 5)}, ' ')
    if pid and pid ~= 'PID' then
      pid = tonumber(pid)
      if pid ~= vim.fn.getpid() then
        if string.find(name, 'debugpy') then
          table.insert(procs, { pid = pid, name = name })
        end
      end
    end
  end
  local label_fn = function(proc)
    return string.format("id=%d name=%s", proc.pid, proc.name)
  end
  local result = require('dap.ui').pick_one_sync(procs, "Select process", label_fn)
  return result and result.pid or nil
end

dap.adapters.python = {
  type = 'executable',
  command = 'path/to/virtualenvs/debugpy/bin/python',
  args = { '-m', 'debugpy.adapter' },
  pythonPath = function()
    local handle = io.popen("which python")
    local result = handle:read("*a")
    handle:close()
    return result
  end,
}

dap.configurations.python = {
    {
      -- If you get an "Operation not permitted" error using this, try disabling YAMA:
      --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      name = "Attach to process",
      type = 'python',  -- Adjust this to match your adapter name (`dap.adapters.<name>`)
      request = 'attach',
      pid = find_debugpy,
      args = {},
    },
}
