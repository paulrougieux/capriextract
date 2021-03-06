setcolors<-function(x, ony = NULL){
  
  # This returns a function that assigns colors to data.table with ROWS 
  # (or whatever column is indicated in plotdef$ony) giving 
  # a vector of items (e.g. crops so far) to be assigned.
  # The function returns the vector of colors in the order of the list of items
  # if callted with setcolors(n), n indicating the numbers of colors wanted (from 1:n)
  # 
  # Color choices preliminary.
  
  
  allcols<-unique(x[, .SD, .SDcols = ony])
  colpal <- data.frame(matrix(ncol=2, nrow = 0))      #xavi: to avoid the first line with NAs
  names(colpal)<-c("item", "col")
  
  pltte <- callIPCCcolors()
  
  cere <- c("SWHE", "DWHE", "RYEM", "BARL", "OATS", "MAIZ", "OCER", "PARI")
  #cerecols<-colorRampPalette(c("blue4", "cadetblue1"))(length(cere))   
  cerecols<-colorRampPalette(c(rgb(pltte[5, ], maxColorValue=255), rgb(pltte[1, ], maxColorValue=255)))(length(cere))   
  colpal[cere, "item"] <- cere
  colpal[cere, "col"] <- cerecols
  
  oils <- c("RAPE", "SUNF", "SOYA", "OOIL")
  oilscols<-colorRampPalette(c(rgb(pltte[10, ], maxColorValue=255), rgb(pltte[6, ], maxColorValue=255)))(length(oils))
  colpal[oils, "item"] <- oils
  colpal[oils, "col"] <- oilscols
  
  perm <- c("OLIV", "APPL", "OFRU", "CITR", "TAGR", "TABO", "TWIN")
  permcols<-colorRampPalette(c(rgb(pltte[15, ], maxColorValue=255), rgb(pltte[11, ], maxColorValue=255)))(length(perm))
  colpal[perm, "item"] <- perm
  colpal[perm, "col"] <- permcols
  
  othe <- c("PULS", "POTA", "SUGB", "TOMA", "OVEG", "TEXT")
  #othecols<-colorRampPalette(c("lemonchiffon","khaki4"))(length(othe))
  othecols<-colorRampPalette(c(rgb(pltte[20, ], maxColorValue=255), rgb(pltte[16, ], maxColorValue=255)))(length(othe))
  colpal[othe, "item"] <- othe
  colpal[othe, "col"] <- othecols
  
  othe <- c("TOBA", "OIND", "NURS", "NECR", "FLOW", "OCRO")
  #othecols<-colorRampPalette(c("lemonchiffon","khaki4"))(length(othe))
  othecols<-colorRampPalette(c(rgb(pltte[25, ], maxColorValue=255), rgb(pltte[21, ], maxColorValue=255)))(length(othe))
  colpal[othe, "item"] <- othe
  colpal[othe, "col"] <- othecols
  
  fodd <- c("MAIF", "ROOF", "OFAR", "GRAS", "STRA") 
  foddcols<-colorRampPalette(c(rgb(pltte[30, ], maxColorValue=255), rgb(pltte[26, ], maxColorValue=255)))(length(fodd))
  colpal[fodd, "item"] <- fodd
  colpal[fodd, "col"] <- foddcols
  
  meat <- c("COMF", "BEEF", "PORK", "SGMI", "SGMF", "SGMT", "EGGS", "POUM")
  meatcols<-colorRampPalette(c(rgb(pltte[5, ], maxColorValue=255), rgb(pltte[1, ], maxColorValue=255)))(length(meat))
  colpal[meat, "item"] <- meat
  colpal[meat, "col"] <- meatcols
  
  dairy <- c("COMI", "WMIO", "BUTT", "SMIP", "CHES", "FRMI", "CREM", "COCM")
  dairycols<-colorRampPalette(c(rgb(pltte[10, ], maxColorValue=255), rgb(pltte[6, ], maxColorValue=255)))(length(dairy))
  colpal[dairy, "item"] <- dairy
  colpal[dairy, "col"] <- dairycols
  
  scnd <- c("SUGA", "RAPO", "SUNO", "SOYO", "WHEP", "CASE", "SUNC", "SOYC", "DDGS", 
            "OTHO", "OLIC", "OLIO", "RAPC", "PLMO", "RICE", "MOLA", "STAR")
  scndcols<-colorRampPalette(c("grey90","grey10"))(length(scnd))
  colpal[scnd, "item"] <- scnd
  colpal[scnd, "col"] <- scndcols
  
  

  missing <- allcols$ROWS[! allcols$ROWS %in% colpal$item]
  if(length(missing)>0){
    cat("\n\n Attention, colors are not defined for: ", paste(missing, collapse=", "))
  }
  #xavi: colpal<-colpal[!is.na(colpal$item),]
  colpal<-colpal[colpal$item %in% allcols[[1]],]
  #xavi: colpal<-merge(allcols, colpal, by.x=ony, by.y="item", sort = FALSE)
  colpal <- merge(colpal, allcols, by.x = "item", by.y = ony, all = TRUE, sort = FALSE)
  
  colpal$col[is.na(colpal$col)] <- "pink"
  
  col_map <- setNames(as.character(colpal$col), colpal$item)
  
  colpal<-colpal[[2]]
  
  # Make a function that returns the colors if called 
  # with the total number of colors needed
  colfun<-function(n){
    colpal <- rep(colpal, ceiling(n/length(colpal)))
    colfun <- colpal[1:n]
    return(colfun)
  }
  #return(colfun)
  return(list(colfun, colpal, col_map))
  
}
plotallnamedcolors<-function(myc = colors(), cn = colors()){
  #Adapted from http://sape.inf.usi.ch/quick-reference/ggplot2/colour
  if(length(myc) != length(cn)) cn <- myc
  nrow <- 2 * floor(sqrt(length(myc)))
  d=data.frame(c=myc, y=seq(0, length(myc)-1)%%66, x=seq(0, length(myc)-1)%/%66 )
  ggplot() +
    scale_x_continuous(name="", breaks=NULL, expand=c(0, 0)) +
    scale_y_continuous(name="", breaks=NULL, expand=c(0, 0)) +
    scale_fill_identity() +
    geom_rect(data=d, mapping=aes(xmin=x, xmax=x+1, ymin=y, ymax=y+1), fill="white") +
    geom_rect(data=d, mapping=aes(xmin=x+0.05, xmax=x+0.95, ymin=y+0.5, ymax=y+2, fill=c)) +
    geom_text(data=d, mapping=aes(x=x+0.05, y=y+1.5, label=cn), colour="white", hjust=0, vjust=1, size=3, check_overlap = TRUE) +
    geom_text(data=d, mapping=aes(x=x+0.95, y=y+1.5, label=cn), colour="black", hjust=1, vjust=1, size=3, check_overlap = TRUE)
}

callIPCCcolors <- function(
  #fle = "E:/IPCC_colors/IPCCcolors.xlsx", 
  fle = "E:/capriextract/IPCCcolors.xlsx", 
  #sht = c("red2blue", "brown2green"))  #this is 20 colors (4 groups)
  sht = c("scales6")) #this is 30 colors (6 groups)
  {
  library(xlsx)
  pltte_IPCC <- as.data.frame(matrix(nrow = 0, ncol = 0))
  for(s in sht){
    IPCCcols <- read.xlsx(fle, s, header = TRUE)
    pltte_IPCC <- rbind(pltte_IPCC, IPCCcols)
  }
  pltte_IPCC <- pltte_IPCC[, 2:4]
  #
}
