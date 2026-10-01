#' Which distances are below the threshold
#'
#' @param dist distance matrix
#' @param thresh threshold distance
#' @importFrom dplyr arrange
#' @importFrom rlang .data
#' @export
qp_which <- function(dist, thresh) {
  result0 <- which(dist < thresh, arr.ind = TRUE, useNames = TRUE)
  result1 <- as.data.frame(result0)
  result <- data.frame(
    id1 = result1[, 1],
    id2 = result1[, 2],
    file1 = rownames(dist)[result1[, 1]],
    file2 = colnames(dist)[result1[, 2]],
    dist = round(dist[result0], 3)
  )

  result |> arrange(.data$dist)
}
