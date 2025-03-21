myelin_corr_plot <- function(data){
    
    colours <- brewer.pal(3, 'Dark2')
    
    y_label <- "Correlation Coefficient"
    x_label <- "Group"
    
    # Prepare legend labels? 
    legend_labels <- c('Blind', 'Sighted')
    
    
    
    data %>% 
   #     filter(Region == region_of_interest) %>% 
        ggplot(aes(x = Group, 
                   y = CorrCoeff,
                   group = CorrType,
                   fill = Group)) +
        stat_summary(fun = "mean",
                     geom = "bar",
                     position = position_dodge(width = 1),
                     color = "black",
                     aes(linetype = CorrType),
                     alpha = 0.8,
                     width = 0.7,
                     size = 1,
                     show.legend = TRUE) +
         stat_summary(fun.data = mean_se, 
                      geom="errorbar", 
                      position = position_dodge(width = 1),
                      size = 1, 
                      width = 0.3) +
        #TRY TO ADD CORRELATION VALUES TO BAR PLOTS
        stat_summary(
            fun = "mean",  # Calculate the mean for each category
            geom = "text",  # Use text annotations
            position = position_dodge(width = 1), #dodge by group
            aes(label = round(..y.., 3)),  # Show mean value, rounded to one decimal
            vjust = 4,   # Position the text above the bars
            size = 5         # Adjust text size
        ) +
        geom_point(alpha = 0.2,
                   position = position_dodge(width = 1)) +
        scale_fill_manual(values = c(colours[1], colours[2]),
                           name = NULL,
                           labels = NULL) +
        scale_linetype_manual(values = c("solid", "dashed"), 
                              name = "Correlation Type", 
                              labels = c('Within-Group', 'Between-Group')) +
        #ggtitle(Region) +
        guides(fill = "none") +
        scale_y_continuous(name = y_label) +
        scale_x_discrete(name = x_label, 
                         labels = legend_labels) + 
        theme_cowplot(font_size = 16, font_family = "Arial") +
        theme(plot.title = element_text(hjust = 0.5),
              legend.position = "bottom",
              axis.text.x = element_text(face = "bold"),   # Bold X-axis labels
              axis.text.y = element_text(face = "bold"), 
              axis.line = element_line(size = 1),# Bold Y-axis labels
              axis.ticks = element_line(size = 1))
    
}

