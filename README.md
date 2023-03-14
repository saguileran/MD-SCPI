# Molecular Dynamics - Sao Carlos Physics Institute (MD-SCPI)

Evaluation of the unbinding kinetics of Mineralocorticoid (MR) receptor steroid agonist Cortisol (COL) and Aldosterone (AS4) ligands.

# Table of Contents

- [Overview](#overview)
- [Objectives](#objectives)
- [Links of Interest](#links-of-interest)
- [Reports](#reports)
    - [Weekly Reports](#weekly-reports)
    - [Final Report](#final-report)
- [Output Files](#output-files)
- [References](#references)
    - [Proteins and Ligands](#proteins-and-ligands)
    - [Software](#software)

## Overview

## Objectives

- Prepare the input files: PDB and mol files of the Mineralocorticoid (MR) and MR mutation (S810L) ligands and the Aldosterone (AS4), Cortisol (COL), and Progestero (STR) proteins
- Create the Molecular Dynamics (MD) simulations for the MR/MR_mut - aldosterone/cortisol/progesteron system
- Create the Monte Carlo (MC) simulations for the MR aldosterone/cortisol/prgesteron systems
- Contrast MD and MC simulations, does the MC simulation show the same behavior as MC?

## Links of Interest

- [PDB-rcsb](https://www.rcsb.org/)
- [GaMD](http://miaolab.org/GaMD/)
- [GamD in openMM](https://github.com/ljmartin/openmm_gamd)
- [GamD](https://github.com/MiaoLab20/GaMD-OpenMM)
- [OpenMM](https://github.com/openmm/openmm)
- [LiBELa](https://github.com/alessandronascimento/LiBELa)
- [Amber Manuals](http://ambermd.org/doc12/Amber22.pdf)
- [Chimera User Guide - commands](https://www.cgl.ucsf.edu/chimera/docs/UsersGuide/framecommand.html)


## [Reports](https://saguileran.github.io/MD-SCPI/reports/)

Reports made during the internship. Here you can find weekly updates and the final report with some conclusions.


### [Weekly Reports](https://github.com/saguileran/MD-SCPI/tree/main/Reports)

### [Final Report](https://github.com/saguileran/MD-SCPI/blob/main/Reports/FinalReport.pdf)


## Output Files


<h3 align="center" margin-bottom=0>MR-AS4</h3>

<div class="container">
  <center>
    <video id="video" width="500" height="500" controls>
        <source src="./Results/MR-AS4.mp4" type="video/mp4">
    </video>
  </center>
    <div class="overlay">
        <p align="center">Mineralocorticoid (MR) protein interaction with aldosteron (AS4) ligand</p>
    </div>
</div>


<h3 align="center" margin-bottom="-10">MR-COL</h3>

<div class="container">
  <center>
    <video id="video" width="500" height="500" controls>
        <source src="./Results/MR-COL.mp4" type="video/mp4">
    </video>
  </center>
    <div class="overlay">
        <p align="center">Mineralocorticoid (MR) protein interaction with cortisol (COL) ligand</p>
    </div>
</div>


<h3 align="center" margin-bottom="-10">MD Energies</h3>

<center>
<img src="./Results/Energies.png" alt="Total energies of MR-AS4/COL systems" class="center" width="900" height="800">
</center>

This image is obtained using the [PlotEnergies.ipynb](./NoteBooks/PlotEnergies.ipynb) notebook that use jscatter pacakge to import dat files and matplotlib to plot.


<h3 align="center" margin-bottom="-10">MC Energies</h3>

<center>
<img src="./Results/MC_energies.png" alt="Total energies of MC-AS4 system" class="center" width="900" height="500">
</center>

This image is obtained using the [Plots_MC.ipynb](./NoteBooks/Plots_MC.ipynb) notebook that use jscatter pacakge to import dat files and matplotlib to plot.


## References

### Proteins and Ligands

[1] Chantal Hellal-Levy, Jérôme Fagart, Anny Souque, and Marie-Edith Rafestin-Oblin. [Mechanistic aspects of mineralocorticoid receptor activation](https://www.sciencedirect.com/science/article/pii/S0085253815468644). *Kidney International*, 57(4):1250–1255, 2000.

[2] Marie-Edith Rafestin-Oblin, Anny Souque, Brigitte Bocchi, Gregory Pinon, Jerome Fagart, and Alain Vandewalle. [The Severe Form of Hypertension Caused by the Activating S810L Mutation in the Mineralocorticoid Receptor Is Cortisone related](https://pubmed.ncbi.nlm.nih.gov/12538613/). *Endocrinology*, 144(2):528–533, 02 2003.

[3] David S. Geller, Anita Farhi, Nikki Pinkerton, Michael Fradley, Michael Moritz, Adrian Spitzer, Gretchen Meinke, Francis T. F. Tsai, Paul B. Sigler, and Richard P. Lifton. [Activating mineralocorticoid receptor mutation in hypertension exacerbated by pregnancy](https://www.science.org/doi/epdf/10.1126/science.289.5476.119). *Science*, 289(5476):119–123, 2000.

[4] Jérôme Fagart, Jessica Huyet, Grégory M. Pinon, Marina Rochel, Claudine Mayer, and Marie-Edith Rafestin-Oblin. [Crystal structure of a mutant mineralocorticoid receptor responsible for hypertension](https://www.science.org/doi/epdf/10.1126/science.289.5476.119). *Nature Structural & Molecular Biology*, 12(6):554–555, Jun 2005.


### Software


[5] Yinglong Miao, Apurba Bhattarai, and Jinan Wang. [Ligand gaussian accelerated molecular dynamics (ligamd): Characterization of ligand binding thermodynamics and kinetics](https://pubs.acs.org/doi/pdf/10.1021/acs.jctc.0c00395). *Journal of Chemical Theory and Computation*, 16(9):5526–5547, 2020. PMID: 32692556.

[6] Yinglong Miao, Apurba Bhattarai, and Jinan Wang. [Ligand gaussian accelerated molecular dynamics (ligamd): Characterization of ligand binding thermodynamics and kinetics](https://www.biorxiv.org/content/10.1101/2020.04.20.051979v1.full.pdf). *bioRxiv*, 2020.

[7] Heloisa dos Santos Muniz and Alessandro S. Nascimento. [Ligand- and receptor-based docking with LiBELa](https://pubmed.ncbi.nlm.nih.gov/26141308/). *Journal of Computer-Aided Molecular Design*, 29(8):713–723, Aug 2015.

[8] Pablo R. Arantes, Marcelo D. Polêto, Conrado Pedebos, and Rodrigo Ligabue-Braun. [Making-it-rain: Cloud-based molecular simulations for everyone](https://zenodo.org/record/5196783#.ZBBO7rTMIzN), August 2021.

[9] Matthew M. Copeland, Hung N. Do, Lane Votapka, Keya Joshi, Jinan Wang, Rommie E. Amaro, and Yinglong Miao. [Gaussian Accelerated Molecular Dynamics in OpenMM](https://pubs.acs.org/doi/10.1021/acs.jpcb.2c03765?goto=articleMetrics&ref=pdf). *The Journal of Physical Chemistry B*, 126(31):5810–5820, 2022. PMID: 35895977.

[10] Jinan Wang, Pablo R. Arantes, Apurba Bhattarai, Rohaine V. Hsu, Shristi Pawnikar, Yu-ming M. Huang, Giulia Palermo, and Yinglong Miao. [Gaussian accelerated molecular dynamics: Principles and applications](http://miaolab.org/library/documents/2021-WIREs_GaMD.pdf). *WIREs Computational Molecular Science*, 11(5):e1521, 2021.

[11] Geraldo Rodrigues Sartori and Alessandro S. Nascimento. [Comparative Analysis of Electrostatic Models for Ligand Docking](https://www.frontiersin.org/articles/10.3389/fmolb.2019.00052/full). *Frontiers in Molecular Biosciences*, 6, 2019.

[12] Heloisa S. Muniz and Alessandro S. Nascimento. [Towards a critical evaluation of an empirical and volume-based solvation function for ligand docking](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0174336). *PLOS ONE*, 12(3):1–19, 03 2017.


