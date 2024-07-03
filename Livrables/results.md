# Methods 

## Experimental Infection 

### Protocol description

The experimental infection was conducted using a controlled setting involving goats. Each experimental batch consisted of 6-7 individuals, with one individual designated as the "seeder" for the infection. The seeder was experimentally inoculated with the PPRV lineage IV. The remaining individuals in the batch were uninfected at the start of the experiment and served as contact individuals to assess the transmission dynamics.

### Housing and Environmental Conditions

All animals were housed in a single enclosure that allowed for free movement and interaction among individuals. The enclosure was designed to mimic natural living conditions to ensure that social behaviors and interactions were as realistic as possible.

### Monitoring and Data Collection

To monitor the interactions and distances between pairs of individuals within the batch, Ultra-Wideband (UWB) sensors were utilized. Each animal was equipped with a UWB sensor collar, which continuously tracked the position and movement of the animals within the enclosure. The UWB system provided high-resolution spatiotemporal data, capturing the precise distances between each pair of animals at any given time.

The data from the UWB sensors were collected and stored in real-time, allowing for detailed analysis of the contact patterns and proximity interactions among the ruminants. 

### Ethical Considerations 

All experimental procedures involving animals were conducted in accordance with the ethical guidelines and regulations set forth by **Name of Organaization**

## Statistical Models for Estimating Probability of Transmission

In this study, we employed statistical models to estimate the probability of pathogen transmission among the small ruminants. The primary focus was on modeling the transmission probability based on observed data, with particular emphasis on the duration of each experimental interaction.

### Baseline Model

**Model 1: Probability Function and Binomial Likelihood**

As the baseline model (Model 1), we used a probability function to estimate the likelihood of transmission. The model was constructed to account for the number of cases observed per experiment, using a binomial likelihood function. This approach was chosen because it allowed us to model the discrete number of transmission events within each experimental setting. In the baseline model, the probability of transmission was assumed to be a fixed function of the duration (in minutes) of each experimental interaction. Specifically, the probability function was parameterized such that longer durations of interaction increased the likelihood of transmission. This dependency was modeled explicitly to reflect the biological plausibility that prolonged contact increases the risk of pathogen spread.


### Model Implementation
The models were implemented using a Bayesian framework, leveraging specialized software for MCMC sampling (e.g., Stan, JAGS, or similar platforms). The data from the UWB sensors, which provided detailed interaction durations, served as the input for the models. The output of the MCMC simulations included posterior estimates of the transmission probabilities, which were summarized using credible intervals to quantify the uncertainty in the estimates.



### Development of Individual-Based Models

To enhance our understanding of pathogen transmission dynamics, we extended our modeling approach beyond the baseline model to develop individual-based models. These models aimed to estimate the probability of transmission at the individual level, incorporating detailed interaction data and individual-specific factors.

**Model Structure and Probability Estimation**

The individual-based models were designed to compute the transmission probability for each contact event between individuals. The probability of an individual getting infected during a contact was modeled as a function of various factors, including the duration of contact, the infectiousness of the seeder, and the susceptibility of the contact individual. The probability function was parameterized to reflect these dependencies accurately.

**Markov Chain Monte Carlo (MCMC) Estimation**

Similar to the baseline model, we used Markov Chain Monte Carlo (MCMC) methods to estimate the posterior distributions of the parameters within the probability function. The MCMC approach allowed us to incorporate prior knowledge and update our beliefs based on the observed data, providing robust estimates of the transmission probabilities.

**Bernoulli Simulation for Transmission Events**

Once the transmission probabilities were estimated, we performed Bernoulli simulations to determine the occurrence of transmission events. For each contact event, a Bernoulli trial was conducted using the computed transmission probability. This stochastic simulation approach enabled us to capture the inherent randomness in the transmission process.

**Aggregation at the Experiment Level**

