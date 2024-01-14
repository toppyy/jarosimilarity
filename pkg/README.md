
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jarosimilarity

<!-- badges: start -->

<!-- badges: end -->

The goal of jarosimilarity is to ind approximate matches in two
(multi-)sets of strings using the JaroSimilarity algorithm.

## Installation

You can install the development version of regexcite from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("toppyy/jarosimilarity")
```

## Example

How to find matches between two sets of strings:

``` r
library(jarosimilarity)

set1 <- c('monkey','giraffe')
set2 <- c('donkey','Giraffe','giraff','monkeyz','monks','garaff')

matches1 <- jarosimilarity(a=set1,b=set2,th=0.8)
print(matches1)
#>         a       b
#> 1  monkey  donkey
#> 2  monkey monkeyz
#> 3  monkey   monks
#> 4 giraffe Giraffe
#> 5 giraffe  giraff

matches2 <- jarosimilarity(a=set1,b=set2,th=0.9)
print(matches2)
#>         a       b
#> 1  monkey monkeyz
#> 2 giraffe Giraffe
#> 3 giraffe  giraff
```
