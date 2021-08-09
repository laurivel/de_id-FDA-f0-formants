####################################################################################
# This R script will extract pitch trajectories from speech signals and transform them 
# into FDA objects. Please remember to add correct directories. Some parts are adapted from
# https://github.com/uasolo/FPCA-phonetics-workshop (by Michele Gubian).
#
# Lauri Tavi 3.12.2020
# 
####################################################################################

# Libraries
library("PraatR")
library("fda")

# Parameters
# Directory for speech signals
PitchDirectory = "D:/../"

# Pitch settigngs
min_pitch = 140 # 65
max_pitch = 550 # 400

# Directory for R data
r_data = "C:/.../f0_fd.Rdata"

# A list for f0 values
f0_list = list()

# A list for time values
time_list = list()


FullPath = function(Target_file){ return( paste(PitchDirectory,Target_file,sep="") ) }
PitchArguments = list(0.01, min_pitch, max_pitch)

if (file.exists(r_data)) {
	setwd(PitchDirectory)
	files = list.files()
	files
	load(r_data)
} else {
	# Extract pitch curves
	setwd(PitchDirectory)
	files = list.files()
	files
	for (i in files) {
		WavePath = FullPath(i)
		PitchPath = sub(WavePath,pattern=".wav",replacement=".Pitch")
		PitchTierPath = sub(WavePath,pattern=".wav",replacement=".PitchTier")

		# Pitch analysis
		praat( "To Pitch...", arguments=PitchArguments, input=WavePath, output=PitchPath, overwrite=TRUE )
		praat( "Interpolate", input=PitchPath, output=PitchPath, overwrite=TRUE)
		praat( "Down to PitchTier", input=PitchPath, output=PitchTierPath, overwrite=TRUE, filetype="headerless spreadsheet" )

		# Read in the PitchTier
		PitchTierData = read.table(PitchTierPath, col.names=c("Time","F0"))

		# Save time and F0 information in variables 
		Time = PitchTierData$Time
		time_list[[i]] = Time
		F0 = PitchTierData$F0
		F0 <- 12*log(F0/100)/log(2)
		f0_list[[i]] = F0
	}

	order_list = list()
	order = c()
	n_curves = length(f0_list)

	for (z in rep(1:(length(f0_list)))) {
		time0 = length(f0_list[[z]])-1
		order2 = rep(0:time0)
		order_list[[z]] = order2
		order = c(order,tail(order2,1))
	}


	# FDA
	# obligatory linear time normalisation
	mean_or = mean(order)

	norm_range <- c(0,mean_or)

	# try different parameters for b-splines
	n_knots = 200
	lambda = 1e-8

	Lfdobj <- 2 # 2 + order of derivative expected to be used.
	norder <- 2 + Lfdobj  # a fixed relation about B-splines
	nbasis <- n_knots + norder - 2 # a fixed relation about B-splines
	basis <- create.bspline.basis(norm_range, nbasis, norder)
	fdPar <- fdPar(basis, Lfdobj, lambda)

	# smooth all curves
	f0_coefs = array(dim = c(nbasis,n_curves))
	for (i in 1:n_curves) {
		t_norm = (order_list[[i]] / order[i]) * mean_or # linear time normalisation
	    	f0_coefs[,i] = c(smooth.basis(t_norm,f0_list[[i]],fdPar)$fd$coefs)
	}

	f0_fd = fd(coef=f0_coefs, basisobj=basis)
	f0_fd$fdnames$reps <- files
	save.image(file=r_data)
}

plot(f0_fd)

