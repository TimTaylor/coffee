#' Create a package skeleton
#'
#' Create a package skeleton base on my preferred folder structure (hat tip to
#' Mark Van der Loo for Makefile idea)
#'
#' @param name Package name.
#' @param dir Directory to start in.
#' @param author Author.
#' @param email Email.
#' @param enter Should you move in to the package directory after creation.
#'   Only applicable in interactive sessions,
#'
#' @return Created directory (invisibly)
#'
#' @examples
#'
#' # directory setup
#' .td <- tempdir()
#' .old_wd <- setwd(.td)
#'
#' # use without entering directory
#' p1 <- new_package("my_package_1", dir = .td, enter = FALSE)
#'
#' # default usage enters directory
#' p2 <- new_factory("my_package_2", dir = .td, enter = TRUE)
#'
#' # clean up
#' unlink(f1, recursive = TRUE)
#' unlink(f2, recursive = TRUE)
#' setwd(.old_wd)
#'
#' @export
new_package <- function(
    name = "mypackage",
    dir = ".",
    author = getOption("coffee.name", "Joe Bloggs"),
    email = getOption("coffee.email", "Joe.Bloggs@missing.com"),
    enter = TRUE
) {
  # helpers
  .x <- function() message("(X)")
  .done <- function() message("(DONE)")

  # create directory structure
  root <- file.path(normalizePath(dir), name)
  message("\nCreating directory structure ...... ", appendLF = FALSE)
  if (dir.exists(root)) {
    .x()
    stop(sprintf("Directory '%s' already exists.", root))
  }

  if (!dir.create(root, recursive = TRUE, showWarnings = FALSE)) {
    .x()
    stop(sprintf("Unable to create directory '%s'.", root))
  }

  Rpath <- file.path(root, "R")
  if (!dir.create(Rpath, showWarnings = FALSE)) {
    .x()
    unlink(root, recursive = TRUE)
    stop(sprintf("Unable to create '%s' directory.", Rpath))
  }
  .done()

  # add makefile
  message("Adding Makefile ................... ", appendLF = FALSE)
  tmp <- file.copy(
    system.file("skeletons", "pkgMakefile", package = "coffee"),
    file.path(root, "Makefile")
  )
  if (!tmp) {
    .x()
    unlink(root, recursive = TRUE)
    stop("Unable to create 'Makefile'.")
  }
  .done()

  # add .gitignore
  message("Adding .gitignore ................. ", appendLF = FALSE)
  tmp <- file.copy(
    system.file("skeletons", "R.gitignore", package = "coffee"),
    file.path(root, ".gitignore")
  )
  if (!tmp) {
    .x()
    unlink(root, recursive = TRUE)
    stop("Unable to create '.gitignore'.")
  }
  .done()

  # get roxygen details
  roxy <- tryCatch(
    utils::packageVersion("roxygen2"),
    error = function(e) NULL
  )
  roxy <- if (is.null(roxy)) "7.1.2" else as.character(roxy)

  # This is slightly tweaked from utils::package.skeleton
  message("Creating DESCRIPTION .............. ", appendLF = FALSE)
  description <- file(file.path(root, "DESCRIPTION"), "wt")
  tmp <- try(
    cat("Package: ", name, "\n",
        "Type: Package\n",
        "Title: What the package does (short line)\n",
        "Version: 0.0.0.9000\n",
        "Author: ", author, "\n",
        "Maintainer: ", author, "<", email, ">\n",
        "Description: More about what it does (maybe more than one line)\n",
        "License: What license is it under?\n",
        "Encoding: UTF-8\n",
        "Roxygen: list(markdown = TRUE)\n",
        "RoxygenNote: ", roxy, "\n",
        file = description,
        sep = ""
    )
  )
  close(description)
  if (inherits(tmp, "try-error")) {
    .x()
    unlink(root, recursive = TRUE)
    stop("Unable to create 'DESCRIPTION'.")
  }
  .done()

  # Change directory
  if (interactive() && enter) {
    message("Entering package directory ........ ", appendLF = FALSE)
    tmp <- try(setwd(root))
    if (inherits(tmp, "try-error")) {
      .x()
      unlink(root, recursive = TRUE)
      stop("Unable to enter package directory (setwd failed).")
    }
    .done()
  }

  # return the root directory invisibly
  message(sprintf("\nComplete.\n\nPackage skeleton created in\n   %s", root))
  invisible(root)
}
