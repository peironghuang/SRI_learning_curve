# ***Related Software Checklist***

## **1. System Requirements**

- Hardware and Operating System

  All of the analyses were performed on Dell Desktop with Windows 8.1 Enterprise and Intel(R) Core(TM) i7-6600U CPU @ 2.60GHz 2.80GHz, with 8.00GB RAM and 64-bit OS, x64-based processor.

- Software and Versions

  We used *R (3.3.2)* and *Stata (15.1)* during the research. In addition, *RStudio (1.0.153)* is also used as an IDE of *R*. 

## **2. Installation Guide**

- Instructions

  - Stata
  
  1. Please unzip the file "STATA15.1_windows_64.zip" in "0-software".
  1. Please direct to the subfolder "STATA15.1\\Stata15\\".
  1. Double click the program "StataSE-64.exe" to open *Stata*.
  1. This is a green version of *Stata* and you do not need to install it.

  - R

  1. PLEASE INSTALL *R* BEFORE *RSTUDIO*.
  1. Double click the installation file "R-3.3.2-win.exe" in "0-software".
  1. Select your preferred language.
  1. Click "Next" to the end.
  1. Please make sure you have at least 170MB space on your disk to install *R*.

  - RStudio

  1. *RStudio* is not mandatory to run *R* codes but is highly recommended.
  1. Double click the installation file "RStudio-1.0.153.exe" in "0-software".
  1. Click "Next" to the end.
  1. Please make sure you have additional 200MB space on your disk to install *RStudio*.
  1. **Double click the "RStudio" icon on your Desktop, or search "RStudio" in your System Main Menu to launch the *Rstudio* and run *R* codes**.

- Typical Installation Time

  - Stata

    You do not need to "install" Stata. It is a green version.

  - R

    Less than **5 minutes**
  
  - RStudio

    Less than **5 minutes**

## **3 & 4. Demo and Instructions for Use**

- Stata

  1. *Stata* codes is to fit a survival model for the learning curve, and draw the plot for *Figure 7b*.
  1. The input is in the folder "1-data\\Stata\\Stata_input".
  1. Please unzip *Stata* properly according to the installation guide, and double click the program "StataSE-64.exe" to open *Stata*.
  1. Press "Ctrl+O" or click the menu "File" -> "Open" and select the *Stata* script file "predictive_learning_curve.do" in folder "1-data\\Stata\\".
  1. In line 7 of this file, please replace the working directory with the folder where you put "predictive_learning_curve.do".
  1. Please be sure to input the absolute path of your working directory, that is, your working directory should start with "C:\\" or "D:\\", etc..
  1. Press "Ctrl+A" to select all the codes in this script, and then press "Ctrl+D" to run the codes.
  1. The output of the code will go to "1-data\\Stata\\Stata_output". Please note that this folder is empty before you run the code, except for a "readme.txt".
  1. The expected output is put in "1-data\\Stata\\Stata_Expected_Output".
  1. Typically it will take less than **2 seconds** to run the code.
  1. **Please be sure to input the correct absolute working directory to reproduce our output.**

- R

  1. *R* code is to draw cumulative cases of the complications for a specific surgeon and fit an exponential curve for it. In addition, this *R* script also draws the derivative curves of the fitted exponential curve.
  1. The input is in the folder "1-data\\R\\R_input".
  1. Double click the "RStudio" icon on your Desktop, or search "RStudio" in your System Main Menu to launch the *Rstudio* and run *R* codes.
  1. Press "Ctrl+O" or click the menu "File" -> "Open File" and select the *R* script "complication.R" in folder "1-data\\R\\".
  1. At the first time you run our *R* code, please run the code in Appendix to install the dependent package.
  1. In line 5 of this file, please replace the working directory with the folder where you put "complication.R".
  1. Please be sure to input the absolute path of your working directory, that is, your working directory should start with "C:\\" or "D:\\", etc..
  1. Press "Ctrl+A" to select all the codes in this script, and then press "Ctrl+ENTER" to run the codes.
  1. If you want to get the output of another surgeon, please comment line 9 (Position the Cursor to line 9 and press "Ctrl+Shift+C", or input "#" at the very beginning of line 9), and uncomment line 10 (Position the Cursor to line 10 and press "Ctrl+Shift+C", or delete the "#" at the very beginning of line 10)
  1. The output of the code will go to "1-data\\R\\R_output". Please note that this folder is empty before you run the code, except for a "readme.txt".
  1. The expected output is put in "1-data\\R\\R_Expected_Output".
  1. Typically it will take less than **2 seconds** to run the code.
  1. **Please be sure to input the correct absolute working directory and install the required package to reproduce our output. Please make sure to select a different surgeon in the script to get different output.**

## **5. Pseudocode**

- Stata

  1. Import data.
  1. Create dummy variables used in the model.
  1. Create knots for surgeon experience (will be put at the quartiles).
  1. Create restricted cubic splines.
  1. Determine survival time model data.
  1. Model the multivariable model, with survival times assumed to follow a log-logistic distribution. Covariates are surgeon experiences, usage of drugs (PBS/Alu RNA) and complications. We specify the *cluster* option in the model by using *surgeon*, since operation experience of a same surgeon is not independent.
  1. Calculate adjusted, 7-day-predicted success rate of the SRI.
  1. Calculate predicted survival probability and 95% confidence intervals and obtain prediction for 7 days.
  1. Plot predicted probability of postoperative SRI success rate against surgeon experience (cases).
  1. Output the plot and the data.

- R

  1. Get surgeon name from the data file.
  1. Read in data.
  1. Calculate the cumulative sum of the complications.
  1. Loop starts among different complications.
  1. Fit the exponential curve for the cumulative sum of the complications.
  1. Calculate the plateau of the curve.
  1. Draw the cumulative sum and the fitted exponential curve.
  1. Draw the derivative curve of the exponential curve.
  1. Output the plots.
  1. Loop ends.

## **Appendix: R code to install required package**

```R
install.packages('data.table')
```
