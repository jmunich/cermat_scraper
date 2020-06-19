# SCRAPING CZVV WITH R
------
## Warning
## Please, do not use the data to create 'league tables'
## Nepoužívejte prosím tato data k vytváření žebříčků úspěšnosti

The main purpose of these data should be to analyze overal patterns, regional inequalities etc. (more notes on the interpretation of the reported values are at the end of this README). Please, refrain from making inferences about individual schools or using the data to draw conclusions about the quality of education they provide. Most of all, do not create "league tables" (žebříčky úspěšnosti). 

"The impact of ‘league tables’ has been evident in:

• Political and media ‘bashing’ of schools and teachers (see Notes i and ii).

• A test-dominated curriculum (particularly in English, mathematics and science) that has resulted in an over-emphasis (exclusive in some cases) on curriculum content that is to be tested or examined.

• Overt lobbying of the government by principals of non-selective schools to ‘select’ up to twenty per cent of their school enrolments in an attempt to improve their schools’ rankings on the ‘league tables’. This has resulted in a reluctance, and in some cases, direct refusals to enrol ‘low-achievers’. Further, some schools have responded by concentrating their efforts on those students considered capable of improving their average examination and test scores, while giving less attention to those perceived less likely to improve.

• Parents have ‘voted with their feet’ by choosing to enrol their children in schools on the basis of ‘league table’ rankings. In some cases, this has meant changing their former residential locations to those in closer proximity to the chosen schools."

Rowe, K. J. (2000). Assessment, League Tables and School Effectiveness: Consider the Issues and 'Let's Get Real'!. The Journal of Educational Enquiry, 1(1).

## Introduction
------
The following code can be used to scrape data from CZVV agregated data viewer (https://vysledky.cermat.cz/data/Default.aspx).

Two things should be noted. 

First, the data might be incomplete, as CZVV might not be including schools with too few students, arguing probably that such aggregated data might still be used to identify individual students.

Second, use the scraper on your own danger. It should function properly, but every user should check for him/her-self that the data were downloaded properly.

## Download data
------
Code in *download_data_bot.r* is used to collect the data and save them in an .RData file. It uses RSelenium package. In case of errors, there are some recommendations in the comments inside the code and you can always consult Stack Overflow.

## Clean the data
------
Code in *clean_botted_data.r* organizes the downloaded data into three nice named data frames (tibbles from the tidyverse package). The data need cleaning for several reasons. For instance, math results were downloaded multiple times (as the other examinations may consist of several forms, but math only has a written exam). Such things are still in the scraping code on the account of me being lazy in writting the scraper. The cleaning code should take care of that. Just think about such issues, hope I did not miss something important. The code will return three .csv files. One for all the data as displayed in CZVV viewer. One for individual schools only and one for schools aggregated by headmaster offices (you can see that in the original data, each school has two rows, because sometimes, the headmaster's office can cover multiple schools, even of different types.  

## Next steps
------
### Locations
It is possible to download an address book for all schools in Czech Republic by going to http://stistko.uiv.cz/registr/vybskolrn.asp and searching with an empty form. You will be offered an option to dowload an .xls file with school addresses that can be joind to CZVV data via red_izo codes.

### Other school data
Using red_izo, it is possible to join these data to the huge dataset managed by the Czech Ministry of Education. More can be found in my package for managing these data here https://github.com/jmunich/readMSMT. Note however, that the data first need to be requested from the ministry. 

### Regional data
Local municipalities in Czech Republic are responsible only for elementatry education and kindergartens. However, it might still be interesting to compare local spending behaviour and maturita success rates. Extensive data on spending can be found here https://monitor.statnipokladna.cz/, match using identifier chain *spending - IČO - adress - red_izo*.

### There is obviously more.

## Notes on the interpretation
------
The psychometric properties of maturita exams are being kept secret and to our knowledge, their reliability, validity and measurement invariance cannot be guaranteed. Given that cermat uses Classical Test Theory to develop their tests, scores and success rates cannot be easily comparable between years. The data should therefore seen as an instrument for the study of how maturita testing ipacts communities, rather than as some indicator of student proficiency.

No warranty etc., but have fun!
