get_rstudio_location <- function(){
  pandoc_dir <- Sys.getenv("RSTUDIO_PANDOC")

  dir_parts <-
    fs::path_split(pandoc_dir)[[1]]

  bin_ind <- which(dir_parts == "bin")

  fs::path_join(dir_parts[1:bin_ind-1])
}

gnome_theme_dark <- function() {
  fs::path(get_rstudio_location(), "resources", "stylesheets","rstudio-gnome-dark.qss")
}

gnome_theme_dark_backup <- function() {
  fs::path(get_rstudio_location(), "resources", "stylesheets","rstudio-gnome-dark-rscodeio-backup.qss")
}

windows_theme_dark <- function() {
  fs::path(get_rstudio_location(), "resources", "stylesheets","rstudio-windows-dark.qss")
}

windows_theme_dark_backup <- function() {
  fs::path(get_rstudio_location(), "resources", "stylesheets","rstudio-windows-dark-rscodeio-backup.qss")
}

host_os_is_mac <- function(){
  Sys.info()["sysname"] == "Darwin"
}
