
# LSA ---------------------------------------------------------------------
library(magrittr)
# local_tokens <- ...
d_dims <- 15 # SVD dimensions

# https://osf.io/7rpnc/
RastrOS <- readr::read_tsv("Data/RastrOS_Corpus_Full.tsv")
RastrOS_osf <- readr::read_tsv("Data/RastrOS_Corpus_Cloze_FULL.tsv")

acen <- function(x) iconv(x, to = "ASCII//TRANSLIT")
lsa_RastrOS_base <- RastrOS[, c("Participant", "Text_ID", "Word_Cleaned")]
lsa_RastrOS_base$Doc_ID <- paste0(lsa_RastrOS_base$Participant, lsa_RastrOS_base$Text_ID)
lsa_RastrOS_base$Word_Cleaned <- lsa_RastrOS_base$Word_Cleaned %>% acen()  
lsa_RastrOS_base <- lsa_RastrOS_base[, c("Doc_ID", "Word_Cleaned")]

tdm_RastrOS <- lsa_RastrOS_base %>%
  dplyr::count(Doc_ID, Word_Cleaned) %>% 
  tidytext::bind_tf_idf(Word_Cleaned, Doc_ID, n) %>%
  dplyr::arrange(desc(idf)) %>% 
  tidytext::cast_tdm(Word_Cleaned, Doc_ID, idf) %>% 
  as.matrix()

lsa_RastrOS <- lsa::lsa(tdm_RastrOS, dims = 10)
lsa_RastrOS_tm <- lsa::as.textmatrix(lsa_RastrOS)

vector_list <- lsa_RastrOS$tk[local_lokens,] 
lsa::cosine(lsa_RastrOS$tk[local_tokens] %>% t)
write.csv(lsa_RastrOS$tk,"Data/RastrOS_LSA_SVD_10.csv")
write.csv(tdm_RastrOS,"Data/RastrOS_term_doc.csv",row.names=T)
