# Preparations
library(stringdist)
library(jarosimilarity)
source("./perf_test/R/prep_perf_test_data.R")
source("./perf_test/R/test_infra.R")
source("./perf_test/R/functions_to_test.R")
source("./perf_test/R/compare_functions.R")
source("./perf_test/R/compare_parameters.R")


output_folder <- "./perf_test/output/"

if (!file.exists(output_folder)) {
    dir.create(output_folder)
}


set.seed(2511)
# Run 'em

# Specify functions to test
# Each function returns the number of matches. Specified in functions_to_test.R
functions <- list(
    "stringdist" = stringdist_runner,
    "jarosimilarity" = jarosimilarity_runner    
)


compare_functions(output_folder, functions)