
plot_results <- function(results, output_path) {


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

    png(output_path, width = 680, height = 520)

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