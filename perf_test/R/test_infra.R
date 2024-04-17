
## Test runner

test_a_function <- function(set1, set2, name, func, threshold, nthread, times = 1) {
    if (times == 0) {
        stop("Why do you want to test zero 'times'?")
    }
    cat(name)
    cat(":\t")

    user_times      <- rep(0,times)
    elapsed_times   <- rep(0,times)

    time <- rep(0,5)

    for (i in 1:times) {
        tmp <- system.time(matches <- func(set1, set2, threshold, nthread))
        user_times[i] <- tmp[1]
        elapsed_times[i] <- tmp[3]
        time <- time + tmp
    }
    time <- time / times

    decimals <- 3
    cat(
        paste(
            "User-time avg: ",format(round(time[1],decimals),nsmall=decimals),
            ". Elapsed avg: ",  format(round(mean(elapsed_times),decimals), nsmall=decimals),
            ". Matches: ", matches
            ,"\n"
        )
    )


    results <- list(
        c(
            "name" = name,
            "set1_size" = length(set1),
            "set2_size" = length(set2),
            "time_user" = round(time[1], 5),
            "time_self" = round(time[2], 5),
            "time_elapsed" = round(time[3], 5),
            "matches" = matches,
            "nthread" = nthread,
            "threshold" = threshold,
            "times" = times,
            "user_times_mean" = mean(user_times),
            "user_times_sd"   = sd(user_times),
            "elapsed_times_mean" = mean(elapsed_times)
        )
    )
    return(results)
}


clean_names <- function(n) {
    n <- strsplit(n,'\\.')[[1]]
    n[length(n)]
}

run_tests <- function(tests, functions, times = 1) {

    results <- list()

    for (test in tests) {
        set1 <- make_test_dataset(test$set1_size)
        set2 <- make_test_dataset(test$set2_size)


        nthread <- test$nthread
        threshold <- test$threshold

        for (fn in names(functions)) {
            results <- append(results,test_a_function(set1, set2, fn, functions[[fn]], threshold, nthread, times = times ))
        }

    }

    result_df <- data.frame(do.call('rbind',results))
    names(result_df) <- sapply(names(result_df), clean_names)

    result_df$set1_size <- as.integer(result_df$set1_size)
    result_df$set2_size <- as.integer(result_df$set2_size)
    result_df$elapsed_times_mean   <- as.numeric(result_df$elapsed_times_mean)
    result_df$user_times_mean       <- as.numeric(result_df$user_times_mean)
    result_df$user_times_sd         <- as.numeric(result_df$user_times_sd)

    return(result_df)
}



## Test dataset

make_test_dataset <- function(size) sample(imdb_names, size, replace = TRUE)
