#' Install the rscodeio theme
#'
#' You'll need RStudio at least 1.2.x and if your RStudio
#' is installed to a default location on Windows or Linux,
#' you'll need to be running RStudio as
#' Administrator to install the menu theme files (Just required for install).
#'
#' You can elect not to install the menu theme files with `menus = FALSE`.
#'
#' @param menus if FALSE do not install the RStudio menu theme qss files.
#' @return nothing.
#' @export
install_theme <- function(menus = TRUE) {

  ## check RStudio API available
  if(!rstudioapi::isAvailable()) stop("RSCodeio must be installed from within RStudio.")

  ## check RStudio supports themes
  if(utils::compareVersion(as.character(rstudioapi::versionInfo()$version), "1.2.0") < 0)
    stop("You need RStudio 1.2 or greater to get theme support")

  ## check if menu theme is already installed and if so, uninstall first
  if (is_rscodeio_installed()) {
    uninstall_theme()
  }

  ## add the themes
  rscodeio_default_theme <- rstudioapi::addTheme(fs::path_package(package = "rscodeio",
                                                                  "resources","rscodeio.rstheme"))
                                                                  
  rstudioapi::addTheme(fs::path_package(package = "rscodeio",
                                        "resources","rscodeio_tomorrow_night_bright.rstheme"))

  ## add the custom Qt CSS
  if (menus) activate_menu_theme()

  ## activate default rscodeio theme
  rstudioapi::applyTheme(rscodeio_default_theme)
}

#' Uninstall the rscodeio theme
#'
#' @return nothing.
#' @export
uninstall_theme <- function(){

  deactivate_menu_theme()
  
  installed_rscodeio_themes <- grep(x = purrr::map_depth(.x = rstudioapi::getThemes(),
                                                         .depth = 1L,
                                                         .f = purrr::pluck("name")),
                                    pattern = "rscodeio",
                                    value = TRUE)
  
  for (theme in installed_rscodeio_themes) {
    rstudioapi::removeTheme(theme)
  }
}


#' Activate rscodeio styling in file menu.
#'
#' @return nothing.
#' @export
activate_menu_theme <- function() {

  ## Styling menus not supported on Mac or RStudio Server.
  if(host_os_is_mac() | is_rstudio_server()) return(NULL)

  if(file.exists(gnome_theme_dark_backup()) |
     file.exists(windows_theme_dark_backup())) {
      message("RSCodeio menu theme already activated. Deactivate first.")
      return(FALSE)
  }

  ## backup dark Qt themes
  file.copy(from = gnome_theme_dark(),
            to = gnome_theme_dark_backup())
  file.copy(from = windows_theme_dark(),
            to = windows_theme_dark_backup())

  ## replace with RSCodeio Qt themes
  file.copy(from = system.file(fs::path("resources","stylesheets","rstudio-gnome-dark.qss"),
                               package = "rscodeio"),
            to = gnome_theme_dark(),
            overwrite = TRUE)
  file.copy(from = system.file(fs::path("resources","stylesheets","rstudio-windows-dark.qss"),
                               package = "rscodeio"),
            to = windows_theme_dark(),
            overwrite = TRUE)
}

#' Deactivate rscodeio style in file menu.
#'
#' @return nothing.
#' @export
deactivate_menu_theme <- function(){

  ## Styling menus not supported on Mac.
  if(host_os_is_mac()) return(NULL)

  if(!file.exists(gnome_theme_dark_backup()) |
     !file.exists(windows_theme_dark_backup())) {
    message("RStudio theme backups not found. rscodeio already deactivated?")
    return(FALSE)
  }

  ## restore dark Qt themes
  file.copy(from = gnome_theme_dark_backup(),
            to = gnome_theme_dark(),
            overwrite = TRUE)
  file.copy(from = windows_theme_dark_backup(),
            to = windows_theme_dark(),
            overwrite = TRUE)

  ## delete backups
  unlink(gnome_theme_dark_backup())
  unlink(windows_theme_dark_backup())

}
