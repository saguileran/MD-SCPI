# **Reports**

## Weekly Reports 

### Week 1

Prepare input files to MD and MC simulations:

- Import the molecules in chimera and create the PDB files
- Adding missing parts of MR ligand.
- Adding hydrogens and charges, it is done with an online page [poissonboltzmann](https://server.poissonboltzmann.org/) and the output file is a PQR file
- Define Cortisol (Col) and Aldosterone (AS4) PDB and mol files
- Quantum calculations with amber (antichamber ), page 312 [Amber22](http://ambermd.org/doc12/Amber22.pdf). This method uses quantum calculations but other approaches are possible, such as in amking-it-rain
- Relabelling COL and AS4
- 'Install' LiBELa and its requirements

Reference [2] used to create and label Aldosteroe and Cortisol.

Some useful commands to run LiBELa:

Being at LiBELa_path/trunk/bin

```
iMcLiBELa.app/Contents/MacOS/iMcLiBELa 
```

To compute quantum calculations

```
source /usr/local/amber20/amber.sh
antechamber -i as4.gesp -fi gesp -o as4_resp.mol2 -fo mol2 -c resp -eq 2
#antechamber -i TPP.mol2 -fi mol2 -o tpp.com -fo gcrt -gv 1 -ge TPP.gesp -gn 16
```
Where:

- **gesp**: gaussian ESP, file format
- **RESP**: charge method
- **-eq**: equalize atomic charge, using 2 by atomic paths and geometry
- **GAFF**: General Amber Force Field

Another mid-step is to select the CPUs for quantum calculations, it is done in the server terminal.

Useful commands in chimera:

```
disp (display atoms)
distance sel
sel :AS4/MOl (select AS4/COl atoms)
color green #1/:MOL (change color)
color black :AS4@C=  (change colors of C on AS4)
label @C= (label all Carbon atoms)
~label (remove all labels)
color C/#1
transp 75,r (made ribon transparent)
match #1 #2 (move one to where is two)
sel :MOL za <5 (select atoms close to MOl at 5 Amstrong of distance)
```

All commands and documentation, [Chimera User Guide - commands](https://www.cgl.ucsf.edu/chimera/docs/UsersGuide/framecommand.html)


### Week 2

Merge protein and ligand PDBs and added solvent (water)

- Align protein and receptor using amber
- Define Amber force field parameters
- Join and check MR and aldosterone (AS4) PDBs files with tleap. The output file is a complex PDB file.
- Create the input files for MD using complex.pdb file: .prmtop, .inpcrd
- Convert prmtop file to PDB
- Equilibrium system with amber [Build the starting structure and run a simulation to obtain an equilibrated system.](http://ambermd.org/tutorials/advanced/tutorial3/section1.php) by adding Na and Cl to the solvent

```
source /usr/local/amber20/amber.sh # execute amber
tleap 
ambpdb -p file.prmtop < file.inpcrd > file_leap.pdb # conver tleap outputs to pdb
```

- Submit jobs to the server, commands lines ```qsub``` and ```qstat```
- To watch the current status of simulations on sever visit [Ganglia](http://nascimento.ifsc.usp.br/ganglia)
- Closter command lines [Nascimento Lab - Cluster](http://nascimento.ifsc.usp.br/wordpress/?page_id=53)

```
qsub amber.cpu.sub # run heat, density and, min process on CPU
qsub amber.sub     # run equil and prod process on GPU) 
qstat              # show current jobs submitted
qdel #job	   # kill process
qstat -xml | tr '\n' ' ' | sed 's#<job_list[^>]*>#\n#g' \
  | sed 's#<[^>]*>##g' | grep " " | column -t # show  whole jobs names
```

<div class="notice">
  <h4>Note:</h4>
  <p>The heat, equil, and density files are running using CPU (amber.cpu.sub) while the equil and prod process are assigned to GPU (amber.cpu).</p>
</div>


- Copy output elements (.nc files) to the local machine
- Display .nc files with chimera, Tools/MD/Ensemble Analysis/MD Movie, it generates a movie of the system

```
scp user_name@server_name:path_to_files/files ./    # copy from server to local
scp ./files_to_copy user_name@server_name:path_to/  # copy from local to server
```

- Run minimization process with amber (min, heat, and density input files)
- Define and run the production process (equil and prod input files), then adapat parameter to get the best performance in GPU  
- Autoimage process: The periodical boundary conditions are added for the molecules inside the box

```
source /usr/local/amber20/amber.sh
cpptraj path_to/.prmtop << eof
trajin prod.nc 
autoimage
trajout prod_img.nc
eof
```

- Remove system translation with cpptraj (pytraj for python)


```
# source /usr/local/amber20/amber.sh # ran previously
cpptraj .path/.prmtop << eof
trajin prod_img.nc 
rms first out rms.dat @CA,C,N
trajout prod_img_rms.nc
eof
```

It generates one file where all the frames matcht the first one, prod-rms.out file.

- Calculate potential energies of the system, for ligand, protein, environment, and interaction between them and residues

```
/Users/asn/workspace/AmberEnergy++2/bin/AmberEnergy++ path_to/.prmtop prod.nc |tee out_name.dat
3        # select NETCDF FORMAT FILE
1/2/3/4  # select energy calculations and enter the number of ligand and residue of interest
xmgrace -nxy out.dat  # visualize potential energies with xmgrace for the ligand and protein: Coulomb, VDW, and total
```

- Use [Chimera](https://www.cgl.ucsf.edu/chimera/) or [VMD](https://www.ks.uiuc.edu/Research/vmd/) to visualize the system trajectory, .prmtop, and .nc files are necessary

The molecular dynamics simulations can be divided into the following steps:

1. **Minimization**: Heat, density, and min process
2. **Equilibrate**: Equilibrate and production process
3. **LiGaMD**: Prepare conventional MD and Gaussian Accelerated MD steps, [Manual of GaMD in Amber](http://miaolab.org/GaMD/manual.html)

Since the systems (MR-COL and MR-AS4) are already defined and compiled, tleap and MD process, the following step is to make mutations to MR

Some useful file extension meanings:

- **prmtop**: parameters and topology
- **crd**: coordinates
- **pdb**: protein database
- **nc**: trajectory ouput file, short of NetCDF (network Common Data Form) it stores multidimensional scientific data (variables)
- **mol2**: molecule model file, it contains the coordinates and charges. It is obtained using AC (quantum calculations) and PDBs, or exporting it from the prmtop and nc files using chimera

The 3rd step:

- [LiGaMD - tutorial](http://miaolab.org/GaMD/tutorial.html)
- [GaMD - manual](http://miaolab.org/GaMD/manual.html) used to define steps and parameters to MD simulation
- [GaMD_Amber-Tutorial](http://miaolab.org/GaMD/lib/GaMD_Amber-Tutorial.pdf) to define and tune LiGaMD parameters (sigma0/V)

Prepare LiGaMD:

- Input files examples in [Amber tutorials](http://miaolab.org/GaMD/lib/GaMD_Amber-Tutorial.pdf) on page 5
- Script to plot output files with python [PyReweighting](http://miaolab.org/PyReweighting/)
- [Mioa Lab - resources](http://miaolab.org/resources.html)
- Check the meanning of LiGAMD input parameters [amber manual](http://ambermd.org/doc12/Amber22.pdf) page 499, 471

- Use **making-it-rain**, Amber_inputs.ipynb, with the complex outputs generated in the server (input for the notebook) files: .prmtop, .inpcrd, and .pdb


### Week 3

Create mutations systems and prepare again all necessary input files

- Reset numbering on MR mutation, it starts at 727
- Add mutations to the ligand (S810L) in Chimera

```
swapaa leu:810
```

- Prepare and run LiGaMD simulations on the server

```
iEP = 2		# threshold energy E for the the first potential
igamd = 10 	# (single boost)
dt = 0.001      # time step
sigma0P = 6 	# gaussian sigma of smothness
mask = 225 -> 1 # (residue number)
```

- Calculation of energies in different residues

<div align="center">


| **Residue** | **Atom #** | **MR-AS4** | **MR-COL** | **MR-STR** | **MR_S810-AS4** | **MR_S810L-COL** | **MR_S810L-STR** |
|:-----------:|:----------:|:-------:|:-------:|:-------:|:-----------:|:-----------:|:-----------:|
|     SER     |     85     |    ~    |         |         |             |             |             |
|     ARG     |     92     |   *230  |    *    |         |             |             |             |
|     GLN     |     51     |         |    *    |         |             |             |             |
|     ASN     |     45     |         |         |         |             |             |             |
|     THR     |     222    |         |         |         |             |             |             |
|      HH     |     22     |         |         |         |             |             |             |
|     SER     |     118    |         |         |         |             |             |             |
|             |            |         |         |         |             |             |             |

</div>

where:

- *: relevant interaction with the frame number
- ~: middle interaction


Other tasks done:

- Prepare and run the leaprc file for the MR mutations
- Run equilibration process for the mutation systems	

- Add histograms to energies plots
- Run minimization step: min, heat, and density process for MR-AS4/COL_mut
- Run production step: equil and prod process for the MR-AS4/COL_mut


Prepare and test the **LiBEla** files

- Use the previous .nc and .prmtop files to generated the .mol2 file with the coordinates and charges of MR, AS4, and COL
- Prepare the PDB file for the box
- Prepare the input (libela.inp) file by changing some parameters
- Create and submit the files for the MC simulations, parallel jobs are not required yet

```
source /share/apps/iMcLiBELa/LiBELa.sh
time /share/apps/iMcLiBELa/bin/McLiBELa.openmp -i libela.inp
```

the **mode** parameter can be:

- 1: eq (MC)
- 2: docking
- 3: MCR

**LiGaMD**

- Execute the MR-COl_ligaMD production step
- Submit the MR-AS4_ligaMD file varying the sigma0P parameter to 5
- Set up and submit the MR-AS4_ligaMD_DualBoost, it maybe allows to the ligand to scape easily
- MR-AS4_LiGaMD has already ran but it does not show the ligand unbinding then dual boost and varying sigmpa0D options are explored

**LiBELa**

- Prepare several input files for the Mc simulations and change the random seed, 10 samples are ok with 30M of steps
- Adapt the run_mc.sh script to execute several MC simulations for the MR-AS4 system, varying the random seed and temperature (300, 600, 1200, 2400, 4800, 9600)
- Improve ligand.inp file to generate a properly aceptance rate (0.3 - 0.5), it depends of the allowed translation parameters (related to translation, rotation and molecules coupling). The default values are:

```
cushion			0.5   # decresing this value increase the aceptance rate, it is related ti the center of mass transaltion of the whole ligand
max_atom_displacement   0.01  # not used since it simulates MC idea for all atoms indendently
rotation_step           1.25  # for the ligand considering it as a rigid body 
torsion_step            1.25  # for the quadripole molecules systems, it is also called rotation bounds
```

This MC simulation gave an aceptance rate of 0.175 which is not good. A better aceptance rate is reached with ```cushion=0.3/0.25```, the result is 0.362/0.5.
To execute several MC simulations a basch script is made, it create and submit several jobs varying the random seed and the temperature

<div class="notice">
  <h4>Note:</h4>
  <p>A good exercise is to set up and run the same process (AC, leap, MD and LiGaMD) for other ligand as Progesterone (STR).</p>
  <p>Making-it-rain has a little issue related to Collab-conda python version, to fix it use fallba in command palette, [making-it-rain/issues/57](https://github.com/pablo-arantes/making-it-rain/issues/57) to execute the notebook with the previous version of collab environment.</p>
</div>


To create a MD simulation of STR the following steps have to be done:

1. Crate **PDBs** without and with Hydrogen atoms using Chimera.
2. Use **antechamber** (AC) to generate the gctr and gesp files, line commands are in the [amber manual](http://ambermd.org/doc12/Amber22.pdf) at page 310.
3. Run **Gaussian09** ```/share/apps/g09/g09``` to compute quantum calculations. Links of documentation [Gaussian09 calculations](https://ambermd.org/tutorials/advanced/tutorial20/mcpbpy.php) and [Gaussian09 Keywords](http://wild.life.nctu.edu.tw/~jsyu/compchem/g09/g09ur/l_keywords09.htm)
4. Use **AC** to assign atom charges and atom types, it generates a mol2 file. The **-eq** flag is to predicts charge equilibration using both atom paths and some geometrical information (E/Z configuration).
5. Align and relabel, carbon and hydrogen atoms, of the **mol2** files, move protein to inside of the ligand
6. Create **tleaprc** file to run teLeap programs, it is done by executing the tleap command. In this step the protein and ligand files are required to be aligned and a charge equilibration process is required (add Na and Cl). Convert inpcr and prmtop to pdb file
7. Create and submit the input files for the **MD simulation**: heat, densit, min, equil, and prod process
8. Create, execute, and tune the **LiGaMD** files


- **gctr**: Gaussian Cartesian (Generalization-Based Compact Trajectory Representation)
- **gesp**: Gaussian ESP
	

### Week 4

Create and execute the MD simulation steps for the MR-STR (Progesteron) system. This file needs some aditional parameters for the quadripoles interactions

```
#str.frcmod 			  # it is generated by tleap as a warning
Remark line goes here
MASS

BOND

ANGLE

DIHE

IMPROPER
c3-ce-c -o         10.5          180.0         2.0          Using general improper torsional angle  X- X- c- o, penalty score=  6.0)
c -c2-ce-ha         1.1          180.0         2.0          Using the default value
c3-c3-c2-ce         1.1          180.0         2.0          Using the default value
c3-c3-c -o         10.5          180.0         2.0          Using general improper torsional angle  X- X- c- o, penalty score=  6.0)

NONBON

#tleaprc
loadamberparams str.frcmod 	  # charge into tleaprc to remove warnings
```

Generate and plot the MC simulations. A cushion of 0.25 is used with a search_box of 20.

To visualize the output files of the MC simulations import the ligand and protein PDBs to chimera and then use Tool/Surface-Binding Analysis and import the .inpcrd_mc.dat.gz file.

Since the ligh goes it is necessary to restart simulations using the previous files computed, to do this is necessary to add and modify some parameters in the input file for MD and LiGaMD simulations

```
irest_gamd=1 (1 for restart)
ntwr = 250000
ntcmd = 0, nteb = 0 #(execute the simulation just for the production step)
```

The production step for the mutations system are submited again and the parameter ```ntwr=250000``` is added to write a rst file in case of a restart process is required.

To visualize the MC simulations the files require are:

- AS4.mol2.gz
- MR.mol2.gz
- MR-AS4_10_MR-AS4.inpcrd_MC.mol2.gz 
- MR-AS4.mol2.gz

First open the ligand and protein mol2 files with chimera, then import the .inpcrd_MC.mol2 using Tools - Surface/Binding Analysis - ViewDock, and finaly select Dock 6.

Using LiBELa in the MR-AS4 system the ligand seems to scape at high temperatures, 9600K. To confirm that, 30 simulations will be execute at a temperature of 10000K, with ```cushion=0.25``` and ```search_box=20```.

Submitted jobs:

- MR-STR_equil_and_production
- MR_mut-AS4_equil_and_production
- MR_mut-COL_equil_and_production
- MR-AS4_ligamd_dual
- MC-AS4_10000/15000/20000

Missing task:

- MR_mut-STR_all_steps
- MR-COL_ligamd_single/dual
- MR-STR_ligamd_single/dual

Another interesting method is **Locally-Enchanced Sampling (LES)** which allow to have a more realistic simulation by enlarging the molecule making a few copies of some part of the system, page 629 of [Amber Manual](http://ambermd.org/doc12/Amber22.pdf). In this method the copies are not interacting between them
Make 5 (3 to 10 is suggested) copies of the ligand. Prepare input files with ADDLES, it requires a non-LES prmtop and prmcrd files which have been previously generated with tleap

Interesting articles about MR and AS4/COL/STR
- https://books.google.com.br/books?hl=en&lr=&id=oQj8DwAAQBAJ&oi=fnd&pg=PA47&dq=MR+and+aldosterone&ots=mK73FQ565c&sig=UyQ1TdtifeOWhnAUMF0RBqM_87k&redir_esc=y#v=onepage&q=MR%20and%20aldosterone&f=false

Tasks:

- Check to where is the ligand moving in the MC simulations for some samples.
- Make a plot for MC of RMSD vs #MC_step
- Check how is going the LES simulation
- Document the equilibration steps: min, heat, density, equil and prod steps
- Prepare the MR_mut-STR system

LES methods requires an input file of format rcvb. It is generated with the equil.rst file previously generated and using cpptraj to convert it. The LES method is implemented with 10 copies of the ligand (AS4), this is done to decrease the ligand-protein interaction stregth, by 1/10.

- **rcvb**: read coordinates, velocities, and boox

```
# convert to the appropriate format
cpptraj ../../leap/AS4/MR-AS4.prmtop << eof
> trajin equil.rst 
> autoimage
> trajout equil_2.rst 
> eof

# run addles to generate lesparm files
source /usr/local/amber20/amber.sh
addles < les.inp |tee addles.out

# convert LES output files to suitable formats: prmto, inpcrd, and pdb files
mv lesparm_MR-AS4 MR-AS4_LES.prmtop
mv lescrd MR-AS4_LES.inpcrd
ambpdb -p lesparm_MR-AS4.prmtop < MR-AS4_LES.inpcrd > MR-AS4_LES_leap.pdb
#ambpdb -p lesparm_MR-AS4 < lescrd > MR-AS4_LES_leap.pdb

# submit job using 128 CPUs
qsub amber.cpu.sub
```

<div class="notice">
  <h4>Message</h4>
  <p>**LEaP**: it combines the functionality of  *prep*, *link*, *edit* and *parm* of older versions of amber. <br>
  **AMBER** means Assisted Model Building with Energy Refinement </p>
</div>


Run a longer MC simulation, 100M steps, at a temperature of 5000K. In addition, 5 set of simulations were executed with the same set up, for the other systems: MR-COL, MR-STR, MR_S810L-AS4, MR_S810L-COL, and MR_S810L-STR.  

To get the mol2 files necessary for the previous jobs the files are imported to chimera and then the water (za > 5), Na, and Cl molecules are removed.


### Week 5

VMD useful commands

```
protein					Licorice
resid 1  				Licorice
same residue as within 5. of resid 1	NewCartoon
```

- Update the MD energies plots, calculate the energies for the residues of interest and adding them to the whole plot
- Copying and plot the data of the MC simulations for all the systems at 5000K with 100M of MC steps
- Submit the Cortisol-MD system with LiGaMD with $\sigma_P=6$ and $\sigma_D=6$
- Submit the Aldosterone-MD system with LiGaMD with $\sigma_P=8$ and $\sigma_D=6$
- Create and sumbit several MC simulations for a system at 7000K with 100M of MC steps
- Create a python script to count the binding and unbiding events in the MC simulations, this will give us an idea of how frequently (or easy) the ligand binding. The threshold for the event detection is 11 kcal/mol, since the plots shows that the system can present 3 states: unbinding, flipping, and unbinding with mean of RMSD ~3, ~7.5, and ~16, respectively
- Read and test [PyEMMA](http://www.emma-project.org/latest/index.html) for use as an analyze tool for the MC simulations, since them have no sense of time. Explore the tutorial [Showcase pentapeptide: a PyEMMA walkthrough](http://www.emma-project.org/latest/tutorials/notebooks/00-pentapeptide-showcase.html) to know how the package work and how can be used in our problem
- LES simulation is very inefficient, it performance is less than 1 ns/day then it is killed. Although it is interesting to explore the system behaviour is not worth to run the simulation 

An other article of interest, where PyEMMA and MC simulations are used, is [PELE-MSM: A Monte Carlo Based Protocol for the Estimation of Absolute Binding Free Energies](https://pubs.acs.org/doi/full/10.1021/acs.jctc.9b00753), can it be used to analyze MC simulations using the RMSD as the feature parameter?

- Submit jobs for all the 6 systems for a MC simulation of 100M steps and at temperature of 7000K (14.48h-22-03)
- Plotting all data of the MC simulations and calculating un/binding events in each system

<div align="center">

| **ligand** | **temperature** | **binding** | **unbinding** | **Samples** | **biding_prob** | **unbiding_prob** |
|:----------:|:---------------:|:-----------:|:-------------:|:-----------:|:---------------:|:-----------------:|
|     AS4    |    5000K_long   |      0      |       1       |      51     |       0.00      |        1.96       |
|     AS4    |      7000K      |      2      |       20      |      51     |       3.92      |       39.22       |
|     COL    |      5000K      |      0      |       0       |      51     |       0.00      |        0.00       |
|     COL    |      7000K      |      0      |       28      |      51     |       0.00      |       54.90       |
|     STR    |      5000K      |      0      |       0       |      51     |       0.00      |        0.00       |
|     STR    |      7000K      |      4      |       30      |      51     |       7.84      |       58.82       |
|   AS4_mut  |      5000K      |      0      |       3       |      51     |       0.00      |        5.88       |
|   AS4_mut  |      7000K      |      2      |       30      |      51     |       3.92      |       58.82       |
|   COL_mut  |      5000K      |      0      |       3       |      51     |       0.00      |        5.88       |
|   COL_mut  |      7000K      |      0      |       14      |      51     |       0.00      |       27.45       |
|   STR_mut  |      5000K      |      0      |       0       |      51     |       0.00      |        0.00       |
|   STR_mut  |      7000K      |      5      |       20      |      51     |       9.80      |       39.22       |

</div>

- Create a more complex and realistic simulation using two proteins, because a recent article [Quaternary glucocorticoid receptor structure highlights allosteric interdomain communication](https://www.nature.com/articles/s41594-022-00914-4)
- Prepare tleap files using this double protein system to create a LiGAMD simulation. It implies to create and submite the equilibration process for this system using MD simulation.

**Dimer**

- Create PDBs of the AS4 dimer system: composed of two AS4 ligands and 2 MR proteins located inversely
- Generate prmtop, inpcr and mol2 (using the previous files generated by AC with the simple system) files for tleap
- Execute tleap to get the complex pdb file
- Modify and adapt files to the MD simulation for the dimer system. Here is necessary to relabel the input files to not get errors in tleap.
- Submit the system for a MD equilibration process

**PyEMMA**

- **MSM**: Multiple Source Method
- **TICA**: Time-lagged Independent Component Analysis

### Week 6

- Extract the coordinates of the MC simulations to use them in PyEMMA (deep time)

```
cpptraj ../../mol2/AS4.mol2.gz << eof
trajin MR-AS4_19_MR-AS4.inpcrd_MC.mol2.gz
trajout 19.nc
eof
```

- Create the dimer system (MR_dimer-AS4), define the mol files for a MC simulation
- Define and submit the dimer system in a MD simulation, quilibration and production steps (it takes a whole week)
- Tune the cushion parameter for the dimer system
- Create the notebooks to analyze Mc simulations with TICA method (PyEMMA)

- Create and measure two virtual points to calculate the ligand space pathway, since there are three possible pathways just two of them are analyze (the two more possibles). The points choosen are: CM atoms 379-472, and CM 279-344. The objective is to measure the distance from these points to the closest ligand

```
cpptraj ../leap/MR_dimer-AS4.prmtop << eof
trajin equil.nc  # (mol file instead)
distance :379,472 :1 out distance.dat
eof
```

This is not possible since LiBELA uses the files splited, then the generated mol files do not have information about the ligand.

<div class="notice">
  <h4>To do:</h4>
  <p>Explain how is the protein framework and where are located the molecular simulations, why and how are they used.</p>
</div>


The LiGaMD simulation is not enough to reproduce binding and unbinding, for this propouse **LiGaMD2** is more apropiate. In this MC simulation, it is necessary to select the ligand and it surrounding residues to make a soft core, the it will be allow to the ligand binding easier. First test is done with a 6-6 configuration, $\sigma_D/\sigma_P$ nad a time of 1 ns

Tutorials to use with PyEMMA in further analysis:

- [Markov state model for pentapeptide](http://www.emma-project.org/latest/legacy-notebooks/applications/pentapeptide_msm/pentapeptide_msm.html)
- [Markov state model for BPTI](http://www.emma-project.org/latest/legacy-notebooks/applications/bpti_msm/MSM_BPTI.html)

The dimeral system also present binding and unbinding events, comparing it with the single system it shows more events at the same temperature suggesting that in the dimeral system the ligand can scape more easily. To analyze the simulations PyEMMA is used again. In addition, the dimeral system is simulated again using MC with 100M of steps but decreasing temperature, at 500K.

Previous tests showed that LES simulation do not have good performance, since the systema has thousands of atoms. A new test is done, to compare it performance, but removing the solvent atoms and with 10 copies.

Command to select and display the elements, with labels and atom numbers, close the ligand

```
sel :AS4 za < 4
list residues spec sel
```

then go to Favorites -> Reply Log and there you have, now just extract the atom numbers.

<div class="notice">
  <h4>Note:</h4>
  <p>The LiGaMD simulation was no eable to reproduce the ligand unbinding process, no matter how long or how high are the soft parameters, then it is necessarly to explore and test LiGaMD2 which seems more apropiate for our propouse.</p>
</div>


### Week 7

- Define the atoms to be smothed: all around AS4 less than 4 amstrong. Then set up and submit the LiGaMD2 simulation.
- Test MR_dimer simulation with higher energies and same cushion. Again 51 simulations of this system are submitted at a temperature of 5000 and 7000K with 100M MC steps.
- Create an introduction of the final report: answer the questions of why we select MR/aldo-col-str system, what is our main question and hypothesis, and "how" (way=simulation) we are going to try to answer these questions, our approach to this problem. 
- Understand how to works PyEMMA to analyze the MC simulations and how fast the system are changing of states, is more how frequently are the states present
- Setup a LES simulation of the MR-AS4 system without solvent, since there is not solvent the periodical boundary conditions have to be removed and taking acount in the input parameters of the LES simulation.

### Week 8

- Because the LiGaMD1/2 simulations were not able to reproduce uun/binding process another simualtion is explored, ASMD.
- Setup and submit ASMD simulation for all the system, 6 sets. Here the ligand 
- Enhance the gh-pages:
    - Add conclusion and other results.
    - Correct orthography and grammar
    - Update the Weekly Reports
- Finish the Final Report, since the template is basic a new and more pretty template is used. The template is taken from overleaf and it does not work in texmaker.

The ASMD input files requires the last distance between the centers of mass of the ligand and protein, this is done using cpptraj and selecting the closest carbon atom of the ligand (to make easier the calculation of the center of mass of the lingad)

```
cpptraj ../leap/MR-AS4.prmtop << eof
trajin ../MD/prod.nc 
distance :1@C3 :2-258@CA out distance.dat 
eof
```

Then check the last distance with  ``` more distance.dat```. To find the closest atom of the ligand to the center of mass use

```
me cen #0 level 0.15 mark true radius 0.5 color red model 2
```

Center of mass: Aldo C3, Col C5, STR C8.

To execute the bash scripts to create the input files and jobs use

```
./create_ASMDinputs.sh 50 100000         # ./*sh {NUM of trajectories} {NUM of MDsteps}
./create_job.sh 50 ../MD/prod.rst 1      # ./*sh {NUM of trajectories} {Coord/RST7} {Stage Num}
qsub job.1.sh				 # submit job
```

The bash scripts used are taken and adapted from [6.4 Adaptive Steered Molecular Dynamics](http://ambermd.org/tutorials/advanced/tutorial26/index.php).

## Final Report

## Conclusions

# [MD-SCPI project](https://saguileran.github.io/MD-SCPI/)

Home page of the project. Short description with an overview, objectives, results and references.
