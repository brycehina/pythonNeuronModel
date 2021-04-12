import neuron,pprint,csv,os
from neuron import h,rxd,gui
from neuron.units import ms,mV

#mM,ms,mV
print(neuron.__version__)

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
    sec.insert('hh')
    sec.insert('pas')
    
sectionList[0].insert('nat')
sectionList[0].insert('nap')
sectionList[0].insert('k_sh')
sectionList[0].insert('k_shab')
sectionList[0].insert('k_shal')
sectionList[0].insert('k_shaw')

stimobj = h.IClamp(sectionList[0](0.5))
stimobj.delay = 200
stimobj.dur = 500
stimobj.amp = 500
stimobj.i = 0

s=h.Shape()
s.show(False)
#s.color(2,sec=sectionList[0])

#h.topology()
#h.finitialize()

#os.system("pause")

#soma = h.Section(name='soma')
#somaDict = soma.psection()
#pprint.pprint(somaDict)