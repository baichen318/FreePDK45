#
# envparse.py - Compares the variables of two environments
# 9/9/2005 W. Rhett Davis (rhett_davis@ncsu.edu)
#
# Usage:  printenv > env1
#         (source setup script)
#         printenv > env2
#         envparse.py env1 env2
#

import os, sys, string, re

if len(sys.argv) < 3:
    print '''
Usage:   printenv > env1
         (source setup script)
         printenv > env2
         envparse.py env1 env2 [setup.txt]
'''
    sys.exit(0)

before={}
f=file(sys.argv[1])
for line in f:
    string.strip(line)
    m=re.search(r"^([^=]+)=(.*)$",line)
    if m:
        before[m.group(1)]=m.group(2)
    else:
        print 'ERROR: line "'+line+'" not parsed in file '+sys.argv[1]
f.close()

after={}
f=file(sys.argv[2])
for line in f:
    string.strip(line)
    m=re.search(r"^([^=]+)=(.*)$",line)
    if m:
        after[m.group(1)]=m.group(2)
    else:
        print 'ERROR: line "'+line+'" not parsed in file '+sys.argv[2]
f.close()

created=[]
deleted=[]
changed=[]
appended=[]
appval={}
prepended=[]
prepval={}

for key in before.keys():
    if not after.has_key(key):
        deleted.append(key)
        continue

for key in after.keys():
    if not before.has_key(key):
        created.append(key)
        continue
    if before[key]!=after[key]:
        bval=before[key]
        aval=after[key]
        if bval==aval[:len(bval)]:
            appended.append(key)
            appval[key]=aval[len(bval):]
            continue
        if bval==aval[len(aval)-len(bval):len(aval)]:
            prepended.append(key)
            prepval[key]=aval[:len(aval)-len(bval)]
            continue
        changed.append(key)

print 'The following variables were created:'
if len(created)==0:
    print '(none)'
for key in created:
    print key,'=',after[key]
print
print 'The following variables were deleted:'
if len(deleted)==0:
    print '(none)'
for key in deleted:
    print key
print
print 'The following variables were appended:'
if len(appended)==0:
    print '(none)'
for key in appended:
    print '(appended)',key,'=',appval[key]
print
print 'The following variables were prepended:'
if len(prepended)==0:
    print '(none)'
for key in prepended:
    print '(prepended)',key,'=',prepval[key]
print
print 'The following variables were changed:'
if len(changed)==0:
    print '(none)'
for key in changed:
    print '(before)',key,'=',before[key]
    print '(after)',key,'=',after[key]


if len(sys.argv)<4:
    print
    print 'To generate a section of the setup.py file for the SSHAFT flow,'
    print 'add an output file argument.  For example:'
    print
    print '    envparse.py env1 env2 [setup.txt]'
else:
    print
    print "Writing section of the setup.py file for SSHAFT flow to file",
    print sys.argv[3]
    
    f=file(sys.argv[3],"w")
    f.write("    'NewEnvVars':[")
    for key in created:
        f.write("'"+key+"', ")
    for key in changed:
        f.write("'"+key+"', ")
    f.write('],\n')
    f.write("    'AppendEnvVars':[")
    for key in appended:
        f.write("'"+key+"', ")
    f.write('],\n')
    f.write("    'PrependEnvVars':[")
    for key in prepended:
        f.write("'"+key+"', ")
    f.write('],\n')

    for key in created:
        f.write("    '"+key+"':'"+after[key]+"',\n")
    for key in changed:
        f.write("    '"+key+"':'"+after[key]+"',\n")
    for key in appended:
        f.write("    '"+key+"':'"+appval[key]+"',\n")
    for key in prepended:
        f.write("    '"+key+"':'"+prepval[key]+"',\n")

    
