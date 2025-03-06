# Augustus: A Guide to *ab initio* Gene Prediction
## Section 1: Introduction

*Preface*

This tutorial was made using bash scripting. Bash 


Augustus was first developed by Mario Stanke, Oliver Keller, Stephan Waak, and Burkhard Morgansterm in 2005 for the goal of improving *ab initio* gene prediction technology. Since 2005, this software has undergone multiple updates, with the most current version being 3.5.0 released in 2022. For this tutorial, I will be using the **3.5.0 update**, so be aware that not everything here may be applicable to your project depending on what version your work necessitates or is available to you. 

The phrase *ab initio* comes from Latin and means "from the beginning" or "from scratch". This type of gene prediction relies on the genomic DNA sequence itself to identify coding regions rather than outside outside sources. This is considerably different from a similiarity based approach, like that used by NCBI BLAST, which predicts genes based on homology to gene regions in related organisms. So how do you decide if Augustus is an appropriate tool for your job? Augustus is most useful when:

- You are working with a species that does not have a well annotated genome. This is particularly true for when you species also does not have a closely related relative with an annotated genome.
- It is relevant that gene predictions be made using genomic structure rather than sequence similarity. This is important to consider if you are working with a poorly represented group.
- You are interested in gene structure, as Augustus is capable of providing infromation regarding exons, introns, UTR's, and gene boundaries

*1a. How does Augustus Work?*

Augustus functions by utilizing the Hidden Markov Model (HMM). DNA does not tell you "Hey, this sequence is an exon! This is a non-coding region!". The "state" of particular sequence is "hidden" or unknown from a program (or scientist!). But hope is not lost! DNA is not random, there are known sequence motifs and structural elements that are associated with different regions of genes (start/stop codons, splice sites, GC content, and so on). In the context of gene predictions, an HMM can be optimized to look at these elements and generate a probability of the state or condition of a particular DNA sequence.

This is what Augustus does. By using an HMM, the program is able to predict exons, introns, and other gene regions using the DNA sequence itself- no need for outside genomes! For more information regarding the mathematics behind how the HMM functions, check out INSERT PAPER LATER

## Section 2: Using Augustus

*2a. Installation*

A major plus about Augustus is that it is available through the Alabama Super Computer (ASC). To load Augustus using the command line, use the argument `module load augustus`. Check that Augustus loaded in properly using `module list`. 

Alternatively, Augustus can be downloaded for free on your personal device. If you are using a Windows OS, ensure that you have downloaded a Windows subsystem for Linux (WSL). I use Ubuntu, but there exists a number of WSL's, depending on your specific needs and preferences. Once you have launched your WSL, download Augustus using `sudo app install augustus`. 
**WARNING**: Augustus is a computationally intensive program. Generally, I would advise AGAINST personally downloading this software.
