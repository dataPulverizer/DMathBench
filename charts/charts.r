require(data.table)
require(ggplot2)
library(scales)

# Read data into table
dtable = Map(fread, list.files("../data", full.names = TRUE))
dtable = rbindlist(dtable)
setnames(dtable, names(dtable), c("Library", "func", "Type", "exponent", "nitems", "time"))
dtable[, Type := factor(Type, levels = c("float", "double", "real"))]

# Subsets for plotting
ptable = dtable[func == "Pow",]
dtable = dtable[func != "Pow",]

# Rename length of array for exponent plots
ptable[, NPower := factor(nitems, labels = c("100k", "500k", "1M", "5M", "10M", "100M"))]

# Plots
p1F = ggplot(dtable[Type == "float",], aes(x = nitems, y = time, color = Library)) + 
      geom_point() + geom_line() + scale_x_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) +
      scale_y_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) + 
      facet_wrap(~ func) + theme(legend.position = "top", 
         plot.title = element_text(hjust = 0.5)) + 
      labs(y = "Running time(s) (Float)", x = "Array size (N)")

p1D = ggplot(dtable[Type == "double",], aes(x = nitems, y = time, color = Library)) + 
      geom_point() + geom_line() + scale_x_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) +
      scale_y_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) + 
      facet_wrap(~ func) + theme(legend.position = "top", 
         plot.title = element_text(hjust = 0.5)) + 
      labs(y = "Running time(s) (Double)", x = "Array size (N)")

p1R = ggplot(dtable[Type == "real",], aes(x = nitems, y = time, color = Library)) + 
      geom_point() + geom_line() + scale_x_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) +
      scale_y_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) + 
      facet_wrap(~ func) + theme(legend.position = "top", 
         plot.title = element_text(hjust = 0.5)) + 
      labs(y = "Running time(s) (Real)", x = "Array size (N)")

# Plots
jpeg(file = "../charts/plotFloat.jpg", width = 7, height = 7, units = "in", res = 200)
plot(p1F)
dev.off()

jpeg(file = "../charts/plotDouble.jpg", width = 7, height = 7, units = "in", res = 200)
plot(p1D)
dev.off()

jpeg(file = "../charts/plotReal.jpg", width = 7, height = 7, units = "in", res = 200)
plot(p1R)
dev.off()


p2D = ggplot(dtable[Library == "D",], aes(x = nitems, y = time, color = Type)) + 
    geom_point() + geom_line() + scale_x_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) +
      scale_y_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) +
      facet_wrap(~ func) + theme(legend.position = "top", 
         plot.title = element_text(hjust = 0.5)) + 
      labs(y = "Running time(s) (D)", x = "Array size (N)")

p2C = ggplot(dtable[Library == "C",], aes(x = nitems, y = time, color = Type)) + 
    geom_point() + geom_line() + scale_x_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) +
      scale_y_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) +
      facet_wrap(~ func) + theme(legend.position = "top", 
         plot.title = element_text(hjust = 0.5)) + 
      labs(y = "Running time(s) (C)", x = "Array size (N)")

p2LLVM = ggplot(dtable[Library == "LLVM",], aes(x = nitems, y = time, color = Type)) + 
    geom_point() + geom_line() + scale_x_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) +
      scale_y_continuous(trans = "log10",
                labels = trans_format("log10", math_format(10^.x))) +
      facet_wrap(~ func) + theme(legend.position = "top", 
         plot.title = element_text(hjust = 0.5)) + 
      labs(y = "Running time(s) (LLVM)", x = "Array size (N)")

# Plots
jpeg(file = "../charts/plotD.jpg", width = 7, height = 7, units = "in", res = 200)
plot(p2D)
dev.off()

jpeg(file = "../charts/plotC.jpg", width = 7, height = 7, units = "in", res = 200)
plot(p2C)
dev.off()

jpeg(file = "../charts/plotLLVM.jpg", width = 7, height = 7, units = "in", res = 200)
plot(p2LLVM)
dev.off()


p3F = ggplot(ptable[Type == "float",], aes(x = exponent, y = time, color = Library)) + 
      geom_point() + geom_line(aes(linetype = )) +
      scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) + 
      facet_wrap(~ NPower) + theme(legend.position = "top", 
         plot.title = element_text(hjust = 0.5)) + 
      labs(y = "Running time(s) (Float)", x = "Exponent")

p3D = ggplot(ptable[Type == "double",], aes(x = exponent, y = time, color = Library)) + 
      geom_point() + geom_line(aes(linetype = )) +
      scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) + 
      facet_wrap(~ NPower) + theme(legend.position = "top", 
         plot.title = element_text(hjust = 0.5)) + 
      labs(y = "Running time(s) (Double)", x = "Exponent")

p3R = ggplot(ptable[Type == "real",], aes(x = exponent, y = time, color = Library)) + 
      geom_point() + geom_line(aes(linetype = )) +
      scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) + 
      facet_wrap(~ NPower) + theme(legend.position = "top", 
         plot.title = element_text(hjust = 0.5)) + 
      labs(y = "Running time(s) (Real)", x = "Exponent")

# Plots
jpeg(file = "../charts/plotPowFloat.jpg", width = 7, height = 7, units = "in", res = 200)
plot(p3F)
dev.off()

jpeg(file = "../charts/plotPowDouble.jpg", width = 7, height = 7, units = "in", res = 200)
plot(p3D)
dev.off()

jpeg(file = "../charts/plotPowReal.jpg", width = 7, height = 7, units = "in", res = 200)
plot(p3R)
dev.off()

