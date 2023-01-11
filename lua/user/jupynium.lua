local status_ok, jupynium = pcall(require, "jupynium")
if not status_ok then
  return
end

jupynium.setup {
  python_host = "~/bin/miniconda3/envs/jupynium/bin/python",
  -- auto_attach_server = { enable = false },
  -- auto_start_server = { enable = true },
  -- auto_start_sync = { enable = true },
}
