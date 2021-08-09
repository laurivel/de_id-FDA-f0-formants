#########################################################################################################
#
# These lines will create de-identified f0 curves using fPCA.
# Please remember to add correct directories; The lines need to be adjusted for your data.
# 
# Lauri Tavi 5.12.2020
#
#########################################################################################################

library("fda")
library("fda.usc")
library("tidyverse")

load("C://male_f0_fd.Rdata") # SEX

# Exclude some of the AVOID data
#f0_fd <- f0_fd[grep("s12", invert = TRUE, f0_fd$fdnames$reps)]
#f0_fd <- f0_fd[grep("s13", invert = TRUE, f0_fd$fdnames$reps)]
#f0_fd <- f0_fd[grep("s05", invert = TRUE, f0_fd$fdnames$reps)]
f0_fd_modal <- f0_fd[grep("t2", f0_fd$fdnames$reps)]

# Initialize tables for the collection of coefficients
child_coefficients <- data.frame(matrix(ncol = n_knots+2, nrow = length(f0_fd_modal$fdnames$reps)))# SEX/NCOL
rownames(child_coefficients) = f0_fd_modal$fdnames$reps

# PCA
lambda_pca    <- lambda
pcafdPar  <- fdPar(basis, 2, lambda_pca)
pcafd <- pca.fd(f0_fd , nharm=30, pcafdPar)
rownames(pcafd$scores) <- f0_fd$fdnames$reps
plot.pca.fd(pcafd, nx=40, harm = 1)

# Adding labels for pcafd
for (i in rep(1:(length(pcafd$scores[,1])))) {
	if (str_detect(rownames(pcafd$scores)[i], "t2")) {
	rownames(pcafd$scores)[i] <- "modal"
	} else if (str_detect(rownames(pcafd$scores)[i], "t3")) {
	rownames(pcafd$scores)[i] <- "elderly"
	} else {
	rownames(pcafd$scores)[i] <- "child"
	}
}

# Define the modelling data (here "child")
child_scores <- subset(pcafd$scores, rownames(pcafd$scores) %in% "child")
child_names <- f0_fd$fdnames$reps[grep("t4", f0_fd$fdnames$reps)]

# and collect their MEAN PCA SCORES
child_mean_pc1 <- mean(child_scores[,1])

# then define the data which you want to de-identify.
modal_scores <- subset(pcafd$scores, rownames(pcafd$scores) %in% "modal")
modal_mean_pc1 <- mean(modal_scores[,1])
modal_names <- f0_fd$fdnames$reps[grep("t2", f0_fd$fdnames$reps)]


mean_fd <- mean.fd(f0_fd)

# Split data by speakers
sps <- substr(f0_fd$fdnames$reps, 1, 3)
sps_u <- unique(sps)
a = 1

