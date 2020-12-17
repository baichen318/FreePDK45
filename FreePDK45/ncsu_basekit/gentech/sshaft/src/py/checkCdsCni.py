
###################################################
#
# checkCdsCni.py
#
# Created 3/3/2007 by Rhett Davis (rhett_davis@ncsu.edu)
#
# Check master layer/purpose list and look for layers
# that haven't been defined
#
#####################################################

import sshaft, os, sys, re

sshaft.beginstep('genCdsCni.py')

# Parse arguments
args=sys.argv[1:]
while (len(args)>0):
    arg=args[0]
    args=args[1:]
    sshaft.logf('LOG_WARN',"WARNING: Unrecognized argument "+arg)

layers=[]
section=False
f=file(os.environ['PDK_DIR']+'/techfile/cni/Santana.tech','r')
for line in f:
    m=re.search(r"^\s*(\w+)\(",line)
    if m:
        section=m.group(1)
        continue
    
    if (section=='layerMapping'):
        m=re.search(r"\(\s*(\w+)",line)
        if m:
            layers.append(m.group(1))


    elif (section=='maskNumbers' or section=='layerMaterials'):
        m=re.search(r"^\s*\(\s*(\w+)",line)
        if m:
            if (m.group(1) not in layers):
                sshaft.logf('LOG_WARN','WARNING: Layer '+m.group(1)
                  +' in section '+section+
                  ' of file Santana.tech is not in master layer list')

    elif (section=='viaLayers' ):
        m=re.search(r"^\s*\(\s*(\w+)\s+(\w+)\s+(\w+)",line)
        if m:
            if (m.group(1) not in layers):
                sshaft.logf('LOG_WARN','WARNING: Layer '+m.group(1)
                  +' in section '+section+
                  ' of file Santana.tech is not in master layer list')
            if (m.group(2) not in layers):
                sshaft.logf('LOG_WARN','WARNING: Layer '+m.group(2)
                  +' in section '+section+
                  ' of file Santana.tech is not in master layer list')
            if (m.group(3) not in layers):
                sshaft.logf('LOG_WARN','WARNING: Layer '+m.group(3)
                  +' in section '+section+
                  ' of file Santana.tech is not in master layer list')


    elif (section=='spacingRules' or section=='orderedSpacingRules' ):
        m=re.search(r"^\s*\(\s*\w+\s+(\w+)\s+\d",line)
        if m:
            if (m.group(1) not in layers):
                sshaft.logf('LOG_WARN','WARNING: Layer '+m.group(1)
                  +' in section '+section+
                  ' of file Santana.tech is not in master layer list')
            continue
        m=re.search(r"^\s*\(\s*\w+\s+(\w+)\s+(\w+)",line)
        if m:
            if (m.group(1) not in layers):
                sshaft.logf('LOG_WARN','WARNING: Layer '+m.group(1)
                  +' in section '+section+
                  ' of file Santana.tech is not in master layer list')
            if (m.group(2) not in layers):
                sshaft.logf('LOG_WARN','WARNING: Layer '+m.group(2)
                  +' in section '+section+
                  ' of file Santana.tech is not in master layer list')

f=file(os.environ['PDK_DIR']+'/techfile/FreePDK45.tf','r')
for line in f:
    m=re.search(r"^\s*(\w+)\(",line)
    if m:
        section=m.group(1)
        continue
    
    if (section=='techLayerPurposePriorities' or section=='techDisplays'
        or section=='functions'):
        m=re.search(r"^\s*\(\s*(\w+)",line)
        if m:
            if (m.group(1) not in layers):
                sshaft.logf('LOG_WARN','WARNING: Layer '+m.group(1)
                  +' in section '+section+
                  ' of file FreePDK45.tf is not in master layer list')

    elif (section=='techLayerProperties' or section=='orderedSpacingRules' ):
        m=re.search(r"^\s*\(\s*\w+\s+(\w+)\s+\d",line)
        if m:
            if (m.group(1) not in layers):
                sshaft.logf('LOG_WARN','WARNING: Layer '+m.group(1)
                  +' in section '+section+
                  ' of file FreePDK45.tf is not in master layer list')
            continue
        m=re.search(r"^\s*\(\s*\w+\s+(\w+)\s+(\w+)",line)
        if m:
            if (m.group(1) not in layers):
                sshaft.logf('LOG_WARN','WARNING: Layer '+m.group(1)
                  +' in section '+section+
                  ' of file FreePDK45.tf is not in master layer list')
            if (m.group(2) not in layers):
                sshaft.logf('LOG_WARN','WARNING: Layer '+m.group(2)
                  +' in section '+section+
                  ' of file FreePDK45.tf is not in master layer list')

f.close()

sshaft.endstep()
