
<p align="center">

<img src="./inst/media/rscodeio.png" width="480" height="270"/>

</p>
<p align="center">

<a href="https://cran.r-project.org/package=rscodeio">
<img src="https://img.shields.io/cran/v/rscodeio?style=flat-square" alt="cran"/>
</a> <a href="https://github.com/anthonynorth/rscodeio/releases/latest">
<img src="https://img.shields.io/github/v/release/anthonynorth/rscodeio?sort=semver&amp;style=flat-square" alt="release"/>
</a> <a href="https://www.tidyverse.org/lifecycle/#experimental">
<img src="https://img.shields.io/badge/lifecycle-experimental-orange?style=flat-square" alt="lifecycle"/>
</a>

</p>

# rscodeio

An RStudio theme inspired by Visual Studio Code

## Prerequisites

-   RStudio 1.2.0 or later

-   Administrator privileges (more on that [below](#details))

## Installation

Run the following to install the package:

``` r
if (!("remotes" %in% rownames(installed.packages()))) {
  install.packages(pkgs = "remotes",
                   repos = "https://cloud.r-project.org/")
}

remotes::install_github("anthonynorth/rscodeio")
```

Then run the following to install the rscodeio editor themes and menu
bar styling:

``` r
rscodeio::install_themes()
```

The above command right away activates the editor theme variant
specified in the `apply_theme` argument (which defaults to
`"rscodeio"`). To activate the second editor theme variant instead, run:

``` r
rscodeio::install_themes(apply_theme = "Tomorrow Night Bright (rscodeio)")
```

The chosen editor theme can be changed anytime later in RStudio’s global
options.

To completely uninstall the rscodeio editor themes and menu bar styling
again, run:

``` r
rscodeio::uninstall_themes()
```

## Details

This package provides two greyish dark RStudio editor themes which only
differ in the syntax highlighting style: while `rscodeio` offers the
colors found in Visual Studio Code, `Tomorrow Night Bright (rscodeio)`
combines the same dark interface theming with the syntax highlighting
colors from the similarly named editor theme provided by RStudio.

Furthermore, RStudio’s menu bar will be changed to a matching dark
style, something which is not exposed by [RStudio’s current theming
API](https://rstudio.github.io/rstudio-extensions/rstudio-theme-creation.html)
and therefore requires administrator privileges to replace the relevant
[Qt Style Sheet (QSS)](https://doc.qt.io/Qt-5/stylesheet-syntax.html)
files in RStudio’s installation directory.

-   On Linux, it will be asked interactively for administrator
    credentials by calling
    [Polkit](https://en.wikipedia.org/wiki/Polkit)’s
    [`pkexec`](https://www.freedesktop.org/software/polkit/docs/latest/pkexec.1.html).

-   On Windows, RStudio must be run as administrator for rscodeio being
    able to successfully install the menu bar styling.

-   On macOS and RStudio Server, menu bar styling is not necessary and
    thus administrator privileges are not required. (On macOS, the
    light/dark menu bar styling is inherited from the OS, so you might
    want to use your dark OS theme.)

### Recommended RStudio settings

For best results, make sure the following settings are enabled:

-   <kbd>Tools</kbd> → <kbd>Global Options…</kbd> → <kbd>Code</kbd> →
    <kbd>Display</kbd> → **☑ Highlight selected line**
-   <kbd>Tools</kbd> → <kbd>Global Options…</kbd> → <kbd>Code</kbd> →
    <kbd>Display</kbd> → **☑ Show indent guides**
-   <kbd>Tools</kbd> → <kbd>Global Options…</kbd> → <kbd>Code</kbd> →
    <kbd>Display</kbd> → **☑ Show syntax highlighting in console input**
-   <kbd>Tools</kbd> → <kbd>Global Options…</kbd> → <kbd>Code</kbd> →
    <kbd>Display</kbd> → **☑ Highlight R function calls**

### Switching to another theme

As mentioned above, rscodeio provides custom editor theme variants but
also styles RStudio’s menu bar by replacing some QSS files. This means
the RStudio menu bar will remain dark even if you switch to another
editor theme. To revert the menu bar to its default state,
**administrator privileges are required**.

To only remove the menu bar styling, run

``` r
rscodeio::uninstall_menu_theme()
```

To reinstall the menu bar styling again, run

``` r
rscodeio::install_menu_theme()
```

On Windows, for both of the above to work, Rstudio must be run as
administrator.

**Note** that the menu bar styling has to be reinstalled after *every*
update or reinstallation of RStudio. This is because the custom QSS
files provided by rscodeio get overwritten during RStudio’s installation
process.

### Supported Platforms

`rscodeio` has only been tested on Windows and Linux (Ubuntu and
Pop!\_OS Linux) so far.
[Feedback](https://github.com/anthonynorth/rscodeio/issues) from other
platforms is welcome.
