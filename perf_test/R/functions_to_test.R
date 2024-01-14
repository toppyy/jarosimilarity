stringdist_runner <- function(set1,set2,threshold,nthread) {
    
    matches <- 0
    for (i1 in seq_along(set1)) {
        dist <- stringdist(set1[i1], set2, method = "jw", useBytes = TRUE, nthread = nthread)
        matches <- matches + sum(dist <= (1-threshold))
    }
    return(matches)
}

jarosimilarity_runner <- function(set1,set2,threshold,nthread) nrow(jarosimilarity(set1,set2,threshold,nthread))
