#' jarosimilarity
#' 
#' Find approximate matches in two (multi-)sets of strings using the JaroSimilarity algorithm.
#'
#'
#' @param a a character vector
#' @param b a character vector
#' @param th threshold for matching. Strings are consired to match if jarosimilarity is > th
#' @param nthreads the number of threads to use. If you have multiple cores at your disposal, you can set this to do matching in parallel.
#' It is _not_ set automatically to match the number of cores in your machine.
#' 
#' @details
#' TBA
#'  
#' 
#' @return
#' Returns a list containing two vectors of integers that indexes to the vectors given as parameters (that is, 'a' and 'b').
#' Corresponding elements in the vectors describe a match.
#' 
#' 
#' @useDynLib jarosimilarity, .registration=TRUE
#' @export
jarosimilarity <- function(a, b, th=0.7, nthreads=1) {
    max_len = max(max(nchar(a)), max(nchar(b)))
    matches = .Call("c_jarosimilarity", a, b, th, max_len, nthreads, PACKAGE="jarosimilarity")
    evens   = ( seq_along(matches) %% 2 ) == 0
    data.frame(
        "a" = a[matches[!evens]],
        "b" = b[matches[evens]]
    )
}

