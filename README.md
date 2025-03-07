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

### *2a. Installation*

A major plus about Augustus is that it is available through the Alabama Super Computer (ASC). To load Augustus using the command line, use the argument `module load augustus`. Check that Augustus loaded in properly using `module list`. 

Alternatively, Augustus can be downloaded for free on your personal device. If you are using a Windows OS, ensure that you have downloaded a Windows subsystem for Linux (WSL). I use Ubuntu, but there exists a number of WSL's, depending on your specific needs and preferences. Once you have launched your WSL, download Augustus using `sudo app install augustus`. 

**WARNING**: Augustus is a computationally intensive program. Generally, I would advise AGAINST personally downloading this software.

### *2b. Training*

While Augustus takes advantage of some of the ubiquitous elements of genes in order to identify exons, introns, etc., every organism will have some unique aspects to their genome that, unless taken into account, will DRASTICALLY lower the accuracy of the program's predictions. Therefore, it is **crucial** that you train Augustus for your specific species!

Step 1) Adding your species to the Augustus

Check to see if your organism is in the Augustus database by using the command`augustus --species=help`. You should see an output like this: 

<img src="https://github.com/user-attachments/assets/ed2dc343-0c96-4e9b-b93b-442fcc51e8fc" alt="Screenshot" width="300" height="300"/>

If your species is not listed, then you will need to add it yourself! 
- Within Augustus, the "species" directory exists within the "config" directory. The first step in adding a species to Augustus is specifying the path to the config directory.
- To search for this path in ASC, use the command `find / -type d -name "config" 2>/path/to/error_out | grep "augustus"`. This searches the entire database for the config directory path. Note, this command will take some time to run! Admittedly, it may be inefficient, but I have found this general command to be the most reliable way to find a file or directory in the ASC. A breakdown of this command can be found below:
   - `find /`: The find command searches a given database. By specifying " / ", we are telling the command to begin at the outer most directory (i.e. search the whole ASC)
   - `-type d`: This flag specifies that we are search for a directory.
   - `-name config`: This flag specifies the name of the directory
   - `2>/path/to/error_out`: This command redirects error outputs to where you keep your error outputs. I have found that without this command, your working directory becomes clogged with "permission denied" error outputs, as many of the directories in the ASC are not available to users.
   - `| grep "augustus"`: This pipes the outputs of the find command to grep, which filters for output paths containing the word "augustus".

 - Next, store this path in a variable the AUGUSTUS_CONFIG_PATH.
 - Finally, run the command `new_species.pl --species=your_species_name`
 - If made properly, your species directory should contain several metaperameter files:
 
  <img src="https://github.com/user-attachments/assets/28a17eb0-b8cd-443f-bf4b-e5e34712d52b" alt="Screenshot" width="600" height="70"/>

Step 2) Training 
- The **necessary input** for training Augustus is an .gff format file containing annotated gene structures. If there does not exist a .gff file of your organism, use one of a closely related species.
- First, use `randomSplit.pl your_species_genes.gbff 100` to randomly split your .gff file into a training file and a test file
 - Specifyong a number tells randomSplit.pl how many genes to go into the training file. I have found that training with at least 100 genes gives you the best results
- Next, train Augustus using `etraining --species=your_species your_species.gbff.train`
- Once training has completed, you are ready to make an initial run with Augustus! Use `augustus --species=your_species your_species.gbff.test > test_1.out`. The goal here is to evaluate the quality of our training step. The result will be a prediction of the genes in your test file. Augustus also generates an accuracy report at the end of this output.
- Use `grep -A 22 Evalutation test_1.out` to print the last 22 lines of accuracy report. You should see something like this:

<img src="https://github.com/user-attachments/assets/440a8ca1-e4e1-4efa-97bd-d416c1e2ea1f" alt="Screenshot" width="620" height="300"/>

- If you wish to increase the quality of your training, you can run `optimize_augustus.pl --species=your_species your_species.gb.train` and then use `etraining` to retrain Augustus exactly as you did previously. **WARNING**: This optimization step can be quite slow- depending on the size of your trainin file, it could take a day or longer!

Congratulations! Augustus has been successfully trained!

### *2c. Running Augustus*



     
