#' Make a report of text similarity
#' @param html_dir Directory contraining html files
#' @param threshold Consider dissimilarities below this threshold
#' @param \dots extra arguments for quarto_render
#' @importFrom quarto quarto_render
#' @export
#'
qp_report <- function(html_dir, threshold = 0.7, ...) {
  template <- system.file("report/report.qmd", package = "qpcontrol")
  on.exit(fs::file_delete(file.path(getwd(), "qp_report.qmd")))
  fs::file_copy(path = template, new_path = file.path(getwd(), "qp_report.qmd"))
  quarto_render(input = "qp_report.qmd", execute_params = list(html_dir = html_dir, threshold = threshold), ...)
}
