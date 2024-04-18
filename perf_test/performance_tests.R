# Preparations
library(stringdist)
library(jarosimilarity)
source("./perf_test/R/prep_perf_test_data.R")
source("./perf_test/R/run_tests.R")
source("./perf_test/R/functions_to_test.R")
source("./perf_test/R/plot_results.R")

set.seed(2511)

output_folder   <- "./perf_test/output/"
plot_filename   <- paste0(output_folder, "compare_functions.png")
table_filename  <- paste0(output_folder, "compare_functions.csv")

if (!file.exists(output_folder)) {
    dir.create(output_folder)
}

# Specify functions to test
# Each function returns the number of matches. Specified in functions_to_test.R
functions <- list(
    "stringdist" = stringdist_runner,
    "jarosimilarity" = jarosimilarity_runner    
)

# Create tests

tests <- list()
th          <- 0.1
th_inc      <- 0.05
th_max      <- 0.95

set1_size   <- 100
set2_size   <- 100
nthread     <- 2

base <- list(set1_size = set1_size, set2_size = set2_size , nthread = nthread, threshold = th)

while (th <= th_max) {
    base["threshold"] <- th
    tests[[length(tests)+1]] <- base
    th <- th + th_inc
}

# Run the tests for specified functions
results <- run_tests(tests, functions, iterations_per_test = 2)

# Store results and create plots

write.table(
    results,
    table_filename,
    sep=",",
    row.names=F,
    quote=F
)

plot_results(results, plot_filename)