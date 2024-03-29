# Video tutorial: regressieanalyse

# categorische onafhankelijke variabele: marital status
# afhankelijk als vorige tutorial: levenstevredenheid

# een schone start
rm(list=ls())
graphics.off()

# packages
library(haven)
library(dplyr)
library(summarytools)
library(psych)

# Data: GSS wave 2018
setwd("C:/Users/ejvan/OneDrive - Vrije Universiteit Amsterdam/Bachelor Sociologie/OEI_Github/No_sync")
# download.file("https://gss.norc.org/Documents/spss/2018_spss.zip", "2018_spss.zip", mode = "wb")
dta <- read_spss(unzip("2018_spss.zip", "GSS2018.sav"))


# Hypothese: Mensen die getrouwd zijn tevredener met hun leven dan 
# degene die nooit getrouwd zijn

# nul-hypothese: er is geen verband tussen relatie status en tevredenheid


# Categorische onafhankelijke variabele: schatten door dummy variabelen 
# in model

# -------------------------- data bewerking  -----------------------------------

# levenstevredenheid
dta$tevr <- 8 - dta$SATLIFE
descr(dta$tevr)

# marital status - dummy variabelen, zie tutorial data transformaties recode
freq(dta$MARITAL)
attributes(dta$MARITAL)[["labels"]]
dta <- dta %>% mutate(mst_mar = case_when(MARITAL == 1 ~ 1, MARITAL != 1 ~ 0),
                      mst_wdw = case_when(MARITAL == 2 ~ 1, MARITAL != 2 ~ 0),
                      mst_div = case_when(MARITAL == 3 ~ 1, MARITAL != 3 ~ 0),
                      mst_sep = case_when(MARITAL == 4 ~ 1, MARITAL != 4 ~ 0),
                      mst_nev = case_when(MARITAL == 5 ~ 1, MARITAL != 5 ~ 0))


# ------------------------- regressie-analyse ----------------------------------

# MARITAL als continue variabele toevoegen is zinloos; zijn groepen
# Algemene aanpak: voeg dummy variabelen  toe aan model
# Dan kun je de verschillen tussen de groepen schatten
# Laat één dummy variabele weg, die wordt de referentiegroep

M1<- lm(tevr ~ mst_mar + mst_wdw + mst_div + mst_sep, data = dta)
summary(M1)
# wat is het intercept?
# kijk naar situatie waarbij alle RCs nul zijn
# oftewel: never married
# tevr = 5.24 + 0.58 * 0 + 0.24 * 0 - 0.00 * 0 - 0.22 * 0
# tevr = 5.24
# dus geschatte tevredenheid degene die never married zijn
# is dus als geschat, dummy variabele hoeft niet in het model

# wat zegt de RC voor mst_mar nu? 
# kijk naar regressievergelijking voor degene die getrouwd zijn
# tevr = 5.24 + 0.58 * mar + 0.24 * wdw - 0.00 * div - 0.22 * sep
# tevr = 5.24 + 0.58 * 1 + 0.24 * 0 - 0.00 * 0 - 0.22 * 0
# tevr = 5.24 + 0.58
# 0.58 is het verschil tussen getrouwden en never married

# andere coefficienten gaan op dezelfde manier: schrijf vergelijking maar uit
# bijv: wat is de voorspelde tevredenheid van mensen die gescheiden zijn? 

# verschil tussen getrouwden en never married is significant (p<.05)
# nul hypo dat er geen verband is verworpen

# Dus: laat categorie weg die je als referentiecategorie wilt
# bijv: mst_mar weg
M2 <- lm(tevr ~ mst_wdw + mst_div + mst_sep + mst_nev, data = dta)
summary(M2)
# Oefening: hoe interpreteer je het effect van mst_div?

    
# ----------- of laat R het werk doen ----------------

# moet categorische variabele wel een factor variabele zijn
M3 <- lm(tevr ~ as.factor(MARITAL), data = dta)
summary(M3)
# laat standaard laagste waarde weg
# kun je anders instellen met relevel()

# factor variabele van base veranderen
attributes(dta$MARITAL)[["labels"]]
dta$mar_st <- factor(dta$MARITAL, levels = c(1:5, 9), 
                     labels = c("MARRIED", "WIDOWED", "DIVORCED",
                              "SEPARATED", "NEVER MARRIED", "NA"))
str(dta$mar_st)
dta$mar_st <- relevel(dta$mar_st, ref = "WIDOWED")
str(dta$mar_st)

M4 <- lm(tevr ~ mar_st, data = dta)
summary(M4)








