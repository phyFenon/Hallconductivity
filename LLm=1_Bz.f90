!!!!!----------------------------------!!!!!!!
!!!!!
!!!!!now openboundery in the direction [0,0,1]
Program energyband
Implicit None
Integer ::width, n
    width=100
    n =2*width
Call hxz (width,n)
End Program
!
Subroutine hxz (width,n)
    Implicit None
    Integer::width,n
    Integer, Parameter :: LWORK = 5000 !LWORK>=MAX(2*2*N-1)
    Integer :: INFO
    Double Precision, Parameter :: pi = atan(1.d0)*4
    Complex * 16, Dimension (n, n) :: H
    Double Precision, Dimension (n) :: W
    Complex * 16, Dimension (LWORK) :: WORK
    Double Precision, Dimension (3*n-2) :: RWORK
    Complex * 16, Dimension(2,2) :: sigmax,sigmay,sigmaz,sigma0
    integer::i,j,k,fileindex,steps
    complex * 16::cone
    double precision, Dimension(11)::kx_arra
    double precision::kx,kz,B,mz,t0
    
    kx_arra=(/-0.9,-0.7,-0.5,-0.3,-0.1,0.0,0.1,0.3,0.5,0.7,0.9/)
    Open (10, File='PBCm=1_Bz_t0=0.0_kx=-0.9pi.txt')
    Open (11, File='PBCm=1_Bz_t0=0.0_kx=-0.7pi.txt')
    Open (12, File='PBCm=1_Bz_t0=0.0_kx=-0.5pi.txt')
    Open (13, File='PBCm=1_Bz_t0=0.0_kx=-0.3pi.txt')
    Open (14, File='PBCm=1_Bz_t0=0.0_kx=-0.1pi.txt')
    Open (15, File='PBCm=1_Bz_t0=0.0_kx=0.0pi.txt')
    Open (16, File='PBCm=1_Bz_t0=0.0_kx=0.1pi.txt')
    Open (17, File='PBCm=1_Bz_t0=0.0_kx=0.3pi.txt')
    Open (18, File='PBCm=1_Bz_t0=0.0_kx=0.5pi.txt')
    Open (19, File='PBCm=1_Bz_t0=0.0_kx=0.7pi.txt')
    Open (20, File='PBCm=1_Bz_t0=0.0_kx=0.9pi.txt')


    t0=0.0
    B=2*pi/width !width is the total layer of Y direction
    mz=0.0
    steps=100
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



do fileindex=1,11
kx=kx_arra(fileindex)*pi
print*,fileindex

DO i=0,steps,1
kz = (- 1.d0 + i * 2.d0 / steps)*pi
H = 0.d0

 DO k=1,width
 H(2*k-1:2*k,2*k-1:2*k)=t0*cos(kz)*sigma0+sin(kx+k*B)*sigmax+(cos(kz)-mz+2.0-cos(kx+k*B))*sigmaz
 ENDDO
 
 Do k=1,width-1
 H(2*k-1:2*k,2*k+1:2*k+2)=sigmay/(2.0*cone)-sigmaz/2.0
 Enddo
 
H(1:2,2*width-1:2*width)=sigmay/(-2.0*cone)-sigmaz/2.0
 
Call zheev ('V', 'U', n, H, n, W, WORK, LWORK, RWORK,INFO)

write(9+fileindex,*)kz,W(:)
        
end do
enddo        

End 

