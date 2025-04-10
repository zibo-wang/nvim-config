# nvim-config
My NeoVim config.



# Installation

```bash
git clone git@github.com:zibo-wang/nvim-config.git ~/.config/nvim
```

# Create Patch
After change the code in plugins, don't commit, run
```bash
git diff --no-prefix -u . > mason.nvim.patch
```
Then in the file header:
```bash
diff --git a/lua/mason-core/installer/managers/pypi.lua b/lua/mason-core/installer/managers/pypi.lua
index f60a8ed..fabe9f4 100644
--- a/lua/mason-core/installer/managers/pypi.lua
+++ b/lua/mason-core/installer/managers/pypi.lua
```
remember to add a/ and b/ to the paths so that the path parsed correctly