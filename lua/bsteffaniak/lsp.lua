local M = {}

function Format()
  vim.lsp.buf.format({
    bufnr = vim.api.nvim_get_current_buf(),
    filter = function(c)
      return c.name ~= "tsserver"
    end,
  })
end

vim.g.show_inlays = {}

function M.lsp_on_attach(client, bufnr)
  M.init_formatting(client, bufnr)

  local opts = { noremap = true, silent = true }

  vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  vim.keymap.set("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  vim.keymap.set("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  vim.keymap.set("n", "[w", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARN})<CR>", opts)
  vim.keymap.set("n", "]w", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARN})<CR>", opts)
  vim.keymap.set("n", "[i", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.INFO})<CR>", opts)
  vim.keymap.set("n", "]i", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.INFO})<CR>", opts)
  vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.keymap.set("n", "K", "<cmp>lua require('lsp_signature').toggle_float_win()<CR>", opts)
  vim.keymap.set("n", "gr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", opts)
  vim.keymap.set("n", "gh", "<cmd>Telescope lsp_references<CR>", opts)
  vim.keymap.set("i", "<C-m>", "<cmp>lua require('lsp_signature').toggle_float_win()<CR>", opts)
  vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", opts)
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.keymap.set("n", "gL", "<cmd>Telescope diagnostics<CR>", opts)
  vim.keymap.set("n", "gt", "<cmd>TroubleToggle<CR>", opts)

  vim.g.show_inlays[bufnr] = true
  vim.lsp.inlay_hint(bufnr, vim.g.show_inlays[bufnr])

  vim.keymap.set({ "n", "i", "v" }, "<c-Space>", function()
    local current_buf = vim.api.nvim_get_current_buf()
    vim.g.show_inlays[current_buf] = not vim.g.show_inlays[current_buf]
    local show = vim.g.show_inlays[current_buf]
    vim.lsp.inlay_hint(current_buf, show)
  end, opts)

  -- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = Format,
    })
  end
end

function M.init_formatting(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.keymap.set("n", "<Leader>a", function()
      vim.lsp.buf.format({
        bufnr = vim.api.nvim_get_current_buf(),
        filter = function(c)
          return c.name ~= "tsserver"
        end,
      })
    end, { buffer = bufnr, desc = "[lsp] format" })
  end

  if client.supports_method("textDocument/rangeFormatting") then
    vim.keymap.set("x", "<Leader>a", Format, { buffer = bufnr, desc = "[lsp] format" })
  end
end

return M
