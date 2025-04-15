# Load the iClusterVB package
library(iClusterVB)

# Load the built-in simulated data
get(data("sim_data"))

# Create a list of data views from the simulated dataset
list_sim_data <- list(
  gauss_1 = sim_data$continuous1_data,
  gauss_2 = sim_data$continuous2_data,
  multinomial_1 = sim_data$binary_data,
  poisson_1 = sim_data$count_data
)

# Specify the distribution for each view
dist_sim_data <- c("gaussian", "gaussian", "multinomial", "poisson")

# Re-code 0's to 2's for the multinomial data (iClusterVB requires non-zero values)
list_sim_data$multinomial_1[list_sim_data$multinomial_1 == 0] <- 2

# Optional: check first few rows of each dataset
head(list_sim_data$gauss_1[, 1:6])
head(list_sim_data$gauss_2[, 1:6])
head(list_sim_data$multinomial_1[, 1:6])
head(list_sim_data$poisson_1[, 1:6])

# Run the iClusterVB model on the simulated data
set.seed(123)
fit_sim_data <- iClusterVB(
  mydata = list_sim_data,
  dist = dist_sim_data,
  K = 8,  # max clusters to allow algorithm to reduce
  initial_method = "VarSelLCM",
  VS_method = 1,  # enable feature selection
  max_iter = 200
)

# Summarize the fitted model
summary(fit_sim_data, rho = 0.5)

# Compare estimated clusters with ground truth
table(fit_sim_data$cluster, sim_data$cluster_true)