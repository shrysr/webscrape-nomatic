## Loading Libraries ---
library(dplyr)
library(rvest)
library(purrr)
library(fs)
library(xopen)
library(furrr)
library(stringr)

## Source functions
source("functions.R")


## Prefix URL
all_products_prefix_url = "https://www.nomatic.com/collections/all-products?page="
individual_product_prefix_url = "https://www.nomatic.com/products/"


## Number of pages to scrape
## The number of pages was manually obtained by inspection
page_range <- seq(1:6)


#########################################################

all_product_url_tbl <- page_range %>% map_df(~ consolidate_all_links_on_a_page(
                        all_products_prefix_url = all_products_prefix_url,
                        page_no = .x,
                        individual_product_prefix_url = individual_product_prefix_url ))




############################################################################
### Obtaininng individual product features
################################

## We'll start with a limited number of products: 
## - https://www.nomatic.com/products/the-nomatic-travel-pack
## - https://www.nomatic.com/products/nomatic-toiletry-bag
## - https://www.nomatic.com/products/the-nomatic-backpack
## - https://www.nomatic.com/products/nomatic-messenger-bag



url_list <- c("https://www.nomatic.com/products/the-nomatic-travel-pack",
"https://www.nomatic.com/products/nomatic-toiletry-bag",
"https://www.nomatic.com/products/the-nomatic-backpack",
"https://www.nomatic.com/products/nomatic-messenger-bag")


product_url_tbl <-tibble(product_url = url_list)


## Constructing a tibble parsing product name from the above URL's
conditioned_product_url_tbl <-
  product_url_tbl %>%
  mutate(product_name = str_extract(product_url, "([^/]+$)")) %>%
  select(product_name, product_url)



### OBTAINING INDIVIDUAL PRODUCT FEATURES
## Working on a single product URL ----
url_test <- conditioned_product_url_tbl[1,2] %>% pull

html <- read_html(url)


### Product features ----
main_product_features <- html %>%
  html_nodes(".product-features") %>%
  html_nodes("li") %>%
  html_text() %>%
  str_trim() %>%
  unique()

### Carousel details ----

carousel_details <- html %>%
  html_nodes(".accordion") %>%
  html_nodes(".accordion_body") %>%
  html_text() %>%
  str_trim() %>%
  unique() %>% 
  tibble("detailed_features" = .)

### Carousel headers
carousel_feature_names <- html %>%
  html_nodes(".accordion") %>%
  html_nodes(".accordion_head") %>%
  html_text() %>%
  str_trim() %>%
  unique() %>% 
  tibble("feature_names" = .) 

all_carousel_details_tbl <-
  bind_cols(carousel_feature_names) %>%
  bind_cols(carousel_details)



