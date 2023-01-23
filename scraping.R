library(rvest)
library(dplyr)
library(stringr)
library(purrr)
link = "https://www.sahibinden.com/apple-tablet?query_text_mf=ipad&query_text=ipad"

html <- read_html(link)
html

nodes <- html %>% html_nodes(".mtmdef") %>% html_text()
nodes

num_of_nodes <- regmatches(nodes, gregexpr("[[:digit:]]+", nodes))
num_of_nodes
num_of_nodes <- as.numeric(unlist(num_of_nodes))
num_of_nodes

nodes_sub_1 <- html %>% html_nodes(".mbdef") %>% html_text()
nodes_sub_1


nodes_sub_2 <- html %>% html_nodes(".currentPage") %>% html_text()
nodes_sub_2


list_of_pages <- str_c(link, "pagingOffset=", seq(0,980,20))
list_of_pages <- if_else(
  str_detect(list_of_pages, "pagingOffset=0") == TRUE,
  "https://www.sahibinden.com/apple-tablet?query_text_mf=ipad&query_text=ipad",
  list_of_pages
  )
list_of_pages


ilanlar <- html %>% html_nodes("#searchResultsTable") %>% html_table(fill = TRUE)
ilanlar <- as.data.frame(ilanlar)
ilanlar

View(head(ilanlar))

View(tail(ilanlar))



yardımcı_fonk <- function(link_df){
  as.data.frame(
    read_html(link_df) %>%
      html_nodes("#searchResultsTable") %>%
      html_table(fill = TRUE)
  )
}

data <- list_of_pages %>%
  map(yardımcı_fonk) %>%
  bind_rows()
View(data)

View(ilanlar)
names(ilanlar)

names(ilanlar) <- ilanlar[1,]
names(ilanlar)


ilanlar <- ilanlar[,-1]
ilanlar <- ilanlar[-1,]

glimpse(ilanlar)

ilanlar <- ilanlar[,c(-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16,-17,-18,-19,-20)]
glimpse(ilanlar)

ilanlar <- ilanlar[c(-5,-6),]

ilanlar <- ilanlar[-which(ilanlar$Model %in% c("Siz de ilanınızın yukarıda yer almasını istiyorsanız tıklayın.")),]
View(ilanlar)

ilanlar %>% mutate(Fiyat = str_remove_all(ilanlar$Fiyat, " TL"))

plot_missing(ilanlar)
