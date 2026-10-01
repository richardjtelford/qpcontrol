#' Pairwise comparison of files
#' @param txt_dir directory where the extracted code is
#' @importFrom textreuse TextReuseCorpus tokenize_ngrams skipped
#'                       pairwise_compare jaccard_dissimilarity
#' @export

qp_pairwise <- function(txt_dir) {
  corpus <- TextReuseCorpus(
    dir = txt_dir,
    tokenizer = tokenize_ngrams, n = 5
  )

  pairwise <- pairwise_compare(corpus, jaccard_dissimilarity)
  attr(pairwise, "skipped") <- skipped(corpus)
  pairwise
}
