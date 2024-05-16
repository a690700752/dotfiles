return {
  {
    "michaelb/sniprun",
    cmd = "SnipRun",
    build = "sh install.sh",
    config = function()
      require("sniprun").setup({
        display = {
          "Classic",
          "VirtualTextOk",
          "Api",
        },
      })

      local sa = require("sniprun.api")

      --- @alias d {status: string, message: string}
      sa.register_listener(function(d)
        if d.status == "ok" then
          vim.fn.setreg("+", d.message)
        elseif d.status == "error" then
        else
        end
      end)
    end,
  },
}
