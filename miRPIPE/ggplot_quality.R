#########################################################################################
## VISUALIZACION DEL IMPACTO DE LA CALIDAD EN LOS ISOMIRS Y OTRAS VARIANTES CON GGPLOT ##
#########################################################################################

#! /bin/bash

## Copyright 2019 Roman-Escorza M.

## This file is part of miRPIPE

## miRPIPE is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## miRPIPE is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with miRPIPE.  If not, see <http://www.gnu.org/licenses/>.

## USAGE: Rscript ggplot_quality.R results_directory path_to_input

args <- commandArgs(trailingOnly=TRUE)

results.directory <- args[1] 
input.pah <- args[2]

## Loading ggplot2 package

library("ggplot2")

## Fijando el espacio de trabajo

setwd(results.directory)

## Reading inputs

input_stdDev_A <- paste (input.pah,"input_stdDev_A.txt", sep="")
input_stdDev_lv3p <- paste (input.pah,"input_stdDev_lv3p.txt", sep="") 
input_stdDev_G <- paste (input.pah,"input_stdDev_G.txt", sep="")
input_stdDev_C <- paste (input.pah,"input_stdDev_C.txt", sep="")
input_stdDev_lv5p <- paste (input.pah,"input_stdDev_lv5p.txt", sep="")
input_stdDev_U <- paste (input.pah,"input_stdDev_U.txt", sep="")
input_wMean_A <- paste (input.pah,"input_wMean_A.txt", sep="")
input_wMean_G <- paste (input.pah,"input_wMean_G.txt", sep="")
input_wMean_C <- paste (input.pah,"input_wMean_C.txt", sep="")
input_wMean_lv3p <- paste (input.pah,"input_wMean_lv3p.txt", sep="")
input_wMean_lv5p <- paste (input.pah,"input_wMean_lv5p.txt", sep="")
input_wMean_U <- paste (input.pah,"input_mean_U.txt", sep="")
input_mean_A <- paste (input.pah,"input_mean_A.txt", sep="")
input_mean_G <- paste (input.pah,"input_mean_G.txt", sep="")
input_mean_C <- paste (input.pah,"input_mean_C.txt", sep="")
input_mean_lv3p <- paste (input.pah,"input_mean_lv3p.txt", sep="")
input_mean_lv5p <- paste (input.pah,"input_mean_lv5p.txt", sep="")
input_mean_U <- paste (input.pah,"input_mean_U.txt", sep="")

stdDev_A <- read.table(file=input_stdDev_A, header = TRUE)
stdDev_G <- read.table(file=input_stdDev_G, header = TRUE)
stdDev_C <- read.table(file=input_stdDev_C, header = TRUE)
stdDev_lv3p <- read.table(file=input_stdDev_lv3p, header = TRUE)
stdDev_lv5p <- read.table(file=input_stdDev_lv5p, header = TRUE)
stdDev_U <- read.table(file=input_stdDev_U, header = TRUE)
wMean_A <- read.table(file=input_wMean_A, header = TRUE)
wMean_G <- read.table(file=input_wMean_G, header = TRUE)
wMean_C <- read.table(file=input_wMean_C, header = TRUE)
wMean_lv3p <- read.table(file=input_wMean_lv3p, header = TRUE)
wMean_lv5p <- read.table(file=input_wMean_lv5p, header = TRUE)
wMean_U <- read.table(file=input_wMean_U, header = TRUE)
mean_A <- read.table(file=input_mean_A, header = TRUE)
mean_G <- read.table(file=input_mean_G, header = TRUE)
mean_C <- read.table(file=input_mean_C, header = TRUE)
mean_lv3p <- read.table(file=input_mean_lv3p, header = TRUE)
mean_lv5p <- read.table(file=input_mean_lv5p, header = TRUE)
mean_U <- read.table(file=input_mean_U, header = TRUE)

## Boxplotting

stdDev_A <- ggplot(stdDev_A, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "stdDev_A", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="stdDev_A", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
stdDev_A
dev.off()

stdDev_G <- ggplot(stdDev_A, aes(x=condition, y=ratio, fill=condition)) +
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "stdDev_G", x="Condition", y="Ratio")

Cairo(width = 640, height = 480, file="stdDev_G", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
stdDev_G
dev.off()

stdDev_C <- ggplot(stdDev_C, aes(x=condition, y=ratio, fill=condition)) +
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "stdDev_C", x="Condition", y="Ratio")

Cairo(width = 640, height = 480, file="stdDev_C", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
stdDev_C
dev.off()

stdDev_lv3p <- ggplot(stdDev_lv3p, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "stdDev_lv3p", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="stdDev_lv3p", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
stdDev_lv3p
dev.off()

stdDev_lv5p <- ggplot(stdDev_lv5p, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "stdDev_lv5p", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="stdDev_lv5p", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
stdDev_lv5p
dev.off()

stdDev_U <- ggplot(stdDev_U, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "stdDev_U", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="stdDev_U", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
stdDev_U
dev.off()

wMean_A <- ggplot(wMean_A, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "wMean_A", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="wMean_A", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
wMean_A
dev.off()

wMean_G <- ggplot(wMean_G, aes(x=condition, y=ratio, fill=condition)) +
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "wMean_G", x="Condition", y="Ratio")

Cairo(width = 640, height = 480, file="wMean_G", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
wMean_G
dev.off()

wMean_C <- ggplot(wMean_C, aes(x=condition, y=ratio, fill=condition)) +
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "wMean_G", x="Condition", y="Ratio")

Cairo(width = 640, height = 480, file="wMean_C", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
wMean_C
dev.off()

wMean_lv3p <- ggplot(wMean_lv3p, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "wMean_lv3p", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="wMean_A", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
wMean_A
dev.off()

wMean_lv5p <- ggplot(wMean_lv5p, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "wMean_lv5p", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="wMean_lv5p", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
wMean_lv5p
dev.off()

wMean_U <- ggplot(wMean_U, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "wMean_U", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="wMean_U", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
wMean_U
dev.off()
  
mean_A <- ggplot(mean_A, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "mean_A", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="wMean_A", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
mean_A
dev.off()

mean_G <- ggplot(mean_G, aes(x=condition, y=ratio, fill=condition)) +
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "mean_G", x="Condition", y="Ratio")

Cairo(width = 640, height = 480, file="wMean_G", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
mean_G
dev.off()

mean_C <- ggplot(mean_C, aes(x=condition, y=ratio, fill=condition)) +
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "mean_C", x="Condition", y="Ratio")

Cairo(width = 640, height = 480, file="wMean_C", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
mean_C
dev.off()

mean_lv3p <- ggplot(mean_lv3p, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "mean_lv3p", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="mean_A", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
mean_A
dev.off()

mean_lv5p <- ggplot(mean_lv5p, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "mean_lv5p", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="mean_lv5p", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
mean_lv5p
dev.off()

mean_U <- ggplot(mean_U, aes(x=condition, y=ratio, fill=condition)) + 
  geom_boxplot() + theme(legend.position="none") + scale_x_discrete(limits=c("min_10", "min_20", "min_30", "mean_20", "mean_30", "normal", "noMM")) +
  labs(title = "mean_U", x="Condition", y="Ratio") 

Cairo(width = 640, height = 480, file="mean_U", type="png", pointsize=12,
      bg = "transparent", canvas = "white", units = "px", dpi = "auto")
mean_U
dev.off()


