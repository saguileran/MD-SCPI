# **Weekly Reports**

## Week 1

Prepare input files to MD and MC simulations:

- Import the molecules in chimera and create the PDB files
- Adding missing parts of MR ligand.
- Adding hydrogens and charges, this is done with an online page [poissonboltzmann](https://server.poissonboltzmann.org/) and the output file is a PQR file
- Define Cortisol (Col) and Aldosterone (AS4) PDB and mol files
- Quantum calculations with amber (antichamber ), page 312 [Amber22](http://ambermd.org/doc12/Amber22.pdf). This method uses quantum calculations but other approches are possible, as in amking-it-rain
- Relabaling COL and AS4
- 'Install' LiBELa and its requirments

Reference [2] used to create and label aldosteron and cortisol.

Some usefull commands ot run LiBELa:

Being at LiBELa_path/trunk/bin

```
iMcLiBELa.app/Contents/MacOS/iMcLiBELa 
```

To made quantum calculations

```
source /usr/local/amber20/amber.sh
antechamber -i as4.gesp -fi gesp -o as4_resp.mol2 -fo mol2 -c resp -eq 2
#antechamber -i TPP.mol2 -fi mol2 -o tpp.com -fo gcrt -gv 1 -ge TPP.gesp -gn 16
```
Where:

- **gesp**: gaussian ESP, file format
- **RESP**: charge method
- **-eq**: equalize aomic charge, using 2 by atomic paths and geometry
- **GAFF**: General Amber Force Field

Another mid step is to select the CPUs to quantum calculatios, this is done in the server terminal.

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
sel :MOL za <5 (select atoms close to MOl at 5 amstrong of distance)
```

All commands and documentation, [Chimera User Guide - commands](https://www.cgl.ucsf.edu/chimera/docs/UsersGuide/framecommand.html)


## Week 2

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

- Summitd jobs to server, commands line ```qsub``` and ```qstat```
- To watch the current status of simulations on sever visit [Ganglia](http://nascimento.ifsc.usp.br/ganglia)
- Closter command lines [Nascimento Lab - Cluster](http://nascimento.ifsc.usp.br/wordpress/?page_id=53)

```
qsub amber.cpu.sub # run heat, density and min process on CPU
qsub amber.sub     # run equil and prod process on GPU) 
qstat              # show current jobs submitted
qdel #job	   # kill procees
```

Note: the heat, equil, and density files are running using CPU (amber.cpu.sub) while the equil and prod process are assign to GPU (amber.cpu).

- Copy output elements (.nc files) to the local machine
- Display .nc files with chimera, Tools/MD/Ensemble Analysis/MD Movie, it generates a movie of the system

```
scp user_name@server_name:path_to_files/files ./    # copy from server to local
scp ./files_to_copy user_name@server_name:path_to/  # copy from local to server
```

- Run minimization process with amber (min, heat, ando density input files)
- Define and run the production process (equil and prod input files), adapat parameter to get the best performance in GPU  
- automaging process: This add the periodical boundary conditions for the molecules inside the box

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

It generates one file where all the frame are matchet to the first one, prod-rms.out file.

- Calculate potential energies of the system, for ligand, protein, environment and interaction between them and residues

```
/Users/asn/workspace/AmberEnergy++2/bin/AmberEnergy++ path_to/.prmtop prod.nc |tee out_name.dat
3        # select NETCDF FORMAT FILE
1/2/3/4  # select energy calculations and enter number of ligand and residue of interes
xmgrace -nxy out.dat  # visualize potential energies wih xmgrace: ligand, protein and sum
```

- Use [Chimera](https://www.cgl.ucsf.edu/chimera/) or [VMD](https://www.ks.uiuc.edu/Research/vmd/) to visualize the system trajectory, .prmtop and .nc files are necessary

The molecular dynamics simulations can be divide in the following steps:

1. **Minimization**: Heat, density and min process
2. **Equilibrate**: Equilibrate and production process
3. **LiGaMD**: Prepare conventional MD and Gaussian Accelerated MD steps, [Manual of GaMD in Amber](http://miaolab.org/GaMD/manual.html)

Since the systems (MR-COL and MR-AS4) are already defined and compiled, tleap and MD process, the following step is to made mutations to MR

Some useful file extension meanings:

- **prmtop**: parameters and topology
- **crd**: coordinates
- **pdb**: protein data base
- **nc**: trajectory ouput file, short of NetCDF (network Common Data Form) it stores multidimensional scientific data (variables)
- **mol2**: molecule model file, it contains the coordinates and charges. It is obtained using AC (quantum calculations) and PDBs, or exporting it from the prmtop and nc files using chimera

For the 3th step

- [LiGaMD - tutorial](http://miaolab.org/GaMD/tutorial.html)
- [GaMD - manual](http://miaolab.org/GaMD/manual.html) used to define steps and parameters to MD simulation
- [GaMD_Amber-Tutorial](http://miaolab.org/GaMD/lib/GaMD_Amber-Tutorial.pdf) to define and tune LiGaMD parameters (sigma0/V)

Prepare LiGaMD

- Input files examples in [Amber tutorials](http://miaolab.org/GaMD/lib/GaMD_Amber-Tutorial.pdf) page 5
- Script to plot ouput files with python [PyReweighting](http://miaolab.org/PyReweighting/)
- [Mioa Lab - resources](http://miaolab.org/resources.html)
- Check meanning of LiGAMD input parameters [amber manual](http://ambermd.org/doc12/Amber22.pdf) page 499, 471



- Use **making-it-rain**, Amber_inputs.ipynb, with the complex output generated in the closter (input for the notebook) files: .prmtop, .inpcrd, and .pdb


## Week 3

Create mutations systems an prepare again all necessary input files

- Reset numering on MR mutation, it starts at 727
- Add mutations to the ligand (S810L) in chimera

```
swapaa leu:810
```

- Prepare and run LiGaMD simulations on server

```
iEP = 2
igamd = 10 (single boost)
dt = 0.001
sigma0P = default 
change mask    225 -> 1 (residue number)
```

- Calculation of energies in different residues

<center>

| **Residue** | **Atom #** | **AS4** | **COL** |
|:-----------:|:----------:|:-------:|:-------:|
|     SER     |     85     |     ~   |         |
|     ARG     |     92     |   *230  |    *    |
|     GLN     |     51     |         |    *    |
|     ASN     |     45     |         |         |
|     THR     |     222    |         |         |
|      HH     |     22     |         |         |
|     SER     |     118    |         |         |
|     SER     |     810    |         |         |

</center>

where:

- *: relevant interaction with number of frame
- ~: middle interaction


- Prepare and run the leaprc file for the MR mutations
- Run equilibration procees for the mutation systems	

- Add histograms to energies plots
- Run minimization step: min, heat, and density process for MR-AS4/COL_mut
- Run production step: equil and prod process for the MR-AS4/COL_mut


Prepare and test the **LiBEla** files

- Use the previous nc an prmtop files to generated the mol2 file with the coordinates and charges of MR, AS4 and COL
- Prepare the PDB file for the box
- Prepare the input (libela.inp) file by changing some parameters
- Create and submit the files for the MC simulations, parallel jobs are not required yet

```
source /share/apps/iMcLiBELa/LiBELa.sh
time /share/apps/iMcLiBELa/bin/McLiBELa.openmp -i libela.inp
```

the **mode** parameter can be

- eq (MC)
- docking
- MCR

- Prepare several input files for the Mc simulations, change the random seed. 10 samples are ok



# [MD-SCPI project](https://saguileran.github.io/MD-SCPI/)

Home page of the project, short description
