import numpy as np
import matplotlib.pyplot as plt


plt.rcParams['mathtext.fontset'] = 'stix'
plt.rc('font', family='STIXGeneral')
plt.rcParams['font.size'] = 20
plt.rcParams['axes.linewidth'] = 1


#fig=plt.figure(figsize=(6.5,5))
fig=plt.figure()

m=[1,2,3]
t0=[0.0,0.5,1.2]

index=0## the topological charge

data1=np.genfromtxt("hall_m=%s_t0=%s_Bx.txt"%(m[index],t0[0]))
data2=np.genfromtxt("hall_m=%s_t0=%s_Bx.txt"%(m[index],t0[1]))
##data3=np.genfromtxt("hall_m=%s_t0=%s_Bx.txt"%(m[index],t0[2]))



ax1=fig.add_subplot(111)


ax1.plot(data1[:,0],data1[:,1],'s-',markersize=3.5,lw=1,label=r"$t_{0}=%s$"%t0[0])
ax1.plot(data2[:,0],data2[:,1],'o-',markersize=3.5,lw=1,label=r"$t_{0}=%s$"%t0[1])


axins = ax1.inset_axes([0.15, 0.08, 0.3, 0.2])
axins.plot(data1[:,0],data1[:,1],'s-',ms=1.5,lw=1)
axins.plot(data2[:,0],data2[:,1],'o-',ms=1.5,lw=1)
axins.set_xscale('linear')
x1, x2, y1, y2 =-0.2,0.2, -0.01, 0.01
axins.set_xlim(x1, x2)
axins.set_ylim(y1, y2)


plt.xlim(-0.8,0.8)
##plt.ylim(-0.1,0.06)
plt.xlabel(r'$\mu$',fontsize=22,labelpad=5)
plt.ylabel(r'$\sigma_{yz}$',fontsize=22,labelpad=5)
leg=ax1.legend(frameon=False,ncol=3,loc='best')
ax1.indicate_inset_zoom(axins)
plt.savefig('hall_m=%s_BxPBCI.pdf'%m[index], dpi=2000, transparent=False, bbox_inches='tight')
plt.show()
