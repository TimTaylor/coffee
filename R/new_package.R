#' Create a package skeleton
#'
#' Create a package skeleton base on my preferred folder structure (hat tip to
#' Mark Van der Loo)
#'
#' @param name Package name.
#' @param dir Directory to start in.
#' @param author Author.
#' @param email Email.
#'
#' @return Created directory (invisibly)
#' @export
new_package <- function(
    name = "mypackage",
    dir = ".",
    author = getOption("coffee.name", "Joe Bloggs"),
    email = getOption("coffee.email", "Joe.Bloggs@missing.com")
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

    if (!dir.create(file.path(root, "pkg"), showWarnings = FALSE)) {
        .x()
        unlink(root, recursive = TRUE)
        stop("Unable to create 'pkg' directory.")
    }

    if (!dir.create(file.path(root, "pkg", "R"), showWarnings = FALSE)) {
        .x()
        unlink(root, recursive = TRUE)
        stop("Unable to create 'pkg/R' directory.")
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
    description <- file(file.path(root, "pkg", "DESCRIPTION"), "wt")
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
        stop("Unable to create 'pkg/DESCRIPTION'.")
    }
    .done()

    # return the root directory invisibly
    message(sprintf("\nComplete. Skeleton created in %s.", root))
    invisible(root)
}
