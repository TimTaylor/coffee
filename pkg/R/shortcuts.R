tt <- ""
class(tt) <- "__tt__"

#' Test shortcut
#' @export
tt <- tt

#' @export
print.__tt__ <- function(x, ...) {
    dir <- if (file.exists("Makefile")) "pkg" else "."
    tinytest::build_install_test(dir)
}



# devtools load all shortcut ----------------------------------------------
ll <- ""
class(ll) <- "__ll__"

#' @export
print.__ll__ <- function(x, ...) {
    dir <- if (file.exists("Makefile")) "pkg" else "."
    devtools::load_all(dir)
}

#' @export
ll <- ll

# devtools document shortcut ----------------------------------------------
dd <- ""
class(dd) <- "__dd__"

#' @export
print.__dd__ <- function(x, ...) {
    dir <- if (file.exists("Makefile")) "pkg" else "."
    devtools::document(dir)
}

#' @export
dd <- dd
