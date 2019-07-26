get_stylesheets_location <- function(){

  ## We shouldn't get here on mac
  if(host_os_is_mac()) stop("Qss Stylesheets are not used on Mac")

  rstudio_dirs <- list(
    pandoc_dir = Sys.getenv("RSTUDIO_PANDOC"),
    msys_ssh_dir = Sys.getenv("RSTUDIO_MSYS_SSH"),
    rstudio_win_utils_dir = Sys.getenv("RSTUDIO_WINUTILS"),
    rs_postback_path = Sys.getenv("RS_RPOSTBACK_PATH"),
    rmarkdown_mathjax_path = Sys.getenv("RMARKDOWN_MATHJAX_PATH")
  )

  extract_rstudio_path_parts <- function(path){
    dir_parts <- fs::path_split(path)[[1]]
    rstudio_ind <- which(dir_parts %in% c("RStudio","rstudio"))
    if(length(rstudio_ind) != 1) return(NULL)

    dir_parts[seq(rstudio_ind)]
  }

  potential_paths <-
    Filter(function(path_parts) {
           !is.null(path_parts) && dir.exists(fs::path_join(c(path_parts,
                                              "resources",
                                              "stylesheets")))
          },
          lapply(rstudio_dirs, extract_rstudio_path_parts)
    )

  if(length(potential_paths) == 0) stop("Could not find location of your RStudio installation.")

  ## return first path that existed
  fs::path_join(c(potential_paths[[1]], "resources", "stylesheets"))

}

gnome_theme_dark <- function() {
  fs::path(get_stylesheets_location(),"rstudio-gnome-dark.qss")
}

gnome_theme_dark_backup <- function() {
  fs::path(get_stylesheets_location(), "rstudio-gnome-dark-rscodeio-backup.qss")
}

windows_theme_dark <- function() {
  fs::path(get_stylesheets_location(),"rstudio-windows-dark.qss")
}

windows_theme_dark_backup <- function() {
  fs::path(get_stylesheets_location(),"rstudio-windows-dark-rscodeio-backup.qss")
}

host_os_is_mac <- function() {
  Sys.info()["sysname"] == "Darwin"
}

is_rstudio_server <- function() {
  rstudioapi::versionInfo()$mode == "server"
}

rscodeio_installed <- function() {
 !is.null(rstudioapi::getThemes()$rscodeio)
}