After simulating the transmission events at the individual level, we aggregated the results to the experiment level. This involved summing the number of transmission events across all contact pairs within each experimental batch. The aggregated data provided a comprehensive view of the transmission dynamics within each experiment, allowing for direct comparison with the baseline model.

#### Comparison with Baseline Model

To evaluate the performance of the individual-based models, we compared the aggregated transmission data with the results from the baseline model. The baseline model, which used a binomial likelihood to model the number of cases per experiment based on a fixed probability dependent on the duration of each experiment, served as a reference point.

**Statistical Analysis**

We conducted statistical analyses to compare the predicted number of transmission events from the individual-based models with those from the baseline model. This included calculating summary statistics, such as the mean and variance of the predicted transmission events, and performing hypothesis tests to assess the significance of any differences observed.

**Model Validation and Sensitivity Analysis**

To ensure the robustness of our findings, we validated the individual-based models using cross-validation techniques and conducted sensitivity analyses. These analyses examined the impact of varying key parameters and assumptions on the model outputs, providing insights into the reliability and generalizability of the models.

#### Ethical Considerations

All modeling and simulation procedures were conducted in accordance with ethical standards and best practices. The use of animal data was approved by the Institutional Animal Care and Use Committee (IACUC), and all efforts were made to ensure the ethical treatment of the animals during the experimental procedures.

By developing and validating individual-based models, we aimed to provide a more detailed and accurate estimation of transmission probabilities, enhancing our understanding of pathogen spread and informing public health interventions.

# Results 

In this study, we conducted a series of experiments to investigate the dynamics of infectious disease transmission among a controlled population of animals. Our primary objective was to understand how different factors, such as the duration of exposure to infected individuals (seeders) and proximity between animals, influence the likelihood of disease transmission.

We collected various types of data across multiple experiments. Specifically, we monitored infection status using serology and RT-PCR tests, gathered proximity data using Ultra-Wideband (UWB) sensors to track distances between seeder and susceptible animals, and employed advanced statistical models to analyze these data. Our analyses included a range of techniques, from basic descriptive statistics and ANOVA tests to sophisticated Bayesian modeling and predictive performance evaluation using ROC curves.

## 1. Experimental Infection Results 

### Description of Experimental Setup

To consistantly study the transmission dynamics, we conducted multiple experiments involving a controlled population of animals. Each experiment was designed to observe the progression of infection over a specified monitoring duration. Table 1 summarizes key details of these experiments, including the date, monitoring duration, number of animals involved, and the number of positive cases confirmed by serology and RT-PCR tests.

**Table 1: Summary of Experimental Infection Data Including Monitoring Duration, Number of Animals, and Number of Positives Confirmed by Serology and RT-PCR**.

**Put the table here !!!!!**

### Observations and Findings

From the data summarized in the table, we observed several key trends:

1. **Variation in Infection Rates**: The number of positive cases, as confirmed by both serology and RT-PCR, varied significantly across different experiments. This variation could be attributed to differences in monitoring duration, the number of animals, and potentially other unmeasured environmental factors.

2. **Impact of Monitoring Duration**: There was a noticeable increase in the number of positive cases with longer monitoring durations. For instance, the experiment conducted on **put date here**, with a monitoring duration of **put number of hours here**, showed a higher number of positives compared to the shorter durations.

## 2. Proximity Data from UWB Sensors

### Description of Data Collection

Proximity data was collected using Ultra-Wideband (UWB) sensors, which were attached to each animal. These sensors provided precise measurements of the distances between seeder animals (those intentionally infected) and susceptible animals (those at risk of infection) throughout the duration of each experiment. The sensors continuously recorded the distances, capturing dynamic interactions within the population. This allowed us to monitor the physical proximity and movement patterns of the animals in real-time, providing crucial data for understanding the transmission dynamics.

### Analysis of Distance Distributions

