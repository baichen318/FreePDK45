###################################################
#
# dir_init.py
#
# Created 1/3/2007 by Rhett Davis (rhett_davis@ncsu.edu)
#
#####################################################

import sshaft, sys, testproc

sshaft.beginstep('dir_init.py')

sshaft.dir_init(sys.argv[1],sys.argv[2])

sshaft.endstep()
