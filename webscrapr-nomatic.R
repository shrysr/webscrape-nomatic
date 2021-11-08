## Loading Libraries ---
library(dplyr)
library(rvest)
library(purrr)
library(fs)
library(xopen)
library(furrr)
library(stringr)

## We'll start with a limited number of products: 
## - https://www.nomatic.com/products/the-nomatic-travel-pack
## - https://www.nomatic.com/products/nomatic-toiletry-bag
## - https://www.nomatic.com/products/the-nomatic-backpack
## - https://www.nomatic.com/products/nomatic-messenger-bag


## Constructing a tibble parsing product name from the above URL's

url_list <- c("https://www.nomatic.com/products/the-nomatic-travel-pack",
"https://www.nomatic.com/products/nomatic-toiletry-bag",
"https://www.nomatic.com/products/the-nomatic-backpack",
"https://www.nomatic.com/products/nomatic-messenger-bag")


product_url_tbl <-tibble(product_url = url_list)

conditioned_product_url_tbl <-
  product_url_tbl %>%
  mutate(product_name = str_extract(product_url, "([^/]+$)")) %>%
  mutate(product_name = str_replace_all(product_name, "-", " ")) %>%
  select(product_name, product_url)


## Working on a single product URL ----
url_test <- conditioned_product_url_tbl[1,2] %>% pull

html <- read_html(url_test)

### Product features ----
main_product_features <- html %>%
  html_nodes(".product-features") %>%
  html_nodes("li") %>%
  html_text() %>%
  str_trim() %>%
  unique()

### Carousel details ----

html %>%
  html_nodes(".accordion") %>%
  html_nodes(".accordion_body") %>%
  html_text() %>%
  str_trim() %>%
  unique() %>% 
  tibble("detailed_features" = .)

### Carousel headers
html %>%
  html_nodes(".accordion") %>%
  html_nodes(".accordion_head") %>%
  html_text() %>%
  str_trim() %>%
  unique() %>% 
  tibble("feature_names" = .) 
  

### Obtain all products
url_generic <- "https://www.nomatic.com/collections/all-products/"
html_generic <- read_html(url_generic)

html_generic %>%
  html_nodes("#PageContainer") %>%
  html_nodes("#MainContent") %>%
  html_nodes("#shopify-section-collection-template") %>%
  html_nodes("#Collection") %>%
  html_nodes(".row") %>%
  html_nodes(".col-60") %>%
  html_nodes(".product-items") %>%
  html_nodes(".product-item-hover") %>%
  html_nodes("#onclick")

  

  

html_nodes(".shopify-section-collection-template")


  html_nodes("shopify-section-collection-template") 

%>%
  html_nodes("onclick")

html_generic %>%
  html_nodes(".shopify-section") %>%
  html_nodes("#shopify-section-custom-css") %>% html_text()
