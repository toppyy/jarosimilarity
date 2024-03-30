clean <- function(str) {
    c(gsub('[^A-Za-z ]','',str))
}

imdb_names_fn <- "./perf_test/data/imdb_names.RData"

if (!file.exists(imdb_names_fn)) {

    cat("Manipulating imdb-names\n")
    imdb_names_raw <- readLines("./perf_test/data/name.basics.tsv", n = 1E5)
    imdb_names_raw <- imdb_names_raw[-1]

    get_name_from_record <- function(record) {
        strsplit(record, "\t")[[1]][2]
    }
    imdb_names <- sapply(
        imdb_names_raw,
        get_name_from_record,
        USE.NAMES = FALSE
        )
    rm(imdb_names_raw)

    # Strip non-ascii letters
    imdb_names <- sapply(imdb_names,clean)
    names(imdb_names) = NULL

    save(imdb_names, file = imdb_names_fn)
    cat("Done manipulating imdb-names\n")

}

if (!exists('imdb_names')) {
    load(imdb_names_fn)
}