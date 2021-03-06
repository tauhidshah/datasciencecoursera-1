# Function to tokenize and filter profanity form the text

readLinesFile <- function(filePath, n=-1L){
     # create a connection for the file
     con <- file(filePath, open="r")
     
     # read in the lines and close the connection
     lines <- readLines(con, n=n) 
     close(con)
     
     return(lines)
}

clean_and_filter <- function(lines) {
     require(qdap, quietly = TRUE, warn.conflicts = FALSE)
     require(stringr, quietly = TRUE, warn.conflicts = FALSE)
#     require(SnowballC, warn.conflicts = FALSE, quietly = TRUE)
#     require(tm, quietly = TRUE, warn.conflicts = FALSE)
     require(RWeka, quietly = TRUE, warn.conflicts = FALSE)

     # read in bad words file
     badwords <- readLinesFile('~/Documents/School/Coursera Data Science/Capstone Project/final/en_US/badwords.txt')
     
     # conert all text to lower case
     lines <- tolower(lines)
     
     # Profanity filtering - set all profanity to EXPLICATIVE
     lines <- mgsub(badwords, "EXPLICATIVE", lines)
     
     # replace unicode symbols
     unicodeFound <- c("\u2019|\u2092|\u201D|\u201C|\U0001f466|\u0093i|\u0092m|\u0094|\u0093i|\u032")
     unicodeRepl <- c("")
     lines <- mgsub(unicodeFound, unicodeRepl, lines)

     # replace garbage abbreciations
     garbageFound <- c("w/",":d|8l")
     garbageRepl <- c("with ","")
     lines <- mgsub(garbageFound, garbageRepl, lines)    
     
     # formal prefix abbreviations
     prefixesFound <- c("mr.", "sr.", "jr.", "fr.", "btw", "fyi", "st.")
     prefixesRepl <- c("mister", "senior", "junior", "father",
                       "by the way", "for your information", "saint")
     lines <- mgsub(prefixesFound, prefixesRepl, lines)
     
     # Replace contractions with full words using the contractions dataset
     lines <- mgsub(contractions$contraction, contractions$expanded, lines)
     
     # numerals with words
     numOrderFound <- c("1st", "2nd", "3rd", "4th", "5th", "6th", "7th",
                        "8th", "9th", "0th", "10th")
     numOrderRepl <- c("first", "second", "third", "fourth", "fifth",
                       "sixth", "seventh", "eighth", "nineth", "zeroth",
                       "tenth")
     lines <- mgsub(numOrderFound, numOrderRepl, lines)

     lines <- gsub("'","", lines)

     # Remove greek letters
     lines <- gsub("[\u0370-\u03FF]|[\u1F00-\u1FFF]"," ", lines)

     lines <- str_replace_all(lines, "[^[:alpha:]]", " ")
     
     return(lines)
}