#' Install rscodeio editor themes and menu bar styling
#'
#' RStudio 1.2 or later is required for this. Additionally, administrator privileges are required to also install the Qt Style Sheet (QSS) files to style
#' RStudio's menu bar, something which is not possible with [RStudio's current theming
#' API](https://rstudio.github.io/rstudio-extensions/rstudio-theme-creation.html).
#'
#' # Menu bar styling
#'
#' On Linux, it will be asked interactively for administrator credentials by calling [Polkit](https://en.wikipedia.org/wiki/Polkit)'s
#' [`pkexec`](https://www.freedesktop.org/software/polkit/docs/latest/pkexec.1.html). Windows users must run RStudio as administrator in order to install
#' rscodeio's menu bar styling. On macOS and RStudio Server, menu bar styling is not necessary and thus always skipped.
#'
#' The installation of the QSS files styling the menu bar can be skipped by setting `style_menu_bar = FALSE`. See [install_menu_theme()] for more details about
#' the menu bar styling.
#'
#' Note that the menu bar styling has to be reapplied after _every_ update or reinstallation of RStudio. This is because the custom QSS files provided by
#' rscodeio get overwritten during RStudio's installation process.
#'
#' @param apply_theme The rscodeio editor theme variant to apply. All variants are installed and the one specified here is activated right away. The other
#'   variants can be selected anytime later in RStudio's global options. Variation only affects the syntax highlighting and terminal styling. One of
#'   - `"rscodeio"` for the default color variant inspired by Visual Studio Code.
#'   - `"Tomorrow Night Bright (rscodeio)"` for the colors known from the similarly named default RStudio theme.
#' @param style_menu_bar Whether to also install rscodeio's custom QSS files to style RStudio's menu bar. Administrator privileges are required.
#' @param install_globally Whether to install the editor themes for the current user (`FALSE`) or all users globally (`TRUE`). The latter may require
#'   administrator privileges.
#' @return Nothing (`NULL` invisibly).
#' @export
install_themes <- function(apply_theme = c("rscodeio",
                                           "Tomorrow Night Bright (rscodeio)"),
                           style_menu_bar = TRUE,
                           install_globally = FALSE) {

  # ensure RStudio API is available
  if (!rstudioapi::isAvailable()) {
    stop("rscodeio must be installed from within RStudio.",
         call. = FALSE)
  }

  # ensure minimally required RStudio version
  if (rstudioapi::versionInfo()$version < as.package_version("1.2.0"))
    stop("You need RStudio 1.2 or later to get theme support",
         call. = FALSE)

  # add the editor theme variants
  ## existing editor themes of the same names have to be removed first
  uninstall_themes(restore_menu_bar = FALSE)

  purrr::walk(.x = c("rscodeio.rstheme",
                     "rscodeio_tomorrow_night_bright.rstheme"),
              .f = ~ rstudioapi::addTheme(fs::path_package(package = "rscodeio",
                                                           "resources", .x),
                                          globally = install_globally))

  # add the custom QSS files
  if (style_menu_bar) install_menu_theme()

  # activate chosen rscodeio editor theme variant
  rstudioapi::applyTheme(rlang::arg_match(apply_theme))
}

#' Uninstall the rscodeio editor themes and menu bar styling
#'
#' To restore RStudio's default _dark_ Qt Style Sheet (QSS) files (i.e. setting `restore_menu_bar = TRUE`), administrator privileges are required. On Linux, it
#' will be asked interactively for administrator credentials by calling [Polkit](https://en.wikipedia.org/wiki/Polkit)'s
#' [`pkexec`](https://www.freedesktop.org/software/polkit/docs/latest/pkexec.1.html). Windows users must run RStudio as administrator in order to uninstall
#' rscodeio's menu bar styling. On macOS and RStudio Server, menu bar styling is not necessary and thus its menu bar restoration will be skipped.
#'
#' @param restore_menu_bar Whether to restore RStudio's default menu bar styling. Irrelevant if rscodeio menu bar styling is not installed (see
#'   [install_menu_theme()] for details about menu bar styling).
#' @return Nothing (`NULL` invisibly).
#' @export
uninstall_themes <- function(restore_menu_bar = TRUE) {

  if (restore_menu_bar) uninstall_menu_theme()

  purrr::walk(.x = installed_rscodeio_editor_themes(),
              .f = rstudioapi::removeTheme)
}

