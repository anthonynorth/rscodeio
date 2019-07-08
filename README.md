<p align=center>
  <img src="./inst/media/rscodeio.png" width="480" height="270">
</p>

# Prerequisites

RStudio 1.2.x or higher.

# Installation

Get the package:

```r
remotes::install_github("anthonynorth/rscodeio")
```

Installing and using the theme:

```
rscodeio::install_theme()
```

**note:** On Windows if your RStudio is installed to `Program Files` you will need to run `install_theme()` from within an RStudio sessio that was 'Run as Administrator' since `rscodeio` needs to change files in your installation folder.

Once installed it will automatically be appliled. It can also be selected using the RStudio theme picker in the usual way.

# For best results

- Enable: Tools -> Global Options -> Code -> Display -> Highligh R Function Calls 
- Enable: Tools -> Global Options -> Code -> Display -> Show Syntax Highlighting in Console
- Enable: Tools -> Global Options -> Code -> Display -> Show Indent Guides

# Switching to another theme

`rscodeio` modifies UI elements that are not part of standard theming. This means the RStudio file menus will remain dark even if you switch to another theme. To revert them use: `rscodeio::deactivate_menu_theme`. Reactivate again with: `rscodeio::activate_menu_theme`.

# Supported Platforms

`rscodeio` has only been tests on Windows so far. Feedback from other platforms welcome.

