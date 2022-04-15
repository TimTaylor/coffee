#' Easy quote names
#'
#' @param ... Unquoted names (separated by commas) that you wish to quote;
#'   empty arguments (e.g. third item in `one,two,,four`) will be returned as
#'   blanks.
#' @param .clip Should the code to generate the constructed character vector be
#'   copied to your system clipboard; defaults to TRUE.
#'
#' @note The system clipboard will only be used in interactive sessions.
#'   Outer whitespace is automatically trimmed.
#'
#' @return a character vector
#'
#' @examples
#' cc(dale, audrey, laura, hawk)
#'
#' @author Tim Taylor
#'
#' @importFrom utils capture.output
#' @export
cc <- function(..., .clip = TRUE) {
    res <- vapply(substitute(list(...)), deparse, character(1))
    res <- res[-1]
    if (interactive() && .clip && clipr::clipr_available()) {
        clipr::write_clip(capture.output(dput(res, control = "all")))
    }
    res
}
