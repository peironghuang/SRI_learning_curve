library(data.table)

###### macros ######

work_dir      = 'C:/Users/jiju6002/data'

output_dir    = 'R_output'

# data_file     = 'R_input/Surgeon1.csv'
data_file     = 'R_input/Surgeon2.csv'

###### initial steps ######

setwd(work_dir)
sergeon       = sub('.*/([^.]+).csv', '\\1', data_file)

###### read in data ######

sur_data      = fread(sprintf('%s/%s', work_dir, data_file), header = T)

sur_data[is.na(sur_data)] = 0
sur_data[,  ":="(cartactcultimate = cumsum(Cataract),
                 bleeding         = cumsum(Bleeding),
                 others           = cumsum(Other_complications))]

###### complications ######

plot_exp  = function(complication = 'cartactcultimate')
{
  # complication = 'cartactcultimate'
  fit_x     = sur_data$number
  fit_y     = unlist(sur_data[, complication, with = F])
  max_fit_y = max(fit_y)
  
  fit_exp   = lm(log((max_fit_y - fit_y[fit_y < max_fit_y]) / max_fit_y) ~ fit_x[fit_y < max_fit_y] + 0)
  coef_exp  = coef(fit_exp)
  pred_y    = max_fit_y - max_fit_y * exp(coef_exp * fit_x)
  plateau_x = log(max_fit_y / nrow(sur_data) / (-coef_exp * max_fit_y)) / (coef_exp)
  
  p2_base   = ceiling(-max_fit_y * coef_exp * 100 / 5) * 5
  p_margin  = 10
  
  tiff(sprintf('%s/Complication_%s_%s.tif', 
               output_dir,
               sergeon,
               gsub('/', '_', complication)), 
       width = 1000, height = 600)
  
  plot(0, type = 'n', xlab = 'Case Number', ylab = complication,
       xlim = c(0, ceiling(nrow(sur_data) / 50) * 50), 
       ylim = c(0, p2_base + p_margin + max_fit_y * 1.5), axes = F, cex.lab = 1.5)
  
  ### derivitive part ####
  axis(1, at = seq(0, ceiling(nrow(sur_data) / 50) * 50, by = 50), cex.axis = 1.5)
  axis(2, at = seq(0, p2_base, by = 5), 
       labels = seq(0, p2_base, by = 5) / 100, cex.axis = 1.5)
  lines(-max_fit_y * coef_exp * exp(coef_exp * fit_x) * 100, type = 'l', col = 'blue')
  
  ### fitted part ###
  axis(1, at = seq(0, ceiling(nrow(sur_data) / 50) * 50, by = 50), 
       labels = rep('', length(seq(0, ceiling(nrow(sur_data) / 50) * 50, by = 50))),
       pos = ceiling(-max_fit_y * coef_exp * 100 / 5) * 5 + 10)
  axis(2, at = seq(p2_base + p_margin, p2_base + p_margin + max_fit_y * 1.5, by = 5),
       labels = seq(0, max_fit_y * 1.5, by =  5), cex.axis = 1.5)
  lines(pred_y + p2_base + p_margin, type = 'l', col = 'blue')
  lines(fit_y + p2_base + p_margin, type = 'S', col = 'black', lwd = 2)
  
  ## ablines and texts
  abline(v = plateau_x, col = 'gray70', lty = 2)
  text(x = plateau_x + 30, y = p_margin + pred_y[floor(plateau_x)] * 0.2, cex = 1.8, 
       labels = sprintf('Case %s', floor(plateau_x)))
  text(x = plateau_x + 60, y = p2_base + p_margin + pred_y[floor(plateau_x)] * 0.8, cex = 1.8, 
       labels = bquote(Y == .(sprintf('%2d', max_fit_y)) - .(sprintf('%2d', max_fit_y)) * e^{.(sprintf('%.4f', coef_exp)) * x}))
  text(x = plateau_x + 35, y = p2_base + p_margin + pred_y[floor(plateau_x)] * 0.4, cex = 1.8, 
       labels = bquote(R^{2} == .(sprintf('%.4f', summary(fit_exp)$adj.r.square))))
  
  ## titles
  text(ceiling(nrow(sur_data) / 50) * 25, p2_base + p_margin + max_fit_y * 1.5,
       sprintf('Cumulative %s cases and fitted line', complication), cex = 2)
  text(ceiling(nrow(sur_data) / 50) * 25, p2_base,
       'Surgeon experiences against instant complication increase', cex = 2)
  
  dev.off()
  
}

plot_exp(complication = 'cartactcultimate')
plot_exp(complication = 'others')
plot_exp(complication = 'bleeding')
