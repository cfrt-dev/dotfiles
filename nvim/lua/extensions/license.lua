local map = vim.keymap.set
local license = require("license")

license.setup("Maksim Nikitin")
map("n", "<leader>gl", license.paste_license)
