install_theme <- function() {

  ## check RStudio API available
  if(!rstudioapi::isAvailable()) stop("RSCodeio must be installed from within RStudio.")

  ## check RStudio supports themes
  if(utils::compareVersion(as.character(rstudioapi::versionInfo()$version), "1.2.0") < 0)
    stop("You need RStudio 1.2 or greater to get theme support")

  ## check if menu theme already in use and deactivate
  if(file.exists(gnome_theme_dark_backup()) |
     file.exists(windows_theme_dark_backup())) {
    deactivate_menu_theme()
  }

  ## add the theme
  rscodeio_theme <- rstudioapi::addTheme(system.file(fs::path("resources","rscodeio.rstheme"),
                                                     package = "rscodeio"))

  ## add the cusom Qt css
  activate_menu_theme()

  rstudioapi::applyTheme(rscodeio_theme)
}


activate_menu_theme <- function() {

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
            to = gnome_theme_dark())
  file.copy(from = system.file(fs::path("resources","stylesheets","rstudio-windows-dark.qss"),
                               package = "rscodeio"),
            to = windows_theme_dark())
}

deactivate_menu_theme <- function(){

  if(!file.exists(gnome_theme_dark_backup()) |
     !file.exists(windows_theme_dark_backup())) {
    message("RSCodeio theme backups not found. Activate first.")
    return(FALSE)
  }

  ## restore dark Qt themes
  file.copy(from = gnome_theme_dark_backup(),
            to = gnome_theme_dark,
            overwrite = TRUE)
  file.copy(from = windows_theme_dark_backup(),
            to = windows_theme_dark(),
            overwrite = TRUE)

  ## delete backups
  unlink(gnome_theme_dark_backup())
  unlink(windows_theme_dark_backup())

  }

