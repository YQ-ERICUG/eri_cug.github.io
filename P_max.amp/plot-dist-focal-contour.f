      integer*4 dist_cont
      parameter(pi=3.1415926)
 

      deg2pi=pi/180.

c epicentre information
      read(*,*)  xlon,xlat,dist_cont 
 
      open(20,file='dist-strike-contour.txt')
      do idist=0,175,dist_cont   !the last is the interval between contours
        delta=idist
        do iaz=0,360,1
          tmaz=iaz

        if (idist .eq. 0) then
          write(20,*) xlon,xlat,0,tmaz,0
          
        else
      temp1=sqrt(1- ((cos(xlat*deg2pi))*(sin(delta*deg2pi))*
     &(cos(tmaz*deg2pi))+(cos(delta*deg2pi))*(sin(xlat*deg2pi)))**2)

      temp11=(cos(xlat*deg2pi))*(sin(delta*deg2pi))*
     &(cos(tmaz*deg2pi))+(cos(delta*deg2pi))*(sin(xlat*deg2pi))


 
      temp2=((sin(delta*deg2pi))*(sin(tmaz*deg2pi)))*1.0/temp1

      eqlat1=(asin(temp11))/deg2pi  
c      eqlat2=180-(asin(temp11))/deg2pi
       
      eqlon1=xlon+(asin(temp2))/deg2pi
      eqlon2=180+xlon-(asin(temp2))/deg2pi
     
      call dist_calculation(xlat,xlon,eqlat1,eqlon1,dist_deg1)
      call azimuth_cal(xlon,xlat,eqlon1,eqlat1,angle_deg1)

      call dist_calculation(xlat,xlon,eqlat1,eqlon2,dist_deg2)
      call azimuth_cal(xlon,xlat,eqlon2,eqlat1,angle_deg2)

c      call dist_calculation(xlat,xlon,eqlat2,eqlon1,dist_deg3)
c      call azimuth_cal(xlon,xlat,eqlon1,eqlat2,angle_deg3)

c      call dist_calculation(xlat,xlon,eqlat2,eqlon2,dist_deg4)
c      call azimuth_cal(xlon,xlat,eqlon2,eqlat2,angle_deg4)

      if (abs(dist_deg1-delta) .le. 0.01
     & .and. (abs(angle_deg1-tmaz) .le. 0.01
     & .or. nint(abs(angle_deg1-tmaz)/360) .eq. 1 )) then
         eqlon5=eqlon1;eqlat5=eqlat1;dist_deg= dist_deg1
      else if (abs(dist_deg2-delta) .le. 0.01
     & .and. (abs(angle_deg2-tmaz) .le. 0.01
     & .or. nint(abs(angle_deg2-tmaz)/360) .eq. 1 )) then
         eqlon5=eqlon2;eqlat5=eqlat1;dist_deg= dist_deg2
c      else if (abs(dist_deg3-delta) .le. 0.01
c     & .and. (abs(angle_deg3-tmaz) .le. 0.01
c     & .or. nint(abs(angle_deg3-tmaz)/360) .eq. 1 )) then
c         eqlon5=eqlon1;eqlat5=eqlat2;dist_deg= dist_deg3
c      else if (abs(dist_deg4-delta) .le. 0.01
c     & .and. (abs(angle_deg4-tmaz) .le. 0.01
c     & .or. nint(abs(angle_deg4-tmaz)/360) .eq. 1 )) then
c         eqlon5=eqlon2;eqlat5=eqlat2;dist_deg= dist_deg4
      else
         write(*,*) 'error',delta,tmaz
      end if
       
       write(20,*) eqlon5,eqlat5,int(delta),tmaz,nint(dist_deg)
      end if

       end do
       write(20,*) '>'
      end do

      end


       subroutine dist_calculation(xlat1,xlon1,plat1,plon1,dist_degree)

         pi=3.1415926
         dtemp1=cos((90-plat1)*pi/180)
     &*cos((90-xlat1)*pi/180)
         dtemp2=sin((90-plat1)*pi/180)*sin((90-xlat1)*pi/180)
         dtemp3=dtemp2*cos((xlon1-plon1)*pi/180)

         dist_degree=(180./pi)*acos(dtemp1+dtemp3)    
         if(abs(xlat1-plat1)+abs(xlon1-plon1).lt. 0.01)dist_degree=0

         end 

      subroutine azimuth_cal(eplon1,eplat1,stlon1,stlat1,angle_degree)
          pi=3.1415926    
	    
          eplon=eplon1*pi/180.    
	  eplat=eplat1*pi/180.  
	  stlon=stlon1*pi/180.
	  stlat=stlat1*pi/180.
	  
      	  e1 = cos(eplon)*cos(eplat)
	  e2 = sin(eplon)*cos(eplat)
	  e3 = sin(eplat)
	  
	  s1 = cos(stlon)*cos(stlat)
	  s2 = sin(stlon)*cos(stlat)
	  s3 = sin(stlat) 
	  
	  temp = e1*s1+e2*s2+e3*s3
          angle= atan2(cos(stlat)*cos(eplat)*sin(stlon-eplon)
     &,sin(stlat)-temp*sin(eplat))
          angle_degree=angle*180/pi
      end
