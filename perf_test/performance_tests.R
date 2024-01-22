# Preparations
library(stringdist)
library(jarosimilarity)
source("./R/prep_perf_test_data.R")
source("./R/test_infra.R")
source("./R/functions_to_test.R")
source("./R/compare_functions.R")
source("./R/compare_parameters.R")


output_folder <- "./output/"

if (!file.exists(output_folder)) {
    dir.create(output_folder)
}


set.seed(2511)
# Run 'em

# Specify functions to test
# Each function returns the number of matches. Specified in functions_to_test.R
functions <- list(
    #"stringdist" = stringdist_runner,
    "jarosimilarity" = jarosimilarity_runner    
)


compare_functions(output_folder, functions)