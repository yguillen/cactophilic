# Genome-wide patterns of sequence divergence of protein-coding genes between Drosophila buzzatii and D. mojavensis #

Files and scripts for the analysis of the protein coding genes divergence in cactophilic Drosophila
Authors: Yolanda Guillén, Sònia Casillas and Marta Coronado

CSV files:

divergence_table.csv

# Columns #
  # parameter: dn, ds or omega
  # chr: Chromosome 
  # position: bp position in Drosophila mojavensis 
  # value: value of dn, ds or omega
  # length: Protein lenght (in aminoacids) in Drosophila buzzatii genome
  # Exons: Number of exons in Drosophila buzzatii genome
  # FBgn: Flybase gene ID
  # FBpp: Flybase protein ID
  # state: Gene located within a rearranged (1) or non-rearranged (0) segment considering fixed inversions
  # recomb: Gene located within non-recombining chromosome 6 and 3-Mb centromeric region (1) or in regions with presumably normal levels of recombination (0)
  # type: X-linked (1) or autosomal (0) region
  # breadth: Number of life stages (0-5) in which each gene is expressed using a minimu FPKM threshold of 1
  # normexp: Maximum FPKM value observed across 5 life stages.


divergence_window_100kb_table.csv

# Columns #
# Position: Range non-overlapping window in Drosophila mojavensis. Position 1 refers to range (1-100kb), position 1000001 range (1001kb-200kb), etc.
# Chr: Chromosome 
# variable: dn, ds or omega
# value: value of dn, ds or omega
