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

`rscodeio` modifies the theme of RStudio menus. These are not exposed by the current theming API and so this is achieved by modifying style sheets in the RStudio installation. To modify files in this area will likely require the installation to be run with administrator privelidges. To do this:

* On Windows start RStudio by right clicking on a shortcut or menu icon and selecting 'Run as Administrator'
* On Linux start RStudio in a terminal using `sudo rstudio --no-sandbox`
* On Mac (? - Help Wanted)

From within RStudio running as administrator, run this command to install and apply the theme: 

```
rscodeio::install_theme()
```

And close RStudio. Reopen it in the normal way and the theme should be fully applied.

Once installed it can also be selected using the RStudio theme picker in the usual way.

# For best results

- Enable: Tools -> Global Options -> Code -> Display -> Highligh R Function Calls 
- Enable: Tools -> Global Options -> Code -> Display -> Show Syntax Highlighting in Console
- Enable: Tools -> Global Options -> Code -> Display -> Show Indent Guides
- Enable: Tools -> Global Options -> Code -> Display -> Highlight Selected Line

# Switching to another theme

`rscodeio` modifies UI elements that are not part of standard theming. This means the RStudio file menus will remain dark even if you switch to another theme. To revert them, within an RStudio session run as administrator, use: `rscodeio::deactivate_menu_theme`. Reactivate again with: `rscodeio::activate_menu_theme`.

# Supported Platforms

`rscodeio` has only been tested on Windows and Pop!_OS Linux so far. Feedback from other platforms welcome.

