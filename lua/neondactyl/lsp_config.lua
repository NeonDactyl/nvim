local lspconfig = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Auto-command for LSP keymaps and formatting on attach
local on_attach = function(client, bufnr)
  -- Enable completion, formatting, etc.
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Basic keymaps for LSP actions
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap=true, silent=true }

  buf_set_keymap(bufnr, 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap(bufnr, 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap(bufnr, 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap(bufnr, '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap(bufnr, '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
  buf_set_keymap(bufnr, '<leader>d', '<cmd>TroubleToggle document_diagnostics<CR>', opts)
  buf_set_keymap(bufnr, '<leader>ws', '<cmd>TroubleToggle workspace_diagnostics<CR>', opts)

  -- Auto-format on save (optional, but highly recommended for consistency)
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('LspFormatOnSave', { clear = true }),
    buffer = bufnr,
    callback = function()
      -- Added check: Only format if the client supports formatting.
      -- This makes it more robust for clients that don't offer formatting.
      if client.supports_method("textDocument/formatting") then
        vim.lsp.buf.format({ async = false })
      end
    end,
  })
end

-- Setup Mason
require('mason').setup()

-- Setup Mason-LSPConfig and attach LSP servers
require('mason-lspconfig').setup({
  ensure_installed = {
    "omnisharp",
    "ts_ls",
  },
  handlers = {
    -- Default handler for any other LSPs installed by Mason (if any others were installed manually)
    function(server_name)
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,

    -- Specific handler for OmniSharp (C#)
    ["omnisharp"] = function()
      lspconfig.omnisharp.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        -- IMPORTANT: Double-check this path for your OmniSharp executable in WSL.
        -- It's often '/usr/local/bin/omnisharp-roslyn/OmniSharp' but can vary.
        cmd = { "/usr/local/bin/omnisharp-roslyn/OmniSharp" },
        enable_sdk_automatic_lsp_activation = true, -- For .NET 6+ SDK
        dotnet_root = "/usr/share/dotnet", -- Adjust if your dotnet SDK is elsewhere in WSL
        settings = {
          ["omnisharp.enableSemanticTokens"] = true, -- Enable for richer highlighting
          ["omnisharp.useGlobalMono"] = "never",     -- Use modern .NET SDK, avoid global Mono if possible
          ["omnisharp.useModernNet"] = true,         -- Use modern .NET SDK
          ["omnisharp.enableFormat"] = true,         -- Explicitly enable formatting
        },
        -- Optional: Add debug logging for OmniSharp if issues persist
        -- server_capabilities = {
        --   semanticTokensProvider = {
        --     full = { delta = true },
        --     range = true,
        --     legend = {
        --       tokenTypes = {
        --         "namespace", "type", "class", "enum", "interface", "struct", "typeParameter",
        --         "parameter", "variable", "property", "enumMember", "event", "function",
        --         "method", "macro", "keyword", "modifier", "comment", "string", "number",
        --         "regexp", "operator"
        --       },
        --       tokenModifiers = { "declaration", "static", "async", "readonly", "defaultLibrary", "local" }
        --     }
        --   }
        -- },
      })
    end,
    ["ts_ls"] = function()
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
  },
})

-- Setup nvim-cmp (completion) - this needs to be after lspconfig setup.
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `cmp_luasnip`
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" }, -- For snippets
    { name = "buffer" },  -- Current buffer words
    { name = "path" },    -- File system paths
  }),
})

-- Setup fidget.nvim (LSP progress)
require("fidget").setup({})

-- Setup trouble.nvim (LSP diagnostics)
require("trouble").setup({
  use_diagnostic_signs = true,
})
