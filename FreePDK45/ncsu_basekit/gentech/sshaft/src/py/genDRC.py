import re,string, sys
#Currently assumes tab separated table has the following fields: RuleNo, Desc, Value,
# Layers(comma separated list of layers to which the rule applies), Type, Layers2
# (optional second layers), and Extra (e.g. diffNet, sameNet, etc)


class tablefile:
    def __init__(self,filename):
        self.fields=[]
        self.array=[]
        f=open(filename,'r')
        for line in f:
            if len(self.fields)==0:
                for entry in string.split(string.strip(line),'\t'):
                    self.fields.append(stripquote(entry))
                continue
            linelist=string.split(string.strip(line),'\t')
            d={}
            for i in range(len(linelist)):
                d[self.fields[i]]=stripquote(linelist[i])
            self.array.append(d)
        f.close()

    def __getitem__(self,i):
        return self.array[i]

    def __iter__(self):
        return self.array.__iter__()
    
def stripquote(str):
    if len(str)>0:
        if str[0]=='"':
            str=str[1:]
        if str[len(str)-1]=='"':
            str=str[:len(str)-1]
    return(str)

class tablefile_named(tablefile):
    def __init__(self,filename,fieldname):
        tablefile.__init__(self,filename)
        self.d={}
        for entry in self.array:
            if self.d.has_key(entry[fieldname]):
                print 'ERROR: Duplicate id',entry[fieldname],'found in',filename
            self.d[entry[fieldname]]=entry

    def __getitem__(self,i):
        return self.d[i]

def printDivaHeader(destD):
    destD.write('drcExtractRules(\n\n')
    destD.write(' poly = geomOr( \"poly\" )\n active = geomOr( \"active\" )\n contact = geomOr( \"contact\" )\n select = geomOr( \"select\" )\n nwell = geomOr( \"nwell\" )\n pwell = geomOr( \"pwell\" )\n vtg = geomOr( \"vtg\" )\n vth = geomOr( \"vth\" )\n nimplant = geomOr( \"nimplant\" )\n pimplant = geomOr( \"pimplant\" )\n metal1 = geomOr( \"metal1\" )\n metal2 = geomOr( \"metal2\" )\n metal3 = geomOr( \"metal3\" )\n metal4 = geomOr( \"metal4\" )\n metal5 = geomOr( \"metal5\" )\n metal6 = geomOr( \"metal6\" )\n metal7 = geomOr( \"metal7\" )\n metal8 = geomOr( \"metal8\" )\n metal9 = geomOr( \"metal9\" )\n metal10 = geomOr( \"metal10\" )\n\n')
    destD.write(' ivIf( switch( \"drc?\" ) then\n\n')
    
def printDivaLayers(destD,deflayers): # expand to allow for multiple layers, operations, relations
    for l in range(len(deflayers.array)):
        curdeflayer=deflayers.__getitem__(l)
        deflayers1=curdeflayer['Layer1'].split(',')
        deflayers2=curdeflayer['Layer2'].split(',')
        destD.write('  '+curdeflayer['DefLayer']+' = '+curdeflayer['DefOp']+'( '+ curdeflayer['Layer1']+' '+curdeflayer['Layer2']+' )\n\n')

def printDivaErrMesg(currule,destD):
    destD.write('; Rule '+currule['RuleNo']+'\n')
    string = 'sprintf( errMesg \"(Rule ' + currule['RuleNo'] + ') ' + currule['Desc'] +': ' + currule['Value'] + ' um\" )'
    destD.write(string)
    destD.write('\n')

def printDivaDRC(currule,layers,layers2,destD):
    for k in range(len(layers)):
        string = '  drc( ' + layers[k]+' '+layers2[k]+' '+currule['Type']+' '+currule['Rel']+' '+currule['Value']+' '+currule['Extra']+' \"(Rule '+currule['RuleNo']+') '+layers[k]+' '+currule['Desc']+' '+layers2[k]+': '+currule['Value']+' um\" )'
        destD.write(string)
        destD.write('\n')

def printDivaDer(currule,layers,layers2,destD):
    for k in range(len(layers)):
        string = '  saveDerived( '+currule['Type']+'( '+layers[k]+' '+layers2[k]+' ) \"'+layers[k]+' '+currule['Desc']+' '+layers2[k]+'\" ) '
        destD.write(string)
        destD.write('\n')

def printDivaComment(currule,destD):
    destD.write('\n  /*\n   * '+currule['Value']+'\n   */\n\n')

