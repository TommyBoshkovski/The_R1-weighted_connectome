import csv
import argparse
import statistics as s
import numpy as np
import scipy.io as sio




if __name__=="__main__":
	parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,prog='medianTracts.py')
	parser.add_argument('--dir', nargs=1, type=str)
	parser.add_argument('--sub', nargs=1, type=str)
	parser.add_argument('--fa', nargs=1, type=str)
	parser.add_argument('--r1', nargs=1, type=str)
	parser.add_argument('--a', nargs=1, type=str)
	parser.add_argument('--out', nargs=1, type=str)
	args = parser.parse_args()
	clarg = vars(args)


	fare = csv.reader(open(clarg['dir'][0]+"/"+clarg['sub'][0]+"/"+clarg['fa'][0]), delimiter=' ', skipinitialspace=True)
	are = csv.reader(open(clarg['dir'][0]+"/"+clarg['sub'][0]+"/"+clarg['a'][0]), delimiter=' ', skipinitialspace=True)
	r1re = csv.reader(open(clarg['dir'][0]+"/"+clarg['sub'][0]+"/"+clarg['r1'][0]), delimiter=' ', skipinitialspace=True)
	mr1 = np.zeros((234,234))
	mfa = np.zeros((234,234))
	mnos = np.zeros((234,234))

	dfa={}
	dr1={}
	next(fare)
	next(r1re)
	next(are)

	for nodes,fa,r1 in zip(are,fare,r1re):
		if int(nodes[0]) != 0 and int(nodes[1]) != 0:
			if nodes[0] + "," + nodes[1] in dfa:
				dfa[nodes[0] + "," + nodes[1]].extend([float(i) for i in fa])
				dr1[nodes[0] + "," + nodes[1]].extend([float(i) for i in r1])
				mnos[int(nodes[0])-1][int(nodes[1])-1]+=1
				mnos[int(nodes[1])-1][int(nodes[0])-1]+=1
			else:
				dfa[nodes[0] + "," + nodes[1]]=[float(i) for i in fa]
				dr1[nodes[0] + "," + nodes[1]]=[float(i) for i in r1]
				mnos[int(nodes[0])-1][int(nodes[1])-1]+=1
				mnos[int(nodes[1])-1][int(nodes[0])-1]+=1

	for i in range(1,234):
		for j in range(1,234):
			if i==j:
				continue
			if str(i) + "," + str(j) in dfa:
				famed = s.median( dfa[ str(i) + "," + str(j) ] )
				r1med = s.median( dr1[ str(i) + "," + str(j) ] )
				mfa[i-1][j-1] = famed
				mfa[j-1][i-1] = famed
				mr1[i-1][j-1] = r1med
				mr1[j-1][i-1] = r1med
	sio.savemat(clarg['dir'][0]+"/"+clarg['sub'][0]+"/"+clarg['out'][0],{'FAconnectome': mfa, 'R1connectome': mr1, 'NOSconnectome': mnos})
