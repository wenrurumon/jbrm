
rm(list=ls())
library(data.table)
library(dplyr)
raw <- readLines("京博-抽样_0919.txt")

x <- strsplit(raw,'\\|\\|\\|')[-1]
key <- strsplit(raw[[1]],'\\|\\|\\|')[[1]]

xlen <- sapply(x,length)

test <- x[xlen>=20]
test <- lapply(test,function(x){
	if(length(x)==20){x <- c(x,'')}
	x
})
test <- do.call(rbind,test)
colnames(test) <- key
test <- as.data.frame(test)

test.sum <- test %>% 
group_by(cate1,indication_class1_1,indication_class1_2) %>% 
summarise(sku=n_distinct(name),store=n_distinct(store_no),trans=n())

filter(test.sum,grepl('鼻',indication_class1_2))

write.csv(test.sum,'category_summarise.csv')
