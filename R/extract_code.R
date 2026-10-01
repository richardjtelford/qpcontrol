#' Extract code from quarto files
#' @param html_dir Directory with html files or path to zip file.
#' @param txt_dir Directory to fill with extracted code.
#' @importFrom purrr walk
#' @importFrom stringr str_replace
#' @importFrom utils unzip
#' @examples
#' d <- system.file("extdata", package = "qpcontrol")
#' tmp <- tempdir()
#' qp_extract(html_dir = d, txt_dir = tmp)
#'
#' @export


qp_extract <- function(html_dir, txt_dir) {
  if (fs::is_file(html_dir)) {
    if (tools::file_ext(html_dir) != "zip") {
      stop("html_dir must be a directory or a zip file")
    }
    tmp <- file.path(tempdir(), basename(html_dir))
    on.exit(fs::dir_delete(html_dir))
    fs::dir_create(tmp)
    unzip(html_dir, exdir = tmp)
    html_dir <- tmp
  }

  # check for unexpected files types
  qp_unexected_filetype(html_dir)
  # extract
  files <- list.files(html_dir, pattern = "\\.html$", full.names = TRUE)
  files |> walk(\(f) {
    out <- str_replace(basename(f), pattern = "\\.html$", replacement = ".qmd")
    qp_extract_file(f) |>
      writeLines(con = file.path(txt_dir, out))
  })
  # rescue
  qp_rescue(html_dir, txt_dir)
}


#' Extract code a quarto file
#' @param file html file to process
#' @importFrom rvest read_html html_elements html_text2
#' @examples
#' f <- system.file("extdata/q3.html", package = "qpcontrol")
#' qp_extract_file(f) |>
#'   cat()
#' @export


qp_extract_file <- function(file) {
  read_html(file) |>
    html_elements("pre.sourceCode.markdown.code-with-copy") |>
    html_text2() |>
    utils::tail(1)
}


#' Rescue .qmd files
#' @description
#' Some students will submit their qmd file, either because they cannot render it,
#' or because they just submit the wrong file.
#'  This function copies these files into directory with the extracted qmd files,
#'  but ignores qmd files when the student has also submitted an html file.
#' @param html_dir Directory with html files to process.
#' @param txt_dir Directory with processed qmd files
#' @importFrom tools file_path_sans_ext
#' @importFrom stringr str_detect str_extract
#' @export

qp_rescue <- function(html_dir, txt_dir) {
  # get list of qmd files
  qmd_list <- list.files(path = html_dir, pattern = "\\.qmd$", full.names = TRUE)
  qmd_short <- qmd_list |>
    basename() |>
    file_path_sans_ext()
  # get list of html files
  html_list <- list.files(path = html_dir, pattern = "\\.html$", full.names = TRUE) |>
    basename() |>
    file_path_sans_ext()

  # qmd files without matching html
  # check for canvas filenames
  if (all(str_detect(qmd_short, "^[:alpha:]*_(LATE_)?\\d*"))) {
    userid <- function(str) {
      stringr::str_extract(str, "^[:alpha:]*_(LATE_)?\\d*")
    }
    qmd_list <- qmd_list[userid(qmd_short) %notin% userid(html_list)]
  } else {
    qmd_list <- qmd_list[qmd_short %notin% html_list]
  }

  if (length(qmd_list) > 0) {
    fs::file_copy(qmd_list, file.path(txt_dir, basename(qmd_list)))
    message(paste(basename(qmd_list), collapse = "\n"), "\nonly available as qmd files")
  }
}


#' Alert for unexpected filetypes
#' @param html_dir Directory with html files to process.
#'
qp_unexected_filetype <- function(html_dir) {
  files <- list.files(html_dir)
  unexpected_files <- files[tools::file_ext(files) %notin% c("qmd", "html")]
  if (length(unexpected_files) > 0) {
    message("Unexpected filestypes for files\n", paste(basename(unexpected_files), collapse = "\n"))
  }
}
