path_theme_dir <- function() {

  ## We shouldn't get here on mac
  if (is_macos()) stop("QSS Stylesheets are not used on Mac.")

  rstudio_dirs <- list(
    pandoc_dir = Sys.getenv("RSTUDIO_PANDOC"),
    msys_ssh_dir = Sys.getenv("RSTUDIO_MSYS_SSH"),
    rstudio_win_utils_dir = Sys.getenv("RSTUDIO_WINUTILS"),
    rs_postback_path = Sys.getenv("RS_RPOSTBACK_PATH"),
    rmarkdown_mathjax_path = Sys.getenv("RMARKDOWN_MATHJAX_PATH")
  )

  extract_rstudio_path_parts <- function(path) {
    dir_parts <- fs::path_split(path)[[1L]]
    rstudio_ind <- which(dir_parts %in% c("RStudio", "rstudio"))
    if (length(rstudio_ind) != 1L) return(NULL)

    dir_parts[seq(rstudio_ind)]
  }

  potential_paths <-
    Filter(function(path_parts) {
      !is.null(path_parts) && dir.exists(fs::path_join(c(path_parts,
                                                         "resources",
                                                         "stylesheets")))},
      lapply(rstudio_dirs, extract_rstudio_path_parts)
    )

  if (length(potential_paths) == 0L) {
    stop("Unable to determine RStudio installation path.",
         call. = FALSE)
  }

  ## return first path that existed
  fs::path_join(c(potential_paths[[1L]], "resources", "stylesheets"))
}

path_theme_dark_gnome <- function() {
  fs::path(path_theme_dir(), "rstudio-gnome-dark.qss")
}

path_theme_dark_gnome_backup <- function() {
  fs::path(path_theme_dir(), "rstudio-gnome-dark-rscodeio-backup.qss")
}

path_theme_dark_windows <- function() {
  fs::path(path_theme_dir(), "rstudio-windows-dark.qss")
}

path_theme_dark_windows_backup <- function() {
  fs::path(path_theme_dir(), "rstudio-windows-dark-rscodeio-backup.qss")
}

is_macos <- function() {
  unname(Sys.info()["sysname"] == "Darwin")
}

is_linux <- function() {
  unname(Sys.info()["sysname"] == "Linux")
}

is_rstudio_server <- function() {
  rstudioapi::versionInfo()$mode == "server"
}

is_rscodeio_installed <- function() {
  !is.null(rstudioapi::getThemes()[["rscodeio"]]) || !is.null(rstudioapi::getThemes()[["tomorrow night bright (rscodeio)"]])
}

is_rscodeio_menu_theme <- function(path_theme) {
  grepl(x = readLines(con = path_theme,
                      n = 1L),
        pattern = "rscodeio")
}

installed_rscodeio_editor_themes <- function() {
  grep(x = purrr::map_depth(.x = rstudioapi::getThemes(),
                            .depth = 1L,
                            .f = purrr::pluck("name")),
       pattern = "rscodeio",
       value = TRUE)
}

