library(tidyverse)
library(data.table)
library(cowplot)
library(RColorBrewer)
library(patchwork)
library(readxl)
library(stringr)
library(stringi)
library(rmcorr)
library(corrr)
library(rlang)

# Load data

main_dir <- '/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/matlab-InterSubjectCorrelations'


#data <- read_tsv(paste(main_dir, 'Correlation_Coefficients.tsv', sep = '/'))
#data <- read_tsv(paste(main_dir, 'Correlation_Coefficients_Ind.tsv', sep = '/'))

corrtype <- 'Pearson' #'Spearman' 'Pearson'

data <- read_tsv(paste(main_dir, paste0(corrtype, '_Correlation_Coefficients_Ind.tsv'), sep = '/'))

data_long <- data %>% 
    pivot_longer(cols = everything(), 
                 names_to = c('Group', 'CorrType', 'Region'),
                 names_sep = '_',
                 values_to = 'CorrCoeff') %>% 
    mutate(Group = factor(Group, levels = c('blind', 'sighted'))) %>% 
    mutate(CorrType = factor(CorrType, levels = c('WG', 'BG'))) %>% 
    mutate(Region = factor(Region, levels = c('WholeBrain', 'OccipitalCortex', 'V1')))


source(paste(main_dir, 'MyelinMaps_plot_functions.R', sep = '/'))

#p_WholeBrain <- myelin_corr_plot(data_long, 'WholeBrain')

p_facet <- myelin_corr_plot(data_long) +
    facet_wrap(~Region) + 
    ggtitle('Within- and Between-Group Correlations of Myelin Maps [T1w/T2w]')
p_facet
