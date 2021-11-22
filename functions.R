## FIXME Using str_match to extract from xml nodes has to be improved
consolidate_all_links_on_a_page <- function(all_products_prefix_url = "https://www.nomatic.com/collections/all-products?page=",
                                            page_no,
                                            individual_product_prefix_url = "https://www.nomatic.com/products/"){

  url_generic <- paste0(all_products_prefix_url,
                        page_no)
  print(url_generic)
  
  html_generic <- read_html(url_generic)

  page_products <- html_generic %>% 
    html_nodes("#PageContainer") %>%
    html_nodes("#MainContent") %>%
    html_nodes("#shopify-section-collection-template") %>%
    html_nodes("#Collection") %>%
    html_nodes(".row") %>%
    html_nodes(".col-60") %>%
    html_nodes(".product-items") %>%
    html_nodes(".product-item-hover") %>%
    str_match("/products/([a-zA-z|-]+)") %>%
    .[,2]

  sub_product_url_tbl <-
    tibble(product_name = page_products) %>%
    mutate(product_url = str_c(individual_product_prefix_url,
                               product_name))

  all_product_url_tbl <- bind_rows(sub_product_url_tbl) %>% unique()

}