# collect data points for each speaker
for (s in sps_u) {

	# Target speaker
	rownames(modal_scores) <- modal_names
	target_scores <- modal_scores[grepl(s, rownames(modal_scores)), ]
	scores = target_scores[,1:30]

	# Child mean for target speaker
	rownames(child_scores) <- child_names
	target_child_scores <- child_scores[grepl(s, rownames(child_scores)), ]
	# MEAN
	target_child_mean_pc1 <- mean(abs(target_child_scores[,1]))

	print(s)

	# Reconstruction
	PC1 <- pcafd$harmonics[1]
	PC2 <- pcafd$harmonics[2]
	PC3 <- pcafd$harmonics[3]
	PC4 <- pcafd$harmonics[4]
	PC5 <- pcafd$harmonics[5]
	PC6 <- pcafd$harmonics[6]
	PC7 <- pcafd$harmonics[7]
	PC8 <- pcafd$harmonics[8]
	PC9 <- pcafd$harmonics[9]
	PC10 <- pcafd$harmonics[11]
	PC11 <- pcafd$harmonics[11]
	PC12 <- pcafd$harmonics[12]
	PC13 <- pcafd$harmonics[13]
	PC14 <- pcafd$harmonics[14]
	PC15 <- pcafd$harmonics[15]
	PC16 <- pcafd$harmonics[16]
	PC17 <- pcafd$harmonics[17]
	PC18 <- pcafd$harmonics[18]
	PC19 <- pcafd$harmonics[19]
	PC20 <- pcafd$harmonics[20]
	PC21 <- pcafd$harmonics[21]
	PC22 <- pcafd$harmonics[22]
	PC23 <- pcafd$harmonics[23]
	PC24 <- pcafd$harmonics[24]
	PC25 <- pcafd$harmonics[25]
	PC26 <- pcafd$harmonics[26]
	PC27 <- pcafd$harmonics[27]
	PC28 <- pcafd$harmonics[28]
	PC29 <- pcafd$harmonics[29]
	PC30 <- pcafd$harmonics[30]

	# Loop through the curves, recontract them using PCs and collect the reconstracted curves
	# Reconstract the curves
	for (i in rep(1:(length(scores[,1])))) {
		pca_curve = mean_fd + target_child_mean_pc1*PC1 + scores[i,2]*PC2 + scores[i,3]*PC3 +
		scores[i,4]*PC4 + scores[i,5]*PC5 + scores[i,6]*PC6+scores[i,7]*PC7 + scores[i,8]*PC8 +
		scores[i,9]*PC9 + scores[i,10]*PC10 + scores[i,11]*PC11 + scores[i,12]*PC12 + scores[i,13]*PC13 +
		scores[i,14]*PC14 + scores[i,15]*PC15 + scores[i,16]*PC16 + scores[i,17]*PC17 + scores[i,18]*PC18 +
		scores[i,19]*PC19 + scores[i,20]*PC20 + scores[i,21]*PC21 + scores[i,22]*PC22 + scores[i,23]*PC23 + 
		scores[i,24]*PC24 + scores[i,25]*PC25 + scores[i,26]*PC26 + scores[i,27]*PC27 + scores[i,28]*PC28 +
		scores[i,29]*PC29+scores[i,30]*PC30
	
		# collect data_points
		pca_curvefdata <- fdata(child_curve)
		pca_coefficients[a,] <- as.numeric(pca_curvefdata$data)
		pca_coefficients[a,] = 100*exp(pca_coefficients[a,]*log(2)/12)

		a = a + 1
	}
}

plot(child_curve)

write.table(child_coefficients, "C:/.../m_child_coefficient.txt", append = FALSE, sep = " ", row.names = TRUE, col.names = TRUE, quote = F)

# Test Check!!!!
test_curve = mean_fd + scores[i,1]*PC1 + scores[i,2]*PC2 + scores[i,3]*PC3 +
scores[i,4]*PC4 + scores[i,5]*PC5 + scores[i,6]*PC6+scores[i,7]*PC7 + scores[i,8]*PC8 +
scores[i,9]*PC9 + scores[i,10]*PC10 + scores[i,11]*PC11 + scores[i,12]*PC12 + scores[i,13]*PC13 +
scores[i,14]*PC14 + scores[i,15]*PC15 + scores[i,16]*PC16 + scores[i,17]*PC17 + scores[i,18]*PC18 +
scores[i,19]*PC19 + scores[i,20]*PC20 + scores[i,21]*PC21 + scores[i,22]*PC22 + scores[i,23]*PC23 + 
scores[i,24]*PC24 + scores[i,25]*PC25 + scores[i,26]*PC26 + scores[i,27]*PC27 + scores[i,28]*PC28 +
scores[i,29]*PC29+scores[i,30]*PC30
	
# collect data_points
test_curvefdata <- fdata(test_curve)
coefs <- as.numeric(test_curvefdata$data)

op <- par(mfrow=c(1,4))
plot(test_curvefdata, ylim=c(-10,20))
plot(f0_fd[1760], ylim=c(-10,20))
plot(coefs,ylim=c(-10,20))
lines(coefs,ylim=c(-10,20))
plot(100*exp(coefs*log(2)/12))
lines(100*exp(coefs*log(2)/12))