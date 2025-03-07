# Augustus: A Guide to *ab initio* Gene Prediction
## Section 1: Introduction

*Preface*: All of the code shown was written in **Shell**. Make sure that this is compatible with your computational setup!


Augustus was first developed by Mario Stanke, Oliver Keller, Stephan Waak, and Burkhard Morgansterm in 2005 for the goal of improving *ab initio* gene prediction technology. Since 2005, this software has undergone multiple updates, with the most current version being 3.5.0 released in 2022. For this tutorial, I will be using the **3.5.0 update**, so be aware that not everything here may be applicable to your project depending on what version your work necessitates or is available to you. 

The phrase *ab initio* comes from Latin and means "from the beginning" or "from scratch". This type of gene prediction relies on the genomic DNA sequence itself to identify coding regions rather than outside outside sources. This is considerably different from a similiarity based approach, like that used by NCBI BLAST, which predicts genes based on homology to gene regions in related organisms. So how do you decide if Augustus is an appropriate tool for your job? Augustus is most useful when:

- You are working with a *de novo* genome. That is, a newly generated genome that may be poorly annotated. Such a genome is likely to be at the contig level assembly, which Augustus is well suited at parsing!
- It is relevant that gene predictions be made using genomic structure rather than sequence similarity. This is important to consider if you are working with a poorly represented group.
- You are interested in gene structure, as Augustus is capable of providing infromation regarding exons, introns, UTR's, and gene boundaries

## *1a. How does Augustus Work?*

Augustus functions by utilizing a Hidden Markov Model (HMM). DNA does not tell you "Hey, this sequence is an exon! This is a non-coding region!". The "state" of particular sequence is "hidden" or unknown from a program (or scientist!). But hope is not lost! DNA is not random, there are known sequence motifs and structural elements that are associated with different regions of genes (start/stop codons, splice sites, GC content, and so on). In the context of gene predictions, an HMM can be optimized to look at these elements and generate a probability of the state or condition of a particular DNA sequence.

This is what Augustus does. By using an HMM, the program is able to predict exons, introns, and other gene regions using the DNA sequence itself- no need for outside genomes! For more information regarding the mathematics behind how the HMM functions, check out [Gene Prediction with a Hidden Markov Model
and a new Intron Submodel](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=3c3191884b032af136b610ae5f67602f0e00508b)

What do I need to get started?

1) Your species genome in a .fasta format
2) A list of annotated genes in a .gff format (.gff3 and .gbff are acceptable!) If there are no annotated genes for your organism, you can use those from a closely related species. Alternatively, it is acceptable if you only having coding sequences in a .gff format. 

## Section 2: Using Augustus

### *2a. Installation*

A major plus about Augustus is that it is available through the Alabama Super Computer (ASC)! To load Augustus using the command line, use the argument `module load augustus`. Check that Augustus loaded in properly using `module list`. 

To load Augustus in a script (recommended):

<img src="https://github.com/user-attachments/assets/679c54af-eb88-4f76-a990-bf220f460a24" alt="Screenshot" width="300" height="70"/>


Alternatively, Augustus can be downloaded for free on your personal device. If you are using a Windows OS, ensure that you have Windows Subsystem for Linux (WSL) downloaded. Once you have launched your WSL, download Augustus using `sudo app install augustus`. 

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

 - Next, store this path in a variable the AUGUSTUS_CONFIG_PATH (`AUGUSTUS_CONFIG_PATH=path/to/config`).
 - Finally, run the command `new_species.pl --species=your_species_name`
 - If made properly, your species directory should contain several metaperameter files:
 
  <img src="https://github.com/user-attachments/assets/28a17eb0-b8cd-443f-bf4b-e5e34712d52b" alt="Screenshot" width="600" height="70"/>

Step 2) Training 
- The **necessary input** for training Augustus is a .gff format file containing annotated gene structures. If there does not exist a .gff file of your organism, use one of a closely related species.
- First, use `randomSplit.pl your_species_genes.gbff 100` to randomly split your .gff file into a training file and a test file
 - Specifyong a number tells randomSplit.pl how many genes to go into the training file. I have found that training with at least 100 genes gives you the best results
- Next, train Augustus using `etraining --species=your_species your_species.gbff.train`
- Once training has completed, you are ready to make an initial run with Augustus! Use `augustus --species=your_species your_species.gbff.test > test_1.out`. The goal here is to evaluate the quality of our training step. The result will be a prediction of the genes in your test file. Augustus also generates an accuracy report at the end of this output.
- Use `grep -A 22 Evalutation test_1.out` to print the last 22 lines of accuracy report. You should see something like this:

<img src="https://github.com/user-attachments/assets/440a8ca1-e4e1-4efa-97bd-d416c1e2ea1f" alt="Screenshot" width="620" height="300"/>

- If you wish to increase the quality of your training, you can run `optimize_augustus.pl --species=your_species your_species.gb.train` and then use `etraining` to retrain Augustus exactly as you did previously. **WARNING**: This optimization step can be quite slow- depending on the size of your trainin file, it could take a day or longer!

Congratulations! Augustus has been successfully trained!

### *2c. Running Augustus*

