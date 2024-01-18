library(jarosimilarity)

# Tests that jarosimilarity is calculated correctly.
# Can only test if the function returns a match.
# Needless to say, might benefit from further tests..

tests <- list(
     list( strs=c("DWAYNE", "DUANE"), expected_to_match = TRUE, threshold = 0.822),
     list( strs=c("MARTHA", "MARHTA"), expected_to_match = TRUE, threshold = 0.944),
     list( strs=c("DIXON", "DICKSONX"), expected_to_match = TRUE, threshold = 0.766),
     list( strs=c("JELLYFISH", "SMELLYFISH"), expected_to_match = TRUE, threshold = 0.89),
     list( strs=c("JELLYFISH", "SMELLYFISH"), expected_to_match = FALSE, threshold = 0.95)
)

for (test in tests) {
    a <- test$strs[1]
    b <- test$strs[2]
    observed <- jarosimilarity(a, b, test$threshold, 1)
    
    expected_length <- ifelse(test$expected_to_match, 1, 0)

    if (nrow(observed) != expected_length) {
        stop(paste("Test failed for:", a, b, ". Returned",nrow(observed), ", expected", expected_length))
        
    } else {
        cat(paste("Test for",a,"vs","b PASSED.\n"))
    }
}

