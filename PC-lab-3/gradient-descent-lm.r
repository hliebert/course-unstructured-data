################################################################################
## Filename: gradient-descent-lm.r
## Description: 
## Author: Helge Liebert
## Created: Di Aug 11 16:12:24 2020
## Last-Updated: Mi. Sep  2 17:25:43 2020
################################################################################

#================================= Model inputs ================================

# generate random data in which y is a noisy function of x
x1 <- runif(1000, -5, 5)
x2 <- runif(1000, -15, 15)
x3 <- runif(1000, -1, 7)
intercept <- rep(1, 1000)

## Outcome and matrix of regressors plus intercept

## univariate
y <- x1 + rnorm(1000) + 3
X <- as.matrix(cbind(intercept, x1))

## multivariate
## y <- 3*x1 + 0.5*x2 + 15*x3  + rnorm(1000) + 3
## X <- as.matrix(cbind(intercept, x1, x2, x3))


#================================== QR decomp ==================================

# Fit a linear model, QR-decomposition/Gram-Schmidt orthogonalization
qrd <- lm(y ~ X - 1)
## qrd <- lm(y ~ x1)
## qrd <- lm(y ~ x1 + x2 + x3)
qrd


#=============================== Normal equations ==============================

## Matrix multiplication
ols <- solve(t(X) %*% X) %*% t(X) %*% y
ols
## More idiomatic
ols <- solve(crossprod(X)) %*% crossprod(X,y)
ols
ols <- solve(crossprod(X), crossprod(X,y))
ols


#=============================== Gradient descent ==============================

## squared error cost function
cost <- function(X, y, theta) {
  sum((X %*% theta - y)^2) / (2 * length(y))
}

## learning rate and iteration limit
alpha <- 0.01
niter <- 2000

## keep history
cost_history <- double(niter)
theta_history <- list(niter)

## initialize coefficients
theta <- matrix(c(0, 0), nrow = 2) ## univariate
## theta <- matrix(c(0, 0), nrow = 4) ## multivariate
# gradient descent
set.seed(42)
for (i in 1:niter) {
  error <- (X %*% theta) - y
  delta <- t(X) %*% error / length(y)
  theta <- theta - alpha * delta
  cost_history[i] <- cost(X, y, theta)
  theta_history[[i]] <- theta
}
print(theta)


#===================================== Plot ====================================

## compare estimates
plot(x1, y, col = rgb(0.2, 0.4, 0.6, 0.4),
     main = "Linear regression (by QR-decomp, normal equations or gradient descent)")
abline(qrd[1:2], col = "blue")
abline(ols[1:2], col = "green")
abline(theta[1:2], col = "red")

## plot data and converging fit
plot(x1, y, col = rgb(0.2, 0.4, 0.6, 0.4),
     main = "Linear regression by gradient descent")
for (i in c(1, 3, 6, 10, 14, seq(20, niter, by = 10))) {
  abline(coef = theta_history[[i]], col = rgb(0.8, 0, 0, 0.3))
}
abline(coef = theta, col = "blue")

## cost convergence
plot(cost_history, type = "line", col = "blue", lwd = 2,
     main = "Cost function", ylab = "cost", xlab = "Iterations")



#=================== Stochastic gradient descent, single obs ===================

## Computing the gradient over all data is expensive. Stochastic gradient
## descent uses only a single observation to compute the gradient, which is much
## quicker, and less prone to overshooting with a badly chosen step size. Other
## sgd variants use a small subsample of observations, or multiple subsamples in
## parallel ('mini-batch sgd').

theta <- matrix(c(0, 0), nrow = 2) ## univariate
## theta <- matrix(c(0, 0), nrow = 4) ## multivariate
set.seed(42)
for (i in 1:niter) {
  ## j <- sample(NROW(X), NCOL(X))
  j <- sample(NROW(X), 1)
  error <- (X[j, ] %*% theta) - y[j]
  ## delta <- t(X[j, ]) %*% error / length(y[j]) ## no need to transpose vector
  delta <- X[j, ] %*% error / length(y[j])
  theta <- theta - alpha * delta
  cost_history[i] <- cost(X[j, ], y[j], theta) ## cost function could be simplified
  theta_history[[i]] <- theta
}
print(theta)

## plot data and converging fit
plot(x1, y, col = rgb(0.2, 0.4, 0.6, 0.4),
     main = "Linear regression by stochastic gradient descent")
for (i in c(1, 3, 6, 10, 14, seq(20, niter, by = 10))) {
  abline(coef = theta_history[[i]], col = rgb(0.8, 0, 0, 0.3))
}
abline(coef = theta, col = "blue")

## cost convergence
plot(cost_history, type = "line", col = "blue", lwd = 2,
     main = "Cost function", ylab = "cost", xlab = "Iterations")


#================== Stochastic gradient descnet, single batch ==================

theta <- matrix(c(0, 0), nrow = 2) ## univariate
## theta <- matrix(c(0, 0), nrow = 4) ## multivariate
set.seed(42)
for (i in 1:niter) {
  select <- sample(NROW(X), 32)
  error <- (X[select, ] %*% theta) - y[select]
  delta <- t(X[select, ]) %*% error / length(y[select])
  theta <- theta - alpha * delta
  cost_history[i] <- cost(X[select, ], y[select], theta)
  theta_history[[i]] <- theta
}
print(theta)

## plot data and converging fit
plot(x1, y, col = rgb(0.2, 0.4, 0.6, 0.4),
     main = "Linear regression by stochastic gradient descent")
for (i in c(1, 3, 6, 10, 14, seq(20, niter, by = 10))) {
  abline(coef = theta_history[[i]], col = rgb(0.8, 0, 0, 0.3))
}
abline(coef = theta, col = "blue")

## cost convergence
plot(cost_history, type = "line", col = "blue", lwd = 2,
     main = "Cost function", ylab = "cost", xlab = "Iterations")


#============================== More illustrations =============================

conv <- as.data.frame(cbind(t(sapply(theta_history, function(x) x[, 1])),
                            cost = cost_history))
head(conv)

install.packages("plot3D", dependencies = TRUE)

library(plot3D)
scatter3D(
  x = conv$intercept,
  y = conv$x1,
  z = conv$cost,
  xlab = "intercept",
  ylab = "slope",
  zlab = "cost (mse)",
  col = ramp.col(
    col = sort(RColorBrewer::brewer.pal(9, "Blues"), decreasing = F),
    n = length(unique(conv$cost))
  ),
  colkey = F,
  phi = 10,
  theta = 45,
  main = "Gradient Descent (3D View)"
)


#======== Stochastic gradient descent, mini batch w/ multiple batches =======

## ...


