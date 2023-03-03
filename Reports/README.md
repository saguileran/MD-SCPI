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
qsub amber.sub
qstat
qdel ##procees
```

Note: the heat, equil, and density files are running using CPU (amber.cpu.sub) while the equil and prod process are assign to GPU (amber.cpu).

- Copy output elements (.nc files) to the local machine
- Display .nc files with chimera, Tools/MD/Ensemble Analysis/MD Movie, it generates a movie of the system

```
scp sebas@nascimento:path_to_MD_folder/*.nc ./
```


- Run equilibrium process with amber (equil.in)
- Define and run the production process (prod.in), adapat parameter to get the best performance in GPU  

- Remove system translation with cpptraj (pytraj for python)

```
source /usr/local/amber20/amber.sh
cpptraj .path/.prmtop << eof
trajin prod.nc 
rms first out rms.dat @CA,C,N
trajout prod_rms.nc
eof
```

It generates one file where all the frame are matchet to the first one, prod-rms.out file.

- Calculate potential energies of the system, for ligand, protein, environment and interaction between them and residues

```
/Users/asn/workspace/AmberEnergy++2/bin/AmberEnergy++ path_to/.prmtop prod.nc |tee out.dat
3        # select NETCDF FORMAT FILE
1/2/3/4  # select energy calculations and enter number of ligand and residue of interes
xmgrace -nxy out.dat  # visualize potential energies wih xmgrace: ligand, protein and sum
```

- Use [Chimera](https://www.cgl.ucsf.edu/chimera/) or [VMD](https://www.ks.uiuc.edu/Research/vmd/) to visualize the system trajectory, .prmtop and .nc files are necessary

The molecular dynamics simulations can be divide in two steps:

**1.** Minimize and equilibrate
**2.** Equilibrate and production 
**3.** Use LigaMD

Since the systems (MR-COL and MR-AS4) are already defined and compiled, tleap and MD process, the following step is to made mutations to MR

Some useful file extension meanings:

- **prmtop**: parameters and topology
- **crd**: coordinates
- **pdb**: protein data base
- **nc**: trajectory file

For the 3th step

- [LiGaMD - tutorial](http://miaolab.org/GaMD/tutorial.html)
- [GaMD - manual](http://miaolab.org/GaMD/manual.html) used to define steps and parameters to MD simulation
- [GaMD_Amber-Tutorial](http://miaolab.org/GaMD/lib/GaMD_Amber-Tutorial.pdf) to define and tune LiGaMD parameters (sigma0/V)

- Use **making-it-rain**, Amber_inputs.ipynb, with the complex output generated in the closter (input for the notebook) files: .prmtop, .inpcrd, and .pdb




### Output Files

<h3 align="center">MR-AS4</h3>

<div class="container">
    <video id="video" width="500" height="500" controls>
        <source src="../MR-AS4.mp4" type="video/mp4">
    </video>
    <div class="overlay">
        <p>Mineralocorticoid (MR) protein interaction with aldosteron (AS4) ligand</p>
    </div>
</div>


<h3 align="center">MR-COL </h3>

<div class="container">
    <video id="video" width="500" height="500" controls>
        <source src="../MR-COL.mp4" type="video/mp4">
    </video>
    <div class="overlay">
        <p>Mineralocorticoid (MR) protein interaction with cortisol (COL) ligand</p>
    </div>
</div>

