## Week 1

Prepare input files to MD and MC simulations:

- Import the molecules in chimera and create the PDB files
- Adding missing parts of MR ligand.
- Adding hydrogens and charges, this is done with an online page [poissonboltzmann](https://server.poissonboltzmann.org/) and the output file is a PQR file
- Define Cortisol (Col) and Aldosterone (AS4) PDB and mol files
- Quantum calculations with amber (antichamber ), page 312 [Amber22](http://ambermd.org/doc12/Amber22.pdf). This method uses quantum calculations but other approches are possible, as in amking-it-rain
- Relabaling COL and AS4
- 'Install' LiBELa and its requirments

Reference used [2].

Some usefull commands:

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

gesp: gaussian ESP, file format
RESP: charge method
-eq: equalize aomic charge, using 2 by atomic paths and geometry
GAFF: General Amber Force Field

Another mid step is to select the CPUs to quantum calculatios, this is done in the server terminal.

## Week 2

Merge protein and ligand PDBs and added solvent (water)

- Join and check MR and aldosterone (AS4) PDBs files with tleap. The output file is a complex PDB file.
- Create the input files for MD using complex.pdb file: .prmtio, .inpcrd
- Define Amber force field parameters
- Equilibrium system with amber [Build the starting structure and run a simulation to obtain an equilibrated system.](http://ambermd.org/tutorials/advanced/tutorial3/section1.php) by adding Na and Cl to the solvent

- Summitd jobs to server, commands line qsub and qstat
- Watch simulations running on sever [Gangalia](http://nascimento.ifsc.usp.br/ganglia)
- Closter orders at [Nascimento Lab - Cluster](http://nascimento.ifsc.usp.br/wordpress/?page_id=53)


- Use making-it-rain, Amber notebook, with the complex input files
