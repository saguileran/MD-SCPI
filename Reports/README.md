## Week 1

Prepare input files to MD simulations:

- Import the molecules in chimera and create the PDB files
- Adding missing parts of MR ligand
- Quantum calculations with amber, page 312 [Amber22](http://ambermd.org/doc12/Amber22.pdf)
- Adding hydrogens and charges, this is done with an online page [poissonboltzmann](https://server.poissonboltzmann.org/)
- Define Cortisol (Col) and Aldosterone (Aldo) PDB and mol files
- 'Install' LiBELa and its requirments


Some usefull commands:

Being at /Users/sebas/Documents/Github/MD-SCIP/trunk/bin

```
iMcLiBELa.app/Contents/MacOS/iMcLiBELa 
```

On server

```
antechamber -i TPP.mol2 -fi mol2 -o tpp.com -fo gcrt -gv 1 -ge TPP.gesp -gn 16
antechamber -i TPP.mol2 -fi mol2 -o tpp.com -fo gcrt -gv 1 -ge TPP.gesp
```

## Week 2
