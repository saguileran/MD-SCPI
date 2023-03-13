
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

Note: the heat, equil, and density files are running using CPU (amber.cpu.sub) while the equil and prod process are assigned to GPU (amber.cpu).

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
iEP = 2
igamd = 10 (single boost)
dt = 0.001
sigma0P = default 
change mask    225 -> 1 (residue number)
```

- Calculation of energies in different residues

<div align="center">

| **Residue** | **Atom #** | **AS4** | **COL** |
|:-----------:|:----------:|:-------:|:-------:|
|     SER     |     85     |     ~   |         |
|     ARG     |     92     |   *230  |    *    |
|     GLN     |     51     |         |    *    |
|     ASN     |     45     |         |         |
|     THR     |     222    |         |         |
|      HH     |     22     |         |         |
|     SER     |     118    |         |         |

</div>

where:

- *: relevant interaction with the frame number
- ~: middle interaction


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

the **mode** parameter can be

- 1: eq (MC)
- 2: docking
- 3: MCR

**LiGaMD**

- Execute the MR-COl_ligaMD production step
- Submit the MR-AS4_ligaMD file varying the sigma0P parameter to 5
- Set up and submit the MR-AS4_ligaMD_DualBoost, it maybe allows to the ligand to scape easily
- MR-AS4_LiGaMD has already ran but it does not show the ligand unbinding then dual boost and varying sigmpa0D options are explored

**LiBELa**

- Prepare several input files for the Mc simulations and change the random seed. 10 samples are ok with 30M of steps
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

**A good exercise is to set up and run the same process (AC, leap, MD and LiGaMD) for other ligand as Progesterone (STR)**

Making-it-rain has a little issue related to Collab-conda python version, to fix it use fallba in command palette, [making-it-rain/issues/57](https://github.com/pablo-arantes/making-it-rain/issues/57) to execute the notebook with the previous version of collab environment

To create a MD simulation of STR the following steps have to be done:

1. Crate PDB without and with Hydrogen atoms using Chimera.
2. Use antechamber (AC) to generate gctr and gesp files, line commands are in the [amber manual](http://ambermd.org/doc12/Amber22.pdf) at page 310.
3. Run Gaussian 09 ```/share/apps/g09/g09``` to compute quantum calculations. Links of documentation [Gaussian09 calculations](https://ambermd.org/tutorials/advanced/tutorial20/mcpbpy.php) and [Gaussian09 Keywords](http://wild.life.nctu.edu.tw/~jsyu/compchem/g09/g09ur/l_keywords09.htm)
4. Use AC to assign atom charges and atom types, it generates a mol2 file. The **-eq** flag is to predicts charge equilibration using both atom paths and some geometrical information (E/Z configuration).
5. Align and renumbering mol2 files, move to inside the protein
6. Create tleaprc file to run teLeap programs, it is done by executing the tleap command. In this step the protein and ligand files are required to be aligned and a charge equilibration process is required (add Na and Cl)
7. Create the input files for the MD simulation: heat, densit, min, equil, and prod process
8. Create, execute, and tune the LiGaMD files


- **gctr**: Gaussian Cartesian (Generalization-Based Compact Trajectory Representation)
- **gesp**: Gaussian ESP
	

### Week 4

Create and execute the MD simulation steps for the MR-STR system.

Generate and plot the MC simulations. A cushion of 0.25 is used with a search_box of 20. 

### Week 5

### Week 6

### Week 7

### Week 8

## Final Report

## Conclusions

# [MD-SCPI project](https://saguileran.github.io/MD-SCPI/)

Home page of the project. Short description with an overview, objectives, results and references
