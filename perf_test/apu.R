# Preparations
library(stringdist)
library(jarosimilarity)
source("./R/prep_perf_test_data.R")
source("./R/test_infra.R")
source("./R/functions_to_test.R")
source("./R/compare_functions.R")
source("./R/compare_parameters.R")


set.seed(2511)
# Run 'em

set1 <- make_test_dataset(1000)
set2 <- make_test_dataset(1E5)

th <- 0.8
nthread <- 2
done <- FALSE

for (i1 in 1:length(set1)) {

    sd_matches <- stringdist::stringdist(set1[i1], set2, method = "jw", useBytes = TRUE, nthread = nthread) < (1-th)
    tb_matches <- jarosimilarity(set1[i1],set2,th,nthread)

    if (sum(sd_matches) > nrow(tb_matches)) {

        for (i2 in 1:length(set2)) {
            sd_matches <- stringdist::stringdist(set1[i1], set2[i2], method = "jw", useBytes = TRUE, nthread = nthread) < (1-th)
            tb_matches <- jarosimilarity(set1[i1],set2[i2],th,nthread)

            if (sd_matches && nrow(tb_matches) == 0) {
                print(tb_matches)
                print(paste(set1[i1]," vs. ",set2[i2]))
                # done <- TRUE
                break
            }

        }
    }
    if (done) {
        break
    }
}

