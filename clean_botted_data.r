library(readMSMT)
library(tidyverse)
set_cz()
c_data <- readRDS("CERMAT_data_raw.RDATA")

ref_vec <- c_data[[1]] %>%
  select(V1) %>% unlist()

ref_vec <- as.character(ref_vec[1:18])

c_data_clean <- lapply(c_data, function(x){x %>% filter(!(V1 %in% ref_vec))})

c_data_clean <- c_data_clean[sapply(c_data_clean, nrow, simplify = "vector") > 0]

match_mat <- matrix(FALSE, length(c_data_clean),length(c_data_clean))

for(i in 1:length(c_data_clean)){
  for(j in 1:length(c_data_clean)){
    match_mat[i,j] <- all.equal(c_data_clean[[i]],c_data_clean[[j]])==TRUE
  }
}

if(sum(rowSums(match_mat)!=1)==0){
  fin_dat <- bind_rows(c_data_clean)
}

varnames <- c("zaznam","redizo",
  "jmeno_typ","region",
  "volba_perc","prihlaseni_count",
  "omluveni_count","vylouceni_count",
  "konali_count","neuspeli_count",
  "uspeli_count","percentilove_umisteni_prumer",
  "uspesnost_sd","uspesnost_median",
  "uspesnost_interquartile","uspesnost_25percentile",
  "uspesnost_75percentile", "odlozeny_konali_count",
  "opravny","nahradni_count",
  "rok", "obor","zkouska")

names(fin_dat) <- varnames

fin_dat <- fin_dat %>%
  select(c("redizo","jmeno_typ","region","rok","obor","zkouska"),everything()) %>%
  mutate_at(vars(-one_of("redizo","jmeno_typ","region","rok","obor","zkouska", "zaznam")), function(x){as.numeric(gsub(",",".",x))})

write_excel_csv(fin_dat, "CERMAT_data.csv")

skoly <- fin_dat %>%
  filter(zaznam!="REDIZO") %>% 
  select(c("redizo","jmeno_typ","region","rok","obor","zkouska"),everything()) %>%
  select(-"zaznam")

reditelstvi <- fin_dat %>%
  filter(zaznam=="REDIZO") %>%
  select(c("redizo","jmeno_typ","region","rok","obor","zkouska"),everything()) %>%
  select(-"zaznam") %>%
  distinct()


write_excel_csv(skoly, "CERMAT_data_skoly.csv")
write_excel_csv(reditelstvi, "CERMAT_data_reditelstvi.csv")

