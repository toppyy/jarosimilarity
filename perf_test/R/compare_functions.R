# Specify tests and test runner


compare_functions <- function(output_folder, functions) {

    tests <- list()
    th <- 0.1
    set1_size   <- 1000
    set2_size   <- 1000
    nthread     <- 2

    base <- list(set1_size = set1_size, set2_size = set2_size , nthread = nthread, threshold = th)

    while (th <= 0.95) {
        base["threshold"] <- th
        tests[[length(tests)+1]] <- base
        th <- th + 0.05
    }

    # Run 'em

    results <- run_tests(tests, functions,times=2)

    name <- 'compare_functions'

    write.table(
        results,
        paste0(output_folder,name,'.csv'),
        sep=",",
        row.names=F,
        quote=F
    )

    thresholds  <- unique(results$threshold)
    barplotdata <- matrix(ncol = nrow(results)/2 ,nrow= length(unique(results$name)))

    measure_var <- 'elapsed_times_mean'

    col <- 1
    for (th in thresholds) {
        barplotdata[,col] <- results[results$threshold == th,measure_var]
        col <- col + 1
    }

    colnames(barplotdata) <- thresholds
    rownames(barplotdata) <- results$name[1:2]

    png(paste0(output_folder,name,'.png'), width = 680, height = 520)

    barplot(barplotdata, 
            col=c('red','blue'), 
            border="white", 
            font.axis=2, 
            beside=T,        
            xlab="Threshold for match", 
            ylab=paste0("Seconds (",measure_var,")"),
            font.lab=2,
            ylim=c(0, max(results$user_times_mean) * 1.3)
    )
    box()
    grid(
        col='black'
    )
    
    legend(
        "topright",
        col=c('red','blue'),
        lty=1,
        legend=rownames(barplotdata),
        bg="white"

    )
    title(
        paste0(
            set1_size,
            " vs. ",
            set2_size,
            " comparisons using ",
            nthread,
            " threads"
        )
    )

    x <- dev.off()

}