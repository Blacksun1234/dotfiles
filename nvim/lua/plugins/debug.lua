-- ~/.config/nvim/lua/plugins/debug.lua
--
-- Configuration du debugging C/C++ pour LazyVim, via nvim-dap + codelldb
-- (codelldb = adaptateur DAP basé sur LLDB, installé/géré par Mason).
--
-- Prérequis :
--   1. Ton build doit contenir les symboles de debug, par ex. :
--        cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
--      (sinon le débogueur ne pourra pas afficher variables, breakpoints, etc.)
--   2. Redémarre Neovim (ou lance :Lazy sync) après avoir ajouté ce fichier :
--      Mason installera codelldb automatiquement au premier chargement.

return {
  -- Installe et enregistre automatiquement codelldb via Mason
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "codelldb" },
      automatic_installation = true,
    },
  },

  {
    "mfussenegger/nvim-dap",
    -- Raccourcis façon "touches de fonction" (style VS Code)
    keys = {
      {
        "<F5>",
        function()
          local dap = require("dap")
          -- Si aucune session n'est active, on recompile d'abord
          -- (équivalent à ton "cmake --build build/ && ./build/broker")
          if dap.session() == nil then
            vim.notify("Compilation en cours (cmake --build build)...", vim.log.levels.INFO)
            local output = vim.fn.system("cmake --build build")
            if vim.v.shell_error ~= 0 then
              vim.notify("Échec de la compilation :\n" .. output, vim.log.levels.ERROR)
              return
            end
          end
          dap.continue()
        end,
        desc = "Debug: Build + Lancer/Continuer",
      },
      {
        "<S-F5>",
        function()
          require("dap").terminate()
        end,
        desc = "Debug: Arrêter",
      },
      {
        "<F9>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
    },
    opts = function()
      local dap = require("dap")

      -- L'adaptateur pointe vers le binaire codelldb installé par Mason
      dap.adapters.codelldb = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      local cpp_config = {
        {
          name = "Lancer ./build/broker",
          type = "codelldb",
          request = "launch",
          program = "${workspaceFolder}/build/broker",
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          name = "Lancer (choisir l'exécutable)",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Chemin de l'exécutable : ", vim.fn.getcwd() .. "/build/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.cpp = cpp_config
      dap.configurations.c = cpp_config
    end,
  },
}
