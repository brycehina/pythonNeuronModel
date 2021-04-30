import neuron,pprint,csv,os
import numpy as np
from neuron import h,rxd,gui
from neuron.units import ms,mV
from matplotlib import pyplot

#mM,ms,mV
#print(neuron.__version__)

compartmentLabelMap = []
with open('compartmentLabelMap.csv') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',',quotechar = '|')
    
    for row in spamreader:
        compartmentLabelMap.append(row[0])

compartmentLabelMap.insert(0,'soma')
labelSet = set(compartmentLabelMap)
compartmentIdx2LabelMap = np.array(compartmentLabelMap)

compartmentLabel2IdxMap = {}
for label in labelSet:
    labelMatchIdxList = [i for i, x in enumerate(compartmentIdx2LabelMap) if x == label]
    # print(label)
    # print(labelMatchIdxList)
    # print(compartmentLabelMap[labelMatchIdxList])
    compartmentLabel2IdxMap[label] = labelMatchIdxList;
    # print(compartmentLabel2IdxMap[label])    


connectionVector = []
with open('connectivityVector.csv') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',',quotechar = '|',quoting=csv.QUOTE_NONNUMERIC)
    
    for row in spamreader:
        connectionVector.append(row)
        
coordinateTable = []
with open('coordinateTable.csv') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',',quotechar = '|',quoting=csv.QUOTE_NONNUMERIC)
    
    for row in spamreader:
        coordinateTable.append(row)
        
#pprint.pprint(coordinateTable)

sectionList = [h.Section()]*(len(connectionVector)+1)
#pprint.pprint(sectionList)
sectionId = -1
for n in range(len(coordinateTable)):
    if sectionId != coordinateTable[n][7]:
        sectionId = int(coordinateTable[n][7])
        sectionList[sectionId] = h.Section(name = f'{sectionId}')
        sectionList[sectionId].pt3dclear()
        sectionList[sectionId].pt3dadd(coordinateTable[n][0],coordinateTable[n][1],coordinateTable[n][2],coordinateTable[n][6])
    sectionList[sectionId].pt3dadd(coordinateTable[n][3],coordinateTable[n][4],coordinateTable[n][5],coordinateTable[n][6])
    
#pprint.pprint(sectionList)

for n in range(len(connectionVector)):
    targetId = int(connectionVector[n][0]);
    if connectionVector[n][1]==1:
        sectionList[n+1].connect(sectionList[targetId])
    else:
        sectionList[n+1].connect(sectionList[targetId](0))
    

sl = h.SectionList(sectionList)

for sec in sl:
    sec.insert('pas')
    sec(0.5).pas.g = 1.2e-3
    
for sec in compartmentLabel2IdxMap['siz']:
    # print(sec)
    sectionList[sec].insert('nat')
    sectionList[sec].insert('nap')
    sectionList[sec].insert('k_shal')
    sectionList[sec].insert('k_shaw')
    sectionList[sec].insert('k_shab')
    sectionList[sec].insert('k_sh')
    

# sectionList[0].insert('nat')
# sectionList[0].insert('nap')
# sectionList[0].insert('k_sh')
# sectionList[0].insert('k_shab')
# sectionList[0].insert('k_shal')
# sectionList[0].insert('k_shaw')

somaSection = compartmentLabel2IdxMap['soma'][0]
sizSection = compartmentLabel2IdxMap['siz'][0]

stimobj = h.IClamp(sectionList[somaSection](0.5))
stimobj.delay = 15
stimobj.dur = 85
stimobj.amp = 5
stimobj.i = 0

h.tstop = 120

vVec = h.Vector()
tVec = h.Vector()

vVec.record(sectionList[sizSection](0.5)._ref_v)
tVec.record(h._ref_t)

sectionList[sizSection](0.5).k_shaw.gmax = 1.3e-3
sectionList[sizSection](0.5).k_shal.gmax = 1.3e-3
sectionList[sizSection](0.5).k_shab.gmax = 1.8e-3
sectionList[sizSection](0.5).nat.gmax = 900e-3
for g in range(2,9):
    gVal = g*1.5e-3
    print(gVal)
    sectionList[sizSection](0.5).k_sh.gmax = gVal

    h.run()

    pyplot.figure(figsize=(8,4)) # Default figsize is (8,6)
    pyplot.plot(tVec, vVec)
    pyplot.xlabel('time (ms)')
    pyplot.ylabel('mV')
    pyplot.show()

s=h.Shape()
s.show(False)
#s.color(2,sec=sectionList[0])

#h.topology()
#h.finitialize()

#os.system("pause")

#soma = h.Section(name='soma')
#somaDict = soma.psection()
#pprint.pprint(somaDict)