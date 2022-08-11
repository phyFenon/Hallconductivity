import numpy as np

import matplotlib.pyplot as plt

plt.rcParams['mathtext.fontset'] = 'stix'
plt.rc('font', family='STIXGeneral')
plt.rcParams['font.size'] = 16
plt.rcParams['axes.linewidth'] = 1





m=1
t0=0.0
##kxlist=[-0.9,-0.7,-0.5,-0.3,-0.1,0.0,0.1,0.3,0.5,0.7,0.9]
kxlist=[-0.9]
n=100


def plot_kx(m,n,t0,kx):
    fig=plt.figure(figsize=(3,3))
    data=np.genfromtxt("PBCm=%s_Bz_t0=%s_kx=%spi.txt"%(m,t0,kx))
    x=data[:,0]/np.pi
    ax1=fig.add_subplot(111)
##    plt.title(r'$k_x=%s\pi$'%(kx))
    ax1.plot(x,data[:,1:n+1],'b',lw=1)
    ax1.plot(x,data[:,n+2::],'b',lw=1)
    ax1.plot(x,data[:,n+1:n+2],'r',lw=1)
    ax1.axhline(0,c='gray',linestyle='--',lw=1)
    ax1.axhline(0.1,c='gray',linestyle='--',lw=1)
    ax1.axhline(0.45,c='gray',linestyle='--',lw=1)

    plt.xlim(-1,1.01,0.5)
    plt.ylim(-1.0,1.0)
    plt.xlabel(r'$k_{z}/\pi$',fontsize=18,labelpad=10)
    leg=ax1.legend(frameon=False)
    plt.savefig('PBCm=%s_kx=%spi.pdf'%(m,kx), dpi=1200, transparent=False, bbox_inches='tight')
    plt.show()
    plt.close()
    
for kx in kxlist:
    plot_kx(m,n,t0,kx)
