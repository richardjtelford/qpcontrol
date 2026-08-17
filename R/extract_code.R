#' Extract code from quarto files
#' @param html_dir Directory with html files
#' @param txt_dir Directory to fill with extracted code.
#' @importFrom purrr walk
#' @importFrom stringr str_replace
#' @examples
#' d <- system.file("extdata", package = "qpcontrol")
#' tmp <- tempdir()
#' qp_extract(html_dir = d, txt_dir = tmp)
#'
#' @export


qp_extract <- function(html_dir, txt_dir) {
  files <- list.files(html_dir, pattern = "\\.html$", full.names = TRUE)
  files |> walk(\(f) {
    out <- str_replace(basename(f), pattern = "\\.html$", replacement = ".qmd")
    qp_extract_file(f) |>
      writeLines(con = file.path(txt_dir, out))
  })
}


#' Extract code a quarto file
#' @param file html file to process
#' @importFrom rvest read_html html_element html_text2
#' @examples
#' f <- system.file("extdata/q3.html", package = "qpcontrol")
#' qp_extract_file(f) |>
#'   cat()
#' @export


qp_extract_file <- function(file) {
  read_html(file) |>
    html_element("pre.sourceCode.markdown.code-with-copy") |>
    html_text2()
}
