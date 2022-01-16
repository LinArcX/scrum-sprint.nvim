local input = require("nui.input")
local event = require("nui.utils.autocmd").event

local options = {
  enabled = true,
  timeboxes_path = os.getenv("HOME") .. "/timeboxes/",
}

local M = {}
function M.setup(opts)
  options = vim.tbl_deep_extend("force", options, opts or {})
end

local function exists(path)
  local ok, err, code = os.rename(path, path)
  if not ok then
    if code == 13 then
      return true
    end
  end
  return ok, err
end

local start_point = ""
local end_point = ""
local start_day
local start_month
local start_year
local end_day
local end_month
local end_year

local function check_necessary_folders()
  if not exists(options.timeboxes_path) then
    os.execute("mkdir " .. options.timeboxes_path)
  end
end

local function create_days()
  os.execute("cd " .. options.timeboxes_path)
  while tonumber(start_year) <= tonumber(end_year) do
    print("tye")
    while tonumber(start_month) <= tonumber(end_month) do
      print("bye")
      while tonumber(start_day) <= tonumber(end_day) do
        print("hi")
        os.execute("touch " .. start_year .. start_month .. start_day ..  ".txt")
        start_day = tonumber(start_day) + 1
      end
      start_month = tonumber(start_month) + 1
    end
    start_year = tonumber(start_year) + 1
  end
end

local function get_timebox_endpoint()
  local time_box = input({
    relative = "editor",
    size = { width = 40, height = 2 },
    position = { row = "5%", col = "50%" },
    win_options = { winblend = 10, winhighlight = "Normal:Normal" },
    border = {
      highlight = "MyHighlightGroup",
      style = "single",
      text = { top = "TimeBox - EndPoint: ", top_align = "center" },
    },
  }, {
    prompt = "> ",
    on_submit = function(value)
      end_point = value
      end_year = string.sub (end_point, 1, 4)
      end_month = string.sub (end_point, 5, 6)
      end_day = string.sub (end_point, 7, 8)
      if not exists(options.timeboxes_path .. start_point .. "-" .. end_point) then
        os.execute("mkdir " .. options.timeboxes_path .. start_point .. "-" .. end_point)
      end
      create_days()
    end,
  })
  time_box:mount()
  time_box:map("n", "<Esc>", time_box.input_props.on_close, { noremap = true })
  time_box:on(event.BufLeave, function()
    time_box:unmount()
  end)
end

local function get_timebox_startpoint()
  local time_box = input({
    relative = "editor",
    size = { width = 40, height = 2 },
    position = { row = "5%", col = "50%" },
    win_options = { winblend = 10, winhighlight = "Normal:Normal" },
    border = {
      highlight = "MyHighlightGroup",
      style = "single",
      text = { top = "TiemBox - StartPoint: ", top_align = "center" },
    },
  }, {
    prompt = "> ",
    on_close = function()
      print("Bye.. see you later :)")
    end,
    on_submit = function(value)
      start_point = value
      start_year = string.sub (start_point, 1, 4)
      start_month = string.sub (start_point, 5, 6)
      start_day = string.sub (start_point, 7, 8)
      get_timebox_endpoint()
    end,
  })
  time_box:mount()
  time_box:map("n", "<Esc>", time_box.input_props.on_close, { noremap = true })
  time_box:on(event.BufLeave, function()
    time_box:unmount()
  end)
end

local function create_timebox_folder()
  check_necessary_folders()
  get_timebox_startpoint()
end

create_timebox_folder()
