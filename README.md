
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `rlmstudio`: An R package for prompting LM studio from R

<!-- badges: start -->
<!-- badges: end -->

## Installation

You can install the development version of \`rlmstudio\`\` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("sonsoleslp/rlmstudio")
```

## Example

Load the library

``` r
library("rlmstudio")
```

Don’t forget to have your LM studio server running!

Ask for a single response

``` r
prompt_lm("Tell me a joke!")
```

    #> [1] "Why don't scientists trust atoms? Because they make up everything!"

Iterate a vector using the same prompt with variable input

``` r
country_vector <-c("Spain", "Finland", "Egypt", "Sweden")
prompt_vector <- paste("What is the capital of", country_vector,"?")
sapply(prompt_vector, prompt_lm)
```

    #>   What is the capital of Spain ? What is the capital of Finland ? 
    #>                         "Madrid"                       "Helsinki" 
    #>   What is the capital of Egypt ?  What is the capital of Sweden ? 
    #>                          "Cairo"                      "Stockholm"

Iterate through a dataframe using the same prompt with variable input

``` r
library(dplyr)
countries = data.frame(Country = c("Spain", "Finland", "Egypt", "Sweden")) %>%
  rowwise %>% mutate(Capital = prompt_lm(paste0("What is the capital of ", Country, "?")))
countries
```

    #>   Country   Capital
    #> 1   Spain    Madrid
    #> 2 Finland  Helsinki
    #> 3   Egypt     Cairo
    #> 4  Sweden Stockholm
