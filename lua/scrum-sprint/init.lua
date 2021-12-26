local M = {}

local options = {
  enabled = true,
}

function M.setup(opts)
  options = vim.tbl_deep_extend('force', options, opts or {})
end

function M.foo()
  if options.enabled  then
    print('this is scrum_sprint plugin.')
  else
    print('this is not scrum_sprint plugin.')
  end
end

return M

--return {
--    foo = foo
--}
