Program energyband
use omp_lib
Implicit None
Integer, Parameter :: width=100,n=2*width,nEpsilon=200,stepsx=1200,stepsz=1! width->the landau levels   
Double Precision, Parameter :: pi = atan(1.d0)*4
double precision,Dimension(5)::cparameter
complex *16,Dimension(nEpsilon+1,stepsx,stepsz)::hall
complex *16::hall_singlek
double precision::kx,kz,B,t1,t2,mu,eta
integer::i,j,k,fileindex  
    

Open (10, File='hall_m=1_t0=0.0_Bx.txt')

B=2*pi/width !width is the total layer of Y direction
fileindex=1

t1=omp_get_wtime()

 
 
!$omp parallel do private(mu,j,kz,i,kx,hall_singlek)
Do k=1+(fileindex-1)*48,nEpsilon+1
mu=(-1.0+(k-1)*2.0/nEpsilon)*0.8
print*,k

DO j=1,stepsz
kz = (-1 + j * 2.d0 / stepsz)*pi


DO i=1,stepsx
kx = (-1 + i * 2.d0 / stepsx)*pi


call Hamiltonian(kx,kz,mu,B,width,n,hall_singlek)

hall(k,i,j)=cmplx(0.0,1.0)*hall_singlek

enddo
enddo
ENDDO
!$omp end parallel do 

Do k=1+(fileindex-1)*48,nEpsilon+1
mu=(-1.0+(k-1)*2.0/nEpsilon)*0.8
write(10,100)mu,real(sum(hall(k,:,:)))/(stepsx*stepsz),aimag(sum(hall(k,:,:)))/(stepsx*stepsz)
enddo


100 format(f12.7,2x,f20.14,2x,f20.14)
    
Close (10)



t2=omp_get_wtime()
print*,'the total time:',(t2-t1)/60.0,'min'
  
End Program


subroutine Hamiltonian(kx,kz,mu,B,width,n,hall_singlek)
Implicit None
Integer, Parameter :: LWORK = 5000 !LWORK>=MAX(2*2*N-1)
Integer :: INFO,width,n,i,j,k
Double Precision, Parameter :: pi = atan(1.d0)*4
Complex * 16, Dimension (n, n) :: H,Vx,Vy,Vz,H0
Double Precision, Dimension (n) :: W
Complex * 16, Dimension (LWORK) :: WORK
Double Precision, Dimension (3*n-2) :: RWORK 
complex * 16,Dimension(n,1)::col_i,col_j
Complex * 16, Dimension(2,2) :: sigmax,sigmay,sigmaz,sigma0
complex * 16::cone,matrix,phase_ij,hall_singlek
double precision::kz,kx,B,mu,fermi,eta,mz,t0

t0=0.0
mz=0.0
eta=0.01
cone=cmplx(0.d0,1.d0)

sigma0=0.0
sigmax=0.0
sigmay=0.0
sigmaz=0.0
    
sigma0(1,1)=1.0
sigma0(2,2)=1.0
    
sigmax(1,2)=1.0
sigmax(2,1)=1.0
    
sigmay(1,2)=-cone
sigmay(2,1)=cone
    
sigmaz(1,1)=1.d0
sigmaz(2,2)=-1.d0

!----------------------------------------!    
Vz=0.0
Vy=0.0
!--------------Vx-----------------------!
do k=1,width
Vz(2*k-1:2*k,2*k-1:2*k)=-t0*sin(kz-k*B)*sigma0-sin(kz-k*B)*sigmaz
end do 
!------------the end--------------------!
!--------------Vy-----------------------!
do k=1,width-1
Vy(2*k-1:2*k,2*k+1:2*k+2)=sigmay/2.0+sigmaz/(2.0*cone)
end do 

!!------PBC---------!!
Vy(1:2,2*width-1:2*width)=sigmay/2.0+sigmaz/(-2.0*cone)
!------theend--------!

Vy=Vy+conjg(transpose(Vy))
!------------the end--------------------!

!!!------------the H values----------------------------------------------!!!
 H=0.0
 DO k=1,width
 H(2*k-1:2*k,2*k-1:2*k)=t0*cos(kz-k*B)*sigma0+sin(kx)*sigmax&
 &+(cos(kz-k*B)-mz+2.0-cos(kx))*sigmaz
 ENDDO
 
 Do k=1,width-1
 H(2*k-1:2*k,2*k+1:2*k+2)=sigmay/(2.0*cone)-sigmaz/2.0
 Enddo 
 
 !--------------PBC--------------------------------!
 H(1:2,2*width-1:2*width)=sigmay/(-2.0*cone)-sigmaz/2.0
 !--------------theend-----------------------------!

Call zheev ('V', 'U', n, H, n, W, WORK, LWORK, RWORK,INFO)
!-------------------the end----------------------------------------------!!!


phase_ij=0.0

do i=1,n
do j=1,n
col_i=H(:,i:i)
col_j=H(:,j:j)

if(i.ne.j) then
phase_ij=phase_ij+matrix(n,col_i,Vy,col_j)*matrix(n,col_j,Vz,col_i)&
&*(fermi(W(i),mu)-fermi(W(j),mu))/((W(i)-W(j))**2+eta**2)
end if


enddo
enddo
hall_singlek=phase_ij/width


END

function matrix(n,col_L,V,col_R)
Implicit none
Integer::n,i
complex * 16,Dimension(n,1)::col_L,col_R,col_temp
complex * 16,Dimension(n,n)::V
complex * 16::matrix

col_temp=0.0
col_temp=matmul(V,col_R)
matrix=0.0
do i=1,n
matrix=matrix+conjg(col_L(i,1))*col_temp(i,1)
enddo

return 
end function


function fermi(en_m,mu)
double precision::en_m,mu,fermi

if(en_m.le.mu)then
fermi=1.0
else 
fermi=0.0
end if
return

end function

function fermiT(en_m,mu,beta)
double precision::en_m,mu,fermi,beta

fermiT=1.0/(exp(beta*(en_m-mu))+1.0)

return
end function