#' Install rscodeio menu bar styling
#'
#' This function overwrites RStudio's default _dark_ [Qt Style Sheet (QSS)](https://doc.qt.io/Qt-5/stylesheet-syntax.html) files with rscodeio's customized ones
#' in order to properly style RStudio's menu bar which cannot be altered by [RStudio's current theming
#' API](https://rstudio.github.io/rstudio-extensions/rstudio-theme-creation.html). The original Qt Style Sheet files are backed up and can be restored by
#' calling [uninstall_menu_theme()].
#'
#' Running [`install_themes(style_menu_bar = TRUE)`][install_themes()] (which is the default) has the same effect as running this function.
#' `install_menu_theme()` can be useful to install the rscodeio menu bar styling _without_ the accompanying editor themes.
#'
#' Administrator privileges are required to copy the QSS files to RStudio's installation directory. On Linux, it will be asked interactively for administrator
#' credentials by calling [Polkit](https://en.wikipedia.org/wiki/Polkit)'s [`pkexec`](https://www.freedesktop.org/software/polkit/docs/latest/pkexec.1.html).
#' Windows users must run RStudio as administrator On macOS and RStudio Server, menu bar styling is not necessary and running this function has no effect.
#'
#' Note that this function has to be executed again after _every_ update or reinstallation of RStudio. This is because the custom QSS files provided by rscodeio
#' get overwritten during RStudio's installation process.
#'
#' @return Nothing (`NULL` invisibly).
#' @export
install_menu_theme <- function() {

  # menu bar styling is not supported on macOS or RStudio Server
  if (is_macos() || is_rstudio_server()) return(NULL)

  process_menu_themes(backup_gnome = !is_rscodeio_menu_theme(path_theme_dark_gnome()),
                      backup_windows = !is_rscodeio_menu_theme(path_theme_dark_windows()),
                      override_gnome = TRUE,
                      override_windows = TRUE)
}

#' Uninstall rscodeio menu bar styling
#'
#' This function restores RStudio's default _dark_ Qt [Qt Style Sheet (QSS)](https://doc.qt.io/Qt-5/stylesheet-syntax.html) files.
#'
#' Running [`uninstall_themes(restore_menu_bar = TRUE)`][uninstall_themes()] (which is the default) has the same effect as running this function.
#' `uninstall_menu_theme()` can be useful to remove the rscodeio menu bar styling _without_ removing the accompanying editor themes.
#'
#' Administrator privileges are required to restore RStudio's default QSS files. On Linux, it will be asked interactively for administrator credentials by
#' calling [Polkit](https://en.wikipedia.org/wiki/Polkit)'s [`pkexec`](https://www.freedesktop.org/software/polkit/docs/latest/pkexec.1.html). Windows users
#' must run RStudio as administrator. On macOS and RStudio Server, menu bar styling is not necessary and running this function has no effect.
#'
#' @return Nothing (`NULL` invisibly).
#' @export
uninstall_menu_theme <- function() {

  ## menu bar styling not supported on Mac
  if (is_macos()) return(NULL)

  path_theme_dark_gnome <- path_theme_dark_gnome()
  path_theme_dark_gnome_backup <- path_theme_dark_gnome_backup()
  path_theme_dark_windows <- path_theme_dark_windows()
  path_theme_dark_windows_backup <- path_theme_dark_windows_backup()
  is_rscodeio_current_gnome <- is_rscodeio_menu_theme(path_theme_dark_gnome)
  is_rscodeio_current_windows <- is_rscodeio_menu_theme(path_theme_dark_windows)
  exists_theme_dark_gnome_backup <- fs::file_exists(path_theme_dark_gnome_backup)
  exists_theme_dark_windows_backup <- fs::file_exists(path_theme_dark_windows_backup)

  # shouldn't really happen
  if (exists_theme_dark_gnome_backup && is_rscodeio_menu_theme(path_theme_dark_gnome_backup)) {

    stop("The following backed up file supposed to be an unmodified RStudio QSS file is actually an rscodeio QSS file:\n", path_theme_dark_gnome_backup,
         "\n", "Delete the file if you'd like this error to be gone.\nUsing the R console: fs::file_delete(rscodeio:::path_theme_dark_gnome_backup())",
         call. = FALSE)
  }
  if (exists_theme_dark_windows_backup && is_rscodeio_menu_theme(path_theme_dark_windows_backup)) {

    stop("The following backed up file supposed to be an unmodified RStudio QSS file is actually an rscodeio QSS file:\n", path_theme_dark_windows_backup, "\n",
         "Delete the file if you'd like this error to be gone.\nUsing the R console: fs::file_delete(rscodeio:::path_theme_dark_windows_backup())",
         call. = FALSE)
  }

  process_menu_themes(restore_gnome = exists_theme_dark_gnome_backup && is_rscodeio_current_gnome,
                      restore_windows = exists_theme_dark_windows_backup && is_rscodeio_current_windows)

  # print instructive warnings if restoral is impossible
  if (!exists_theme_dark_gnome_backup && is_rscodeio_current_gnome) {

    warning("Unable to restore default RStudio menu bar styling for GNOME because the corresponding backup file couldn't be found.\n",
            "The most convenient way to restore the original file at ", path_theme_dark_gnome, " is to simply update or reinstall RStudio.\n",
            "RStudio stable release installers are available at https://rstudio.com/products/rstudio/download/",
            call. = FALSE)
  }
  if (!exists_theme_dark_windows_backup && is_rscodeio_current_windows) {

    warning("Unable to restore default RStudio menu bar styling for Windows because the corresponding backup file couldn't be found.\n",
            "The most convenient way to restore the original file at ", path_theme_dark_windows, " is to simply update or reinstall RStudio.\n",
            "RStudio stable release installers are available at https://rstudio.com/products/rstudio/download/",
            call. = FALSE)
  }

  # display message if rscodeio's menu bar styling has already been removed
  if (!exists_theme_dark_gnome_backup && !exists_theme_dark_windows_backup) {
    if (!is_rscodeio_current_gnome && !is_rscodeio_current_windows) {
      message("rscodeio's menu bar styling is already removed.")
    }
  }
}
