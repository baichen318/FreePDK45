source -echo -verbose make_generated_vars.tcl
source -echo -verbose common_setup.tcl
source -echo -verbose dc_setup_filenames.tcl

#################################################################################
# Design Compiler Top-Down Reference Methodology Setup
# Script: dc_setup.tcl
# Version: D-2010.03-SP1 (May 24, 2010)
# Copyright (C) 2007-2010 Synopsys, Inc. All rights reserved.
#################################################################################


#################################################################################
# Setup Variables
#
# Modify settings in this section to customize your DC-RM run.
#################################################################################

# Portions of dc_setup.tcl may be used by other tools so do check for DC only commands
if {$synopsys_program_name == "dc_shell"}  {

  # Use the set_host_options command to enable multicore optimization to improve runtime.
  # Note that this feature has special usage and license requirements.  Please refer
  # to the "Support for Multicore Technology" section in the Design Compiler User Guide
  # for multicore usage guidelines.
  # Note: This is a DC Ultra feature and is not supported in DC Expert.

  set_host_options -max_cores 1

  # Change alib_library_analysis_path to point to a central cache of analyzed libraries
  # to save some runtime and disk space.  The following setting only reflects the
  # the default value and should be changed to a central location for best results.

  # set_app_var alib_library_analysis_path ${ALIB_DIR}

  # Add any additional DC variables needed here
}

# The following variables are used by scripts in dc_scripts to direct the location
# of the output files

file mkdir ${REPORTS_DIR}
file mkdir ${RESULTS_DIR}

#################################################################################
# Library Setup
#
# This section is designed to work with the settings from common_setup.tcl
# without any additional modification.
#################################################################################

# Define all the library variables shared by all the front-end tools

set_app_var search_path ". ${ADDITIONAL_SEARCH_PATH} $search_path"

# The remainder of the setup below should only be performed in Design Compiler
if {$synopsys_program_name == "dc_shell"}  {
  set alib_library_analysis_path ${PDK_DIR}
  set link_library [set target_library [concat [list gscl45nm.db] [list dw_foundation.sldb]]]
  set target_library "gscl45nm.db"
}

