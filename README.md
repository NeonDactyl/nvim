# Neovim Configuration

This repository contains a personal Neovim configuration focused on a streamlined, productive development environment. It leverages modern Neovim plugins for Language Server Protocol (LSP) integration, autocompletion, file tree navigation, and a powerful terminal experience, all organized for clarity and modularity.

## Table of Contents

1.  [Prerequisites](https://www.google.com/search?q=%23prerequisites)
2.  [Installation](https://www.google.com/search?q=%23installation)
3.  [Configuration Overview](https://www.google.com/search?q=%23configuration-overview)
      * [`init.lua`](https://www.google.com/search?q=%23initlua)
      * [`lua/neondactyl/plugins.lua`](https://www.google.com/search?q=%23luneondactylpluginslua)
      * [`lua/neondactyl/lsp_config.lua`](https://www.google.com/search?q=%23luaneondactyllsp_configlua)
      * [`lua/neondactyl/keymap.lua`](https://www.google.com/search?q=%23luaneondactylkeymaplua)
4.  [Keybindings](https://www.google.com/search?q=%23keybindings)
5.  [Features](https://www.google.com/search?q=%23features)
6.  [Transparency in Windows Terminal](https://www.google.com/search?q=%23transparency-in-windows-terminal)

## Prerequisites

Before installing, ensure you have the following installed on your system:

  * **Neovim (v0.9.0 or later recommended):** This configuration is built for modern Neovim features.
      * [Neovim GitHub Releases](https://github.com/neovim/neovim/releases)
  * **Git:** Required for cloning the repository and managing plugins.
  * **Node.js & npm (or Yarn):** Essential for `mason.nvim` to install language servers, particularly `tsserver`.
      * [Node.js Downloads](https://nodejs.org/en/download/)
  * **Lazygit:** For the integrated Git TUI experience.
      * [Lazygit Installation](https://github.com/jesseduffield/lazygit?tab=readme-ov-file#installation)
  * **A Nerd Font:** For proper display of file icons and other symbols.
      * [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
  * **Windows Terminal (for transparency):** If you wish to enable background transparency.
      * [Windows Terminal Installation](https://learn.microsoft.com/en-us/windows/terminal/install)

## Installation

1.  **Clone the Repository:**

    ```bash
    git clone <this-repo-url> ~/.config/nvim
    ```

    (Replace `<this-repo-url>` with the actual URL of your Neovim config repository.)

2.  **Start Neovim:**
    Open Neovim from your terminal:

    ```bash
    nvim
    ```

    On the first launch, `lazy.nvim` will automatically detect and install all the plugins. This might take a few moments.

3.  **Install Language Servers (via Mason):**
    After plugins are installed, open Neovim again. Language servers like `tsserver` and `omnisharp` are configured to be installed by `mason.nvim`. You can check their installation status with:

    ```vim
    :Mason
    ```

    If any are pending or failed, you can manually install them from within `:Mason` or wait for `mason` to handle it automatically.

## Configuration Overview

The configuration is structured using Lua modules for better organization and maintainability.

  * `~/.config/nvim/`
      * `init.lua`
      * `lua/`
          * `neondactyl/`
              * `plugins.lua`
              * `lsp_config.lua`
              * `keymap.lua`

### `init.lua`

This is the main entry point of the Neovim configuration.

  * Sets core Neovim options (e.g., `termguicolors`, line numbers, indentation).
  * Configures and loads `lazy.nvim` (the plugin manager).
  * Includes global settings for transparency (see [Transparency](https://www.google.com/search?q=%23transparency-in-windows-terminal)).

### `lua/neondactyl/plugins.lua`

Manages all the Neovim plugins using `lazy.nvim`. Each plugin is defined with its repository, loading events, and specific configuration logic within its `config` function.

  * **`folke/which-key.nvim`**: Configures the `which-key` plugin for displaying keybinding menus.
  * **`nvim-tree/nvim-tree.lua`**: Sets up the file explorer, including auto-open/close behavior and the contextual `on_attach` callback for buffer-local keymaps.
  * **`akinsho/toggleterm.nvim`**: Configures the integrated terminal for various purposes, including the floating LazyGit instance.
  * **`neovim/nvim-lspconfig`**: Loaded here, but its configuration details are in `lsp_config.lua`.
  * **`williamboman/mason.nvim` & `williamboman/mason-lspconfig.nvim`**: Used for managing and integrating LSP servers.
  * **`hrsh7th/nvim-cmp` & associated snippets/LSP source plugins**: Configures the autocompletion engine.
  * **`folke/trouble.nvim` & `folke/fidget.nvim`**: For enhanced diagnostics display and LSP progress indication.

### `lua/neondactyl/lsp_config.lua`

This file centralizes the configuration for LSP, Mason, and completion.

  * Defines a generic `on_attach` function that sets up common LSP keybindings (definition, hover, rename, code actions, diagnostics, formatting) for all LSP clients.
  * Configures `mason.nvim` to `ensure_installed` key language servers like `tsserver` (for TypeScript/JavaScript) and `omnisharp` (for C\#).
  * Uses `mason-lspconfig.nvim` to automatically set up LSP servers with the common `on_attach` and capabilities.
  * Includes specific `omnisharp` and `tsserver` handlers for custom `cmd` or `init_options` if needed.
  * Sets up `nvim-cmp` for autocompletion, integrating with LSP and snippets (`luasnip`).

### `lua/neondactyl/keymap.lua`

This file is dedicated to all custom keybindings.

  * Registers global keymaps using `which-key.nvim`'s `wk.add` function for leader-prefixed commands.
      * This file provides a `setup_global_whichkey_maps` function that is called from `plugins.lua` to avoid circular dependencies.
  * Sets up non-`which-key` keybindings using `vim.keymap.set`.
  * Includes the `setup_nvimtree_keymaps` function, which is passed as `on_attach` to `nvim-tree.lua` to define buffer-local keymaps (e.g., `?` for NvimTree help).
  * Contains the `lazygit_toggle` function for launching LazyGit in a custom floating terminal via `toggleterm.nvim`.

## Keybindings

This configuration includes several quality-of-life keybindings:

  * **Window Navigation:**
      * `<C-h>`: Move to the left window.
      * `<C-j>`: Move to the window below.
      * `<C-k>`: Move to the window above.
      * `<C-l>`: Move to the right window.
  * **File Tree (NvimTree):**
      * `<leader>e`: Toggle NvimTree file explorer.
      * `?` (inside NvimTree window): Show NvimTree help/keymaps.
  * **Git (Lazygit):**
      * `<leader>gg`: Toggle Lazygit in a floating terminal.
  * **LSP & General (visible via `<leader>` + `which-key`):**
      * `<leader>f`: Find files (general).
      * `<leader>l`: LSP actions group.
          * `<leader>lc`: Code Action
          * `<leader>ld`: Document Diagnostics
          * `<leader>lf`: Format (current buffer)
          * `<leader>lr`: Rename symbol
          * `<leader>lw`: Workspace Diagnostics

You can discover more keybindings by pressing `<leader>` (Spacebar by default) and waiting for the `which-key` popup.

## Features

  * **Modular Configuration:** Organized into logical Lua files.
  * **Lazy Loading:** Uses `lazy.nvim` for efficient plugin management.
  * **Language Server Protocol (LSP):** Integrated with `mason.nvim` for easy installation and `nvim-lspconfig` for server setup. Includes `tsserver` (TypeScript/JavaScript) and `omnisharp` (C\#).
  * **Autocompletion:** Powered by `nvim-cmp` with LSP and snippet (`luasnip`) sources.
  * **File Tree:** `nvim-tree.lua` for intuitive file navigation.
  * **Integrated Terminal:** `toggleterm.nvim` for seamless terminal integration, including a dedicated LazyGit toggle.
  * **Diagnostics:** `trouble.nvim` for a better overview of LSP diagnostics.
  * **LSP Progress:** `fidget.nvim` for subtle LSP background task notifications.
  * **Window Management:** Custom keybindings for quicker window navigation.
  * **Windows Terminal Transparency:** Configured to work seamlessly with Windows Terminal's opacity setting.

## Transparency in Windows Terminal

If you're using Windows Terminal with opacity enabled, this configuration ensures Neovim's background respects that transparency.

**Requirements:**

1.  **Windows Terminal:** Ensure "Opacity" is set to a value less than 100% in your Windows Terminal profile settings.
2.  **Neovim `termguicolors`:** This is set to `true` in `init.lua`.
3.  **Highlight Groups:** The `Normal` and `NormalFloat` highlight groups are set to `guibg=NONE` in `init.lua`, allowing the terminal background to show through. If your colorscheme overrides this, ensure these highlight commands are placed *after* your colorscheme is loaded.
