#' Devtools and tinytest wrappers
#'
#' Wrappers functions around devtools and tinytest functionality adapted to my
#' preferred package structure
#'
#' @name devtools
NULL

#' @rdname devtools
#' @export
test_package <- function() {
    dir <- if (file.exists("Makefile")) "pkg" else "."
    if (file.exists(file.path(dir, "tests", "tinytest.R"))) {
        tinytest::build_install_test(dir)
    } else if (file.exists(file.path(dir, "tests", "testthat.R"))) {
        devtools::test(dir)
    } else {
        stop()
    }
}

#' @rdname devtools
#' @export
load_package <- function() {
    dir <- if (file.exists("Makefile")) "pkg" else "."
    devtools::load_all(dir)
}

#' @rdname devtools
#' @export
document_package <- function() {
    dir <- if (file.exists("Makefile")) "pkg" else "."
    devtools::document(dir)
}

#' @rdname devtools
#' @export
install_package <- function() {
    dir <- if (file.exists("Makefile")) "pkg" else "."
    devtools::install(dir)
}

#' @rdname devtools
#' @export
check_package <- function() {
    dir <- if (file.exists("Makefile")) "pkg" else "."
    devtools::check(dir)
}
