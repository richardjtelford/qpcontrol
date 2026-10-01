#' Show difference between files
#' @param result One row of the results from `qp_which()`.
#' @param txt_dir The directory containing the extracted txt files
#'
#' @importFrom diffr diffr
#' @export

qp_diffr <- function(result, txt_dir) {
  file1 <- file.path(txt_dir, paste0(result$file1, ".qmd"))
  file2 <- file.path(txt_dir, paste0(result$file2, ".qmd"))
  diffr(file1 = file1, file2 = file2, before = result$file1, after = result$file2)
}
