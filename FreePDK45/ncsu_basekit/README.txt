***** Quick Design Kit Usage Instructions *****

  1) Change the environment variable $PDK_DIR in the file
     $PDK_DIR/ncsu_basekit/cdssetup/setup.csh to reflect the FreePDK
     installation path.
     
  2) Change the environment variable $CDSHOME in the file
     $PDK_DIR/ncsu_basekit/cdssetup/setup.csh to reflect your Cadence
     Virtuoso installation path.

  3) Source your setup scripts for Cadence Virtuosoi, Mentor Graphics
     Calibre, and CiraNova PyCell Studio.  For more information about 
     setting up PyCell Studio, see the "P-Cells" section of the file
     $PDK_DIR/ncsu_basekit/doc/FreePDK45_Manual.txt
     
  4) Change to the directory where you want to start Virtuoso and
     source the file $PDK_DIR/ncsu_basekit/cdssetup/setup.csh.  Note that
     this script copies all of the required user files (.cdsinit,
     cds.lib, and lib.defs) to the current working directory 
     if they do not already exist.

  5) Start Cadence Virtuoso ( % virtuoso &  for example ) 


***** Other documentation can be found in $PDK_DIR/ncsu_basekit/doc *****

  FreePDK45_Release_Notes.txt    Release Notes for this Kit
  FreePDK45_Manual.txt           Manual for this Kit

***** Please send all questions and comments to eda_help@ncsu.edu *****

