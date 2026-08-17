#' Which distances are below the threshold
#'
#' @param dist distance matrix
#' @param thresh threshold distance
#' @export
qp_which <- function(dist, thresh) {
  result0 <- which(dist < thresh, arr.ind = TRUE, useNames = TRUE)
  result <- as.data.frame(result0)
  result[, 1] <- rownames(dist)[result[, 1]]
  result[, 2] <- colnames(dist)[result[, 2]]
  result$dist <- dist[result0]
  rownames(result) <- NULL
  result
}
