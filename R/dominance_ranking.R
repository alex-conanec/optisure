#' Dominance ranking
#'
#' Use the pairwisecomparison function to attribute a rank of individu belonging
#' to the same front which mean that they are not comparable to each other.
#' The lowest the rank the best is the individu
#'
#' @param X a matrix/data.frame of all the selected individus evaluation
#'
#' @param sens vector of size NCOL(X) containing either "min" or "max"
#'  to choose how to optimize each objectif.
#'
#' @return a vecteur of rank associated with the individus of X
#'
#' @examples
#' sum(1:10)
#' @importFrom magrittr %>%
#' @export

dominance_ranking <- function(X, sens){

    res <- rep(NA, NROW(X))
    rank <- 1
    PwCp <- pairwise_comparison(X, sens)
    last_points <- 1:length(PwCp)

    while (any(is.na(res))){
        temp <-
            sapply(last_points, function(i){
                if (PwCp[[i]]$dominated_count == 0) i
            }) %>% unlist()

        res[temp] <- rank

        for (j in temp){
            for (k in PwCp[[j]]$dominating_index){
                PwCp[[k]]$dominated_count <- PwCp[[k]]$dominated_count - 1
            }
        }

        rank <- rank + 1
        last_points <- last_points[!last_points %in% temp]
    }
    res
}