def printAssuraHeader(destA):
    destA.write('drcExtractRules(\n\n')
    destA.write(' poly = geomOr( \"poly\" )\n active = geomOr( \"active\" )\n contact = geomOr( \"contact\" )\n select = geomOr( \"select\" )\n nwell = geomOr( \"nwell\" )\n pwell = geomOr( \"pwell\" )\n nimplant = geomOr( \"nimplant\" )\n pimplant = geomOr( \"pimplant\" )\n metal1 = geomOr( \"metal1\" )\n\n')
    destA.write(' ivIf( switch( \"drc?\" ) then\n\n')
    
def printAssuraLayers(destA,deflayers): # expand to allow for multiple layers, operations, relations
    for l in range(len(deflayers.array)):
        curdeflayer=deflayers.__getitem__(l)
        deflayers1=curdeflayer['Layer1'].split(',')
        deflayers2=curdeflayer['Layer2'].split(',')
        destA.write('  '+curdeflayer['DefLayer']+' = '+curdeflayer['DefOp']+'( '+ curdeflayer['Layer1']+' '+curdeflayer['Layer2']+' )\n\n')

def printAssuraErrMesg(currule,destA):
    destA.write('; Rule '+currule['RuleNo']+'\n')
    string = 'sprintf( errMesg \"(Rule ' + currule['RuleNo'] + ') ' + currule['Desc'] +': ' + currule['Value'] + ' um\" )'
    destA.write(string)
    destA.write('\n')

def printAssuraDRC(currule,layers,layers2,destA):
    for k in range(len(layers)):
        string = '  drc( ' + layers[k]+' '+layers2[k]+' '+currule['Type']+' '+currule['Rel']+' '+currule['Value']+' '+currule['Extra']+' \"(Rule '+currule['RuleNo']+') '+layers[k]+' '+currule['Desc']+' '+layers2[k]+': '+currule['Value']+' um\" )'
        destA.write(string)
        destA.write('\n')

def printAssuraDer(currule,layers,layers2,destA):
    for k in range(len(layers)):
        string = '  errorLayer( '+currule['Type']+'( '+layers[k]+' '+layers2[k]+' ) \"'+layers[k]+' '+currule['Desc']+' '+layers2[k]+'\" ) '
        destA.write(string)
        destA.write('\n')

def printAssuraComment(currule,destA):
    destA.write('\n  /*\n   * '+currule['Value']+'\n   */\n\n')

indir = '.'
outdir = '.'
# Parse arguments
args=sys.argv[1:]
#sshaft.logf('LOG_INFO',"Arguments: "+str(args))
while (len(args)>0):
    arg=args[0]
    args=args[1:]
    if (arg=="-in"):
        indir=args[0]
        args=args[1:]
    elif (arg=="-out"):
        outdir=args[0]
        args=args[1:]
    elif (arg=="-dir"):
        outdir=args[0]
        indir=args[0]
        args=args[1:]
    else:
        print 'WARNING: Unrecognized argument '+arg
rulesfile = indir+'/rules.txt'
layersfile = indir+'/layers.txt'
destDfile = outdir+'/divaDRC.rul'
destD=open(destDfile,'w')
destAfile = outdir+'/DRC.rul'
destA=open(destAfile,'w')
rules = tablefile(rulesfile)
deflayers=tablefile(layersfile)
printDivaHeader(destD)
printDivaLayers(destD,deflayers)
printAssuraHeader(destA)
printAssuraLayers(destA,deflayers)
for i in range(len(rules.array)):
    currule=rules.__getitem__(i)
#    currule['Value']=currule['Value']*5;
    if currule.has_key('Extra'):
        pass
    else:
        currule['Extra'] = ''
    layers = currule['Layers'].split(',')
    if currule.has_key('Layers2'):
        pass
    else:
        currule['Layers2']=''
    layers2 = currule['Layers2'].split(',')
    layers2.append('')
    if re.search('com',currule['RuleType']):
        printDivaComment(currule,destD)
	printAssuraComment(currule,destA)
    if re.search('drc',currule['RuleType']): 
        printDivaDRC(currule,layers,layers2,destD)
	printAssuraDRC(currule,layers,layers2,destA)
    elif re.search('save',currule['RuleType']):
        printDivaDer(currule,layers,layers2,destD)
	printAssuraDer(currule,layers,layers2,destA)
destD.write(' )\n)\n')
destA.write(' )\n)\n')






    
