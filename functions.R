## FIXME Using str_match to extract from xml nodes has to be improved
consolidate_all_links_on_a_page <- function(prefix_url = "https://www.nomatic.com/collections/all-products?page=",
                                            page_no){
  url_generic <- paste0(prefix_url,
                       page_no)
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
    str_match("/products/[a-zA-z|-]+") %>%
    str_trim() 
}



