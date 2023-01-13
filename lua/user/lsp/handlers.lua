local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
  local signs = {

    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- virtual_text = true,
    virtual_text = { spacing = 3, prefix = "" },
    signs = {
      active = signs, -- show signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
  -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  --   -- virtual_text = true,
  --   virtual_text = { spacing = 0, prefix = "" },
  --   signs = true,
  --   underline = true,
  --   update_in_insert = true,
  -- })
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set
  keymap("n", "gD", vim.lsp.buf.declaration, opts)
  keymap("n", "gd", vim.lsp.buf.definition, opts)
  keymap("n", "K", vim.lsp.buf.hover, opts)
  keymap("n", "gI", vim.lsp.buf.implementation, opts)
  keymap("n", "gr", vim.lsp.buf.references, opts)
  keymap("n", "gl", vim.diagnostic.open_float, opts)
  keymap("n", "<space>pf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
  keymap("n", "<space>pi", "<cmd>LspInfo<cr>", opts)
  keymap("n", "<space>pI", "<cmd>LspInstallInfo<cr>", opts)
  keymap("n", "<space>pa", vim.lsp.buf.code_action, opts)
  keymap({ "n", "x", "o", "i" }, "<A-l>", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
  keymap({ "n", "x", "o", "i" }, "<A-h>", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
  -- keymr, "n", "<space>pr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  keymap("n", "<space>ps", vim.lsp.buf.signature_help, opts)
  keymap("n", "<space>pq", vim.diagnostic.setqflist, opts)

  if vim.o.filetype == "python" then
    keymap("n", "<Tab>", "<cmd>PyrightOrganizeImports<cr>", opts)
  end
end

M.on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end

  if client.name == "sumneko_lua" then
    client.server_capabilities.documentFormattingProvider = false
  end

  lsp_keymaps(bufnr)
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end
  illuminate.on_attach(client)
end

return M
