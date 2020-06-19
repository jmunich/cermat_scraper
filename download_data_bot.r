library(tidyverse)
library(RSelenium)
library(XML)
library(robotstxt)

# The following code is used to srape data from "https://vysledky.cermat.cz/data/Default.aspx". Script in clean_botted_data.r is then used to organize the data

# In case of 'PATH to JAVA not found' error, use: Sys.setenv(JAVA_HOME="C:/Program Files (x86)/Java/jre1.8.0_251") with path to Java on your computer

if(paths_allowed("https://vysledky.cermat.cz/data/Default.aspx")){

# Specify years, fields, type of examination and school type
  
  years <- c("2019","2018","2017","2016","2015","2014","2013")
  fields <- c("AJ","CJ","FJ","MA","NJ","RJ","SJ")
  tests <- c("DT","PP","UZ")
  schools <- c("GY4", "GY6", "GY8", "LYC", "S-EK", "S-HP", "S-HU", 
               "S-T1", "S-T2", "S-UM", "S-ZD", "S-ZE", "U-OS", "N-OS", 
               "U-TE", "N-TE")
  
  y_par <- paste0("#ddRok option[value='",years,"']")
  f_par <- paste0("#ddPredmet option[value='",fields,"']")
  t_par <- paste0("#ddDilciZkouska option[value='",tests,"']")
  s_par <- paste0("#ddObor option[value='",schools,"']")
  
# In case of errors, try playing with the second index of binman::list_versions("chromedriver")[[1]][X]

  rd <- rsDriver(chromever = binman::list_versions("chromedriver")[[1]][2])
  remDr <- rd$client
  remDr$open()

  cm_tiblist <- list()
  type_list <- list()
  mark <- 1
  
  for(i in 1:length(years)){
    for(j in 1:length(fields)){
      for(k in 1:length(tests)){
        for(l in 1:length(schools)){
          
          remDr$navigate("https://vysledky.cermat.cz/data/Default.aspx")
          
          option <- remDr$findElement("css", y_par[i])
          option$clickElement()
          option2 <- remDr$findElement("css", f_par[j])
          option2$clickElement()
          option3 <- remDr$findElement("css", t_par[k])
          option3$clickElement()
          option4 <- remDr$findElement("css", s_par[l])
          option4$clickElement()
          # Sys.sleep was added to slow sown the process, so it does not look suspicious, but I do not know much about webscraping, maybe it is not necessary
          Sys.sleep(4)
          tabula <- remDr$findElement("id", "table")
          
          doc <- htmlParse(tabula$getPageSource()[[1]], encoding = "UTF-8")
          table_tmp <- readHTMLTable(doc, stringsAsFactors = FALSE)
          cm_tiblist[[mark]] <- as_tibble(table_tmp$table) %>% 
            mutate(rok = years[i], 
                   field = fields[j],
                   test = tests[k])
          type_list[[mark]] <- c(i,j,k,l)
          mark <- mark + 1
        }
      }
    }
  }
  rd$server$stop()
}

remDr$close()
rm(rd)

saveRDS(cm_tiblist, "CERMAT_data_raw.RDATA")