process_menu_themes <- function(backup_gnome = FALSE,
                                backup_windows = FALSE,
                                override_gnome = FALSE,
                                override_windows = FALSE,
                                restore_gnome = FALSE,
                                restore_windows = FALSE) {

  # return early if nothing to do
  if (!any(backup_gnome,
           backup_windows,
           override_gnome,
           override_windows,
           restore_gnome,
           restore_windows)) return(NULL)

  path_theme_dark_gnome <- path_theme_dark_gnome()
  path_theme_dark_gnome_backup <- path_theme_dark_gnome_backup()
  path_theme_dark_gnome_rscodeio <- fs::path_package(package = "rscodeio",
                                                     "resources", "stylesheets", "rstudio-gnome-dark.qss")
  path_theme_dark_windows <- path_theme_dark_windows()
  path_theme_dark_windows_backup <- path_theme_dark_windows_backup()
  path_theme_dark_windows_rscodeio <- fs::path_package(package = "rscodeio",
                                                       "resources", "stylesheets", "rstudio-windows-dark.qss")

  ## interactively ask for administrator credentials on Linux
  if (is_linux()) {

    cmd_backup_gnome <- glue::glue('sudo cp "{path_theme_dark_gnome}" "{path_theme_dark_gnome_backup}" ; ')
    cmd_backup_windows <- glue::glue('sudo cp "{path_theme_dark_windows}" "{path_theme_dark_windows_backup}" ; ')
    cmd_override_gnome <- glue::glue('sudo cp "{path_theme_dark_gnome_rscodeio}" "{path_theme_dark_gnome}" ; ')
    cmd_override_windows <- glue::glue('sudo cp "{path_theme_dark_windows_rscodeio}" "{path_theme_dark_windows}" ; ')
    cmd_restore_gnome <- glue::glue('sudo cp "{path_theme_dark_gnome_backup}" "{path_theme_dark_gnome}" && sudo rm "{path_theme_dark_gnome_backup}" ; ')
    cmd_restore_windows <- glue::glue('sudo cp "{path_theme_dark_windows_backup}" "{path_theme_dark_windows}" && sudo rm "{path_theme_dark_windows_backup}" ; ')

    pkexec_cmd_args <- paste0("env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c '",
                              if (backup_gnome) cmd_backup_gnome,
                              if (backup_windows) cmd_backup_windows,
                              if (override_gnome) cmd_override_gnome,
                              if (override_windows) cmd_override_windows,
                              if (restore_gnome) cmd_restore_gnome,
                              if (restore_windows) cmd_restore_windows,
                              "'")

    return_code <- system2(command = "pkexec",
                           args = pkexec_cmd_args)

    # print instructive warnings if something went wrong
    if (return_code != 0L) {

      common_warning <- ' of default RStudio menu bar styling failed. As a workaround, you can manually run the following in a shell as root (sudo):\n\n'

      if (backup_gnome) warning('Backup', common_warning, cmd_backup_gnome, call. = FALSE)
      if (backup_windows) warning('Backup', common_warning, cmd_backup_windows, call. = FALSE)
      if (override_gnome) warning('Installation', common_warning, cmd_override_gnome, call. = FALSE)
      if (override_windows) warning('Installation', common_warning, cmd_override_windows, call. = FALSE)
      if (restore_gnome) warning('Restoral', common_warning, cmd_restore_gnome, call. = FALSE)
      if (restore_windows) warning('Restoral', common_warning, cmd_restore_windows, call. = FALSE)
    }

  } else {
    ## other OS' like Windows and macOS need RStudio being run as administrator
    if (all(fs::file_access(path = c(if (override_gnome || restore_gnome) path_theme_dark_gnome,
                                     if (override_windows || restore_windows) path_theme_dark_windows,
                                     if (backup_gnome || restore_gnome) path_theme_dark_gnome_backup,
                                     if (backup_windows || restore_windows) path_theme_dark_windows_backup,
                                     if (restore_gnome) path_theme_dark_gnome_rscodeio,
                                     if (restore_windows) path_theme_dark_windows_rscodeio),
                            mode = "write"))) {

      list(c(path_theme_dark_gnome, path_theme_dark_gnome_backup)[backup_gnome],
           c(path_theme_dark_windows, path_theme_dark_windows_backup)[backup_windows],
           c(path_theme_dark_gnome_rscodeio, path_theme_dark_gnome)[override_gnome],
           c(path_theme_dark_windows_rscodeio, path_theme_dark_gnome)[override_windows],
           c(path_theme_dark_gnome_backup, path_theme_dark_gnome)[restore_gnome],
           c(path_theme_dark_windows_backup, path_theme_dark_gnome)[restore_windows]) %>%
        purrr::walk(~ {
          if (length(.x)) {
            fs::file_copy(path = .x[1L],
                          new_path = .x[2L],
                          overwrite = TRUE)
          }
        })

      if (restore_gnome) fs::file_delete(path_theme_dark_gnome_backup)
      if (restore_windows) fs::file_delete(path_theme_dark_windows_backup)

    } else {

      begin_warning <- paste("Backup"[backup_gnome || backup_windows],
                             "Installation"[override_gnome || override_windows],
                             "Restoral"[restore_gnome || restore_windows],
                             sep = "/")

      warning(substr(begin_warning,
                     start = 1L,
                     stop = nchar(begin_warning) - 1L),
              " of default RStudio menu bar styling impossible due to insufficient user rights. RStudio must be run as administrator for this to work.",
              call. = FALSE)
    }
  }
}