The general command structure that your augustus argument will follow (and as we've seen above) is: `augustus -parameters --species=your_species queryfile`. When running Augustus, there are many parameters that you are able to specify. For a full list, use `augustus --help`. I have listed some of the parameters that I have found most relevant, but remeber to always look at *your* data!
- --genemodel=partial, --genemodel=intronless, --genemodel=complete, --genemodel=atleastone or --genemodel=exactlyone
  - This allows you to specify what type of gene model your input file is. --genemodel=partial is particularly useful when your genome is at the contig level! It prevents Augustus from ignoring exons that are fragmented amoung seperate contigs
- --genemodel=intronless
 -This allows for prediction of coding regions in genomes that don't have introns. Use this when working with bacterial species!
- --strand=both, --strand=forward or --strand=backward
  - By default, Augustus searches both strands for gene regions. By specifing either the forward or reverse strand, this directs Augustus to only focus on one or the other. The strand is important to consider if your input is single stranded, like some viral genomes!
- --UTR=on/off
   - By toggling this parameter on (deafault is off), you can predict the UTR's in your input file in addition to coding sequences. If you decide to use this parameter, you MUST train Augustus to identify UTR's first. Currently, this option is optimized for only a handful of species (human, fruit fly, arabidopsis), and I have found that even after training, these predictions tend to be low quality.
- --hintsfile=hintsfilename
  - Hints are extra information that you can provide Augustus to improve the quality of its predictions. While not necessary, I have found this option to be useful if the approrpriate information is available to you.
  - Currently, Augustus is able to accept 16 types of hints, including information regarding exons, introns, and splice sites. To use a hint, this file must be in a .gff format! You can generate these files yourself by aligning protein or RNA-seq data to your genome and formatting the output file appropriately. If such files are publically available on databases such as NCBI, this also acceptable. You can even provide the annotated gene .gff file you used to initially train Augustus as a hint, but I have generally found this to be less helpful.
- --predictionStart=A, --predictionEnd=B
  - You can specify the region in your sequence you wish to predict coding regions.
- --protein=on
  -Amino acid sequences of your predicted genes will be generated

Once you have run Augustus, the output file will be in a .gff format. It should look something the one featured below. Remember, depending on what parameters you set, the output may look slight different!

<img src="https://github.com/user-attachments/assets/d3679cb4-418d-400e-8763-642d318e8c62" alt="Screenshot" width="999" height="300"/>

- Column 1: Sequence name. This refers to where the predicted region is (what scaffold or contig).
- Column 2: Source. This tells you what was used to make the annotation. If the source is a previously annotated genome, it is typically referred to as "database".
- Column 3: Feature. This tells you what the region is predicted to be (coding sequence, intron, etc.)
- Column 4: Start. The start tells you where the predicted region begins.
- Column 5: End. The end tells you where the predicted region ends.
- Column 6: Score. Augustus will typically assign a score to the prediction from 0 - 1, with unassigned being labeled as a " . " .
- Column 7: Strand. This tells you which strand the predicted region is on. A " . " indicates that the strand is not relevant (usually for repeats). 
- Column 8: Frame. This specifies the reading frame.
- Column 9: Attributes. This column gives you additional information regarding the sequence, such as the gene ID.

Congratulations! You have learned how to 1) train Augustus and 2) use Augustus to predict features in your genome! 

## Section 3: What Now?

### *3a. Next steps*

What you do with the information gained from Augustus will depend heavily on your needs, but here are some directions to get you started!

1) While Augustus provides a quality report in its output, I find it necessary to further determine the quality and completness of the predictions using tools like BUSCO. 
2) If your end goal is to characterize gene models in a non-model organism, a likely next step for you is to compare the predicted gene sequences generated by Augustus with other data (RNA-seq and cDNA-alginments). This can help you to validate gene length, boundaries, sequences, and so on.
3) If your project focuses on proteins of the predicted genes, you can extract the amino acid sequences from the Augustus output file by using `getAnnoFasta.pl Your_species_output.gff > predicted_aminoacids.out`. **NOTE**: If you have not toggled on the protein parameter, amino acid sequences will not be generated!

### *3b. Summary*

In this tutorial, we covered how to install, train, and run Augustus. As you have seen, Augustus is a simple yet powerful tool that is used to predict genes and genome structures in *de novo* genomes. Augustus is going to be most useful when you are working in non-model organisms, under-represented taxa, or species with poorly annotated genomes. These predictions can be utilized to validate coding regions, identify regulatory regions, and ultimately they can be used to gain a deeper insight to gene organization and function. Some helpful tips when running Augustus:

1) As aforementioned, Augustus is computationally EXPENSIVE. Depending on the size of your input files, it can take a lot of memory and a long time to run. I would reccomend initially running your job on the ASC for an hour and seeing how far the job was able to run. Use this to gauge how much time and memory to specify.
2) Providing a masked fasta file as the input can help Augustus run faster and generate higher quality predictions. I prefer to use RepeatModeler and RepeatMasker to accomplish this. Documentation for both can be found below in Resources.
3) Depending on what system you are using to run Augustus, you may not have permissions to add a species directory to Augustus' database! To get around this, you will need to copy the config directory using `cp -r` into your working directory. In this event, update the location of the Augustus config directory in your variable `AUGSUSTUS_CONFIG_PATH`.

### *3c. Resources*

This tutorial is meant to act as a basic guide for Augustus. This program has extensive documentation and additional guides, which I have provided below:
1) [Visit the Official Augustus Website](https://bioinf.uni-greifswald.de/augustus/)
2) [Augustus GitHub](https://github.com/Gaius-Augustus/Augustus/blob/master/docs/RUNNING-AUGUSTUS.md)
3) [Highly detailed guide to training Augustus](https://vcru.wisc.edu/simonlab/bioinformatics/programs/augustus/docs/tutorial2015/training.html)
4) [AUGUSTUS: ab initio prediction of alternative transcripts](https://academic.oup.com/nar/article/34/suppl_2/W435/2505582)
5) [Video demonstration of Augustus](https://rnnh.github.io/bioinfo-notebook/docs/augustus.html)
6) [How to use RepeatModeler and RepeatMasker](https://darencard.net/blog/2022-07-09-genome-repeat-annotation/)
7) [RepeatMasker Documentation](https://www.animalgenome.org/bioinfo/resources/manuals/RepeatMasker.html)

     
