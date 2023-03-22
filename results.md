---
permalink: /results/
layout: single
search: true
author_profile: false
toc_sticky: true
toc: true
toc_label: "Results"
toc_icon: 'photo-film'
sidebar:
  nav: "reports"

MC_images:
  - url: "https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-AS4.png"
    image_path: "https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-AS4.png"
    alt: 'RMSD MR-AS4 MC'
    title: 'RMSD MR-AS4 MC'
  - url: 'https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-COL.png'
    image_path: 'https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-COL.png'
    alt: 'RMSD MR-COL MC'
    title: 'RMSD MR-COL MC'
  - url: "https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-STR.png"
    image_path: "https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-STR.png"
    alt: 'RMSD MR-STR MC'
    title: 'RMSD MR-STR MC'
  - url: 'https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-AS4_mut.png'
    image_path: "https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-AS4_mut.png"
    alt: 'RMSD MR_S810L-AS4 MC'
    title: 'RMSD MR_S810L-AS4 MC'
  - url: 'https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-COL_mut.png'
    image_path: "https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-COL_mut.png"
    alt: 'RMSD MR_S810L-COL MC'
    title: 'RMSD MR_S810L-COL MC'
  - url: "https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-STR_mut.png"
    image_path: "https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-STR_mut.png"
    alt: 'RMSD MR-STR_mut MC'
    title: 'RMSD MR_S810L-STR MC'
---

# Movies

## Molecular Dynamics

<h3 align="center" margin-bottom="-10">MR-COL MD simulation</h3>

<div class="container">
  <center>
    <video id="video" width="500" height="500" controls>
        <source src="https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MR-COL.mp4" type="video/mp4">
    </video>
  </center>
    <div class="overlay">
        <p align="center">Mineralocorticoid (MR) protein interaction with cortisol (COL) ligand</p>
    </div>
</div>


## Monte Carlo 


# Images

## Molecular Dynamics

<img src='https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/Energies.png' alt="MD energies">

## Monte Carlo 

<img src="https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_energies.png" alt="MC energies as function of RMSD">

<img src="https://raw.githubusercontent.com/saguileran/MD-SCPI/main/Results/MC_RMSD_MR-AS4_high.png" alt="MC RMSD for high temperatures">


{% include gallery id="MC_images" caption="MC energies" %}
