config.load_autoconfig()
config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.set("editor.command", ["kitty", "-e", "nvim", "{file}"])
