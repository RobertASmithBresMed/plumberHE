makeCEPlane = function (total_costs = example_TC,
                        total_qalys = example_TQ,
                        comparitor = "notreat",
                        treatment = "treat 1",
                        thresh = 30000,
                        colors = NULL,
                        show_ellipse = F)
{
  # return an empty data-set if there is no data.
  if (ncol(total_costs) < 2 | ncol(total_qalys) < 2) {
    return(noDataPlot())
  }
  
  
  ce_plane_plot = ggplot2::ggplot() + ggplot2::geom_vline(xintercept = 0) +
    ggplot2::geom_hline(yintercept = 0) + ggplot2::theme_minimal() +
    # ggplot2::labs(title = "Cost-effectiveness Plane", subtitle = paste0("Results of Probabilistic Sensitivity Analysis:")) +
    ggplot2::xlab("Incremental QALYs") + ggplot2::ylab("Incremental Costs")
  if (!is.null(thresh)) {
    ce_plane_plot = ce_plane_plot + ggplot2::geom_abline(slope = thresh,
                                                         linetype = "dashed",
                                                         intercept = 0)
  }
  if (!is.null(treatment)) {
    TQ = total_qalys
    TC = total_costs
    
    
    legend_colors = if (!is.null(colors)) {
      colors
    } else {
      rainbow(n = ncol(total_costs))
    }
    names(legend_colors) = colnames(total_costs)
    legend_colors = legend_colors[names(legend_colors) %in% treatment]
    
    
    
    
    incr_C <- data.frame(TC[, treatment] - TC[, comparitor])
    names(incr_C) = treatment
    incr_Q <- data.frame(TQ[, treatment] - TQ[, comparitor])
    names(incr_Q) = treatment
    incr_long = cbind(reshape2::melt(incr_C, id.vars = NULL),
                      reshape2::melt(incr_Q, id.vars = NULL)[, "value"])
    names(incr_long) = c("Treatment", "incr_C", "incr_Q")
    incr_mean_Q = aggregate(incr_Q ~ Treatment, incr_long,
                            mean)
    incr_mean_C = aggregate(incr_C ~ Treatment, incr_long,
                            mean)
    incr_means = merge(incr_mean_Q, incr_mean_C, by = "Treatment")
    if (show_ellipse) {
      ce_plane_plot = ce_plane_plot +
        ggplot2::stat_ellipse(
          data = incr_long[!(incr_long$Treatment %in% comparitor),],
          ggplot2::aes(x = incr_Q, y = incr_C, col = Treatment),
          type = "norm",
          level = 0.9,
          segments = 50
        )
    }
    
    ce_plane_plot = ce_plane_plot +
      ggplot2::geom_point(
        data = incr_long,
        ggplot2::aes(x = incr_Q, y = incr_C, col = Treatment),
        alpha = 0.5,
        size = 0.7
      ) +
      
      ggplot2::geom_point(
        data = incr_means,
        ggplot2::aes(x = incr_Q, y = incr_C, fill = Treatment),
        col = "black",
        size = 3,
        pch = 21
      ) +
      
      ggplot2::scale_y_continuous() +
      coord_cartesian(
        xlim = c(-quantile(abs(
          incr_long$incr_Q
        ), 0.99),
        quantile(abs(
          incr_long$incr_Q
        ), 0.99)),
        ylim = c(-quantile(abs(
          incr_long$incr_C
        ), 0.99),
        quantile(abs(
          incr_long$incr_C
        ), 0.99))
      )
    
    if (!is.null(legend_colors)) {
      ce_plane_plot = ce_plane_plot +
        
        ggplot2::scale_fill_manual(name = NULL,
                          values = legend_colors,
                          guide = F) +
        guides(color = guide_legend(override.aes = list(
          size = 4,
          linetype = F,
          alpha = 1
        ))) +
        scale_color_manual(name = paste(comparitor, "vs."),
                           values = legend_colors) +
        
        theme(
          legend.position = "top",
          legend.text = element_text(size = 14),
          legend.title = element_text(size = 14),
          axis.text.x = element_text(size = 14),
          axis.text.y = element_text(size = 14),
          title = element_text(size = 14)
        )
    }
    
  }
  # ce_plane_plot
  return(ce_plane_plot)
}