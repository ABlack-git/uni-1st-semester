# Clustering lab

library(MASS) # multivariate normal distribution
library(dbscan) # density-based clustering



# Start with a simple case
# ===================================== GENERATE DATA ============================================
Sigma <- matrix(c(1, 0, 0, 1, 2, 2), 2, 2)

# 50 points of the "black" cluster
d <- mvrnorm(n = 50, mu = c(1, 1), Sigma)
# Add 50 points of the "green" cluster
d <- rbind(d, mvrnorm(n = 50, mu = c(1, 5), Sigma))
# Add 50 points of the "red" cluster
d <- rbind(d, mvrnorm(n = 50, mu = c(5, 1), Sigma))
# Add 50 points of the "blue" cluster
d <- rbind(d, mvrnorm(n = 50, mu = c(5, 5), Sigma))

# Add labels to clusters
d <- cbind(d, rep(c(1, 2, 3, 4), each = 50))
plot(d[, 1], d[, 2], col = d[, 3])

# Labels are however not available to clustering algs - this is what the it "sees"
plot(d[, 1], d[, 2])

# ===================================== BASIC DEMO =============================================
# Do the clustering, compare with the original classes
kmeansCompareMethod <- function(data, labels, k) {
  kmeans.output <- kmeans(data, k, iter.max = 15)
  
  plot(data[, 1], data[, 2], col = labels)
  plot(data[, 1], data[, 2], col = kmeans.output$cluster)
}

par(mfrow = c(1, 2))
kmeansCompareMethod(data = d[, c(1, 2)], labels = d[, 3], k = 4)

# =================================== CHALANGES TO KMEANS ========================================
# Now spice the things up - change the scale!
d[, 2] <-
  d[, 2] / 100 # the clustering outcome gets much worse, only the first dimenison matters, rescaling needed

par(mfrow = c(2, 1))
kmeansCompareMethod(data = d[, c(1, 2)], labels = d[, 3], k = 4)

scale(d[, c(1, 2)]) # scale the data back
# ------------------------------------------------------------------------------------------------
# add outliers, they tend to make clusters of size 1
d[1, c(1:2)] <- c(-10,-10)
d[100, c(1:2)] <- c(10, 10)

par(mfrow = c(1, 2))
kmeansCompareMethod(data = d[, c(1, 2)], labels = d[, 3], k = 4)
# ------------------------------------------------------------------------------------------------
# change cluster shapes
Sigma1 <- matrix(c(1, 0.9, 0.9, 1, 2, 2), 2, 2)
Sigma2 <- matrix(c(2,-0.8,-0.8, 1, 2, 2), 2, 2)
d <- mvrnorm(n = 50, mu = c(1, 1), Sigma2)
d <- rbind(d, mvrnorm(n = 50, mu = c(1, 5), Sigma1))
d <- rbind(d, mvrnorm(n = 50, mu = c(5, 1), Sigma1))
d <- rbind(d, mvrnorm(n = 50, mu = c(5, 5), Sigma2))
d <- cbind(d, rep(c(1, 2, 3, 4), each = 50))

par(mfrow = c(1, 1))
plot(d[, 1], d[, 2], col = d[, 3])

par(mfrow = c(1, 2))
kmeansCompareMethod(data = d[, c(1, 2)], labels = d[, 3], k = 4)


# change cluster shapes again
Sigma2 <- matrix(c(1, -0.98, -0.98, 1, 2, 2), 2, 2)
d <- mvrnorm(n = 50, mu = c(1, 1), Sigma2)
d <- rbind(d, mvrnorm(n = 50, mu = c(2, 2), Sigma2))
d <- rbind(d, mvrnorm(n = 50, mu = c(3, 3), Sigma2))
d <- rbind(d, mvrnorm(n = 50, mu = c(4, 4), Sigma2))
d <- cbind(d, rep(c(1, 2, 3, 4), each = 50))
plot(d[, 1], d[, 2], col = d[, 3])

kmeansCompareMethod(data = d[, c(1, 2)], labels = d[, 3], k = 4)

# ======================== DETERMINE APPPROPRIATE NUMBER OF CLUSTERS =============================
# plot the homogeneity plot up to k.max
# the best k may be guessed from the elbow in the homogeneity curve
elbowMethod <- function(data, k.max) {
  wss <- sapply(1:k.max,
                function(k) {
                  kmeans(data, k, nstart = 50, iter.max = 15)$tot.withinss
                })
  
  par(mfrow = c(1, 1))
  plot(
    1:k.max,
    wss,
    type = "b", pch = 19, frame = FALSE,
    xlab = "Number of clusters K",
    ylab = "Total within-clusters sum of squares"
  )
}

elbowMethod(d[, c(1, 2)], 10) # estimate the optimal number of clusters with elbow 

km.out <- kmeans(d[, c(1, 2)], 4, nstart = 10)
km.out$cluster
table(d[, 3], km.out$cluster) # confusion matrix clusters vs true classes
points(
  x = d[, 1],
  y = d[, 2],
  col = km.out$cluster,
  pch = 4
)

# ======================== HIERARCHICAL CLUSTERING =============================
hc.complete <- hclust(dist(d[, c(1, 2)]), method = "complete")
hc.average <- hclust(dist(d[, c(1, 2)]), method = "average")
hc.single <- hclust(dist(d[, c(1, 2)]), method = "single")

par(mfrow = c(1, 3))
plot(
  hc.complete,
  main = "Complete Linkage",
  xlab = "", sub = "", cex = .9
)
plot(
  hc.average,
  main = "Average Linkage",
  xlab = "", sub = "", cex = .9
)
plot(
  hc.single,
  main = "Single Linkage",
  xlab = "", sub = "", cex = .9
)

# ----------------------------- CUT THE TREES  ------------------------------------
hc.complete.out <- cutree(hc.complete, 4)
hc.average.out <- cutree(hc.average, 4)
hc.single.out <- cutree(hc.single, 4)

library(dendextend)
dend1 <- as.dendrogram(hc.single)
dend1 <- color_branches(dend1, k = 4)
dend1 <- color_labels(dend1, k = 4)

par(mfrow = c(1, 1))
plot(dend1)

plot(
  x = d[, 1],
  y = d[, 2],
  col = hc.average.out
)

# ======================== DENSITY BASED CLUSTERING =============================
kNNdistplot(d[, c(1, 2)], k = 4) # find the best settings for Epsilon and minPts, look for the knee!
abline(h = .75, col = "red", lty = 2) # the knee gives the optimal eps for the given minPts/k
dbscan <- dbscan(d[, c(1, 2)], eps = 1, minPts = 4)
dbscan$cluster
plot(
  x = d[, 1],
  y = d[, 2],
  col = dbscan$cluster,
  pch = 4
)

# Different density
# change cluster density, remove points from clusters 1 and 4
d<-d[c(41:160),]
plot(d[, 1], d[, 2], col = d[, 3])

# EM GMM
BIC <- mclustBIC(d[,c(1,2)])
BIC
gmm <- Mclust(d[,c(1,2)], x = BIC)
summary(gmm, parameters = TRUE)
plot(x=d[,1],y=d[,2],col=gmm$classification,pch=4)