To analyze the distance distributions, we generated boxplots of the distances between seeder and susceptible pairs for each experiment. These boxplots illustrate the variability and heterogeneity in the distances across different experiments. Each figure contains 5-6 boxplots, representing the distance distributions for each pair of seeder and susceptible animals within a single experiment.

**Figure 1: Boxplots of Distances Between Seeder and Susceptible Pairs Per Experiment** 

**Table 3: AUC Values for Bayesian Models**

### Explanation of the Heterogeneity of Distance Distribution

The boxplots reveal a significant heterogeneity in the distance distributions between seeder and susceptible pairs across different experiments. Some experiments show a wide range of distances with high variability, indicating that animals were moving more freely and interacting at varying distances. Other experiments display more compact distributions with less variability, suggesting more consistent proximity patterns. This heterogeneity can be influenced by several factors, including the number of animals, the layout of the experimental setup, and behavioral differences among the animals.

## 3. Statistical Analysis: ANOVA Test

To statistically evaluate the impact of exposure duration on the number of positive cases, we performed an ANOVA test. The hypothesis tested was that the number of positives increases with longer exposure durations.

**Hypothesis**: The number of positive cases increases with longer exposure durations.

**Methodology**: We categorized the experiments based on the duration of exposure into three groups:

- Experiments with exposure duration less than 24 hours.
- Experiments with exposure duration equal to 24 hours.
- Experiments with exposure duration greater than 24 hours.
  
We then performed an ANOVA test to compare the number of positive cases across these three groups to determine if there were statistically significant differences.

**Results of the ANOVA Test**:

The results of the ANOVA test confirmed our hypothesis, showing a significant increase in the number of positive cases with longer exposure durations:

**Put the table of ANOVA results here !!!!**

This indicates that prolonged exposure to seeder animals significantly raises the likelihood of transmission. Specifically, experiments with exposure durations greater than 24 hours had a higher number of positive cases compared to those with shorter durations. This finding underscores the importance of exposure duration in the dynamics of infectious disease transmission.


## 4. Parameter Estimation results

To estimate the parameters governing the transmission dynamics, we employed Bayesian models using the No-U-Turn Sampler (NUTS) from Python's PyMC3 library. The NUTS sampler is an efficient variant of the Hamiltonian Monte Carlo (HMC) method that adapts its step size and path length automatically, providing robust parameter estimates.

### Convergence of the Chains
We ensured the convergence of the Markov Chain Monte Carlo (MCMC) chains by monitoring the Gelman-Rubin statistic  and inspecting the trace plots. All chains converged successfully, with **($\hat R$)** values close to 1, indicating reliable and stable parameter estimates.


### Parameter Estimation Results

The table below presents the summary statistics for the estimated parameters of different models. For each parameter, we report the mean, standard deviation (SD), 95% highest density interval (HDI) lower and upper bounds, and the **($\hat R$)** statistic.

**Table 2: Parameter Estimates from Bayesian Models Using MCMC with NUTS Sampler**


## 5. Predictive Performance Check

### ROC Curve Analysis

To evaluate the predictive performance of our Bayesian models, we employed Receiver Operating Characteristic (ROC) curve analysis. The ROC curve is a graphical representation that illustrates the diagnostic ability of a binary classifier system as its discrimination threshold is varied. The Area Under the Curve (AUC) is a measure of the model's ability to distinguish between classes, with a value of 1.0 indicating perfect classification and a value of 0.5 representing no better than random guessing.

### Results

We generated ROC curves for each Bayesian model to assess their predictive accuracy in distinguishing between infected and non-infected cases. The AUC values provide a quantitative measure of each model's performance. The following figure presents the ROC curves along with their corresponding AUC values for each model.


**Figure 2: ROC Curves with AUC Values for Bayesian Models**


**Table 3: AUC Values for Bayesian Models**

Draw a table of this colomns: Model, mean AUC, lower 95% CI, Upper 95% CI.

The difference between the binomial baseline model and 







