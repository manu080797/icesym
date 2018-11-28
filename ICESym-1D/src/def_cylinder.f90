module def_cylinder

  use def_simulator
  use def_valve
  use def_multivalve
  use gasdyn_utils
  use utilities
  use, intrinsic :: ISO_C_BINDING

  type, BIND(C) :: fuel
     real(C_DOUBLE) :: Q_fuel,y,alpha,beta,gamma,delta,Mw,hvap_fuel
     real(C_DOUBLE) :: coef_cp(5)
  end type fuel

  type :: injection
     integer :: pulse, ignition_delay_model
     real*8 :: m_inj, dtheta_inj, T_fuel, theta_inj_ini, theta_id, integral
     real*8, dimension(:,:), pointer :: mfdot_array
  end type injection

  type :: combustion
     integer :: combustion_model
     real*8, dimension(:,:),pointer  :: xbdot_array
     real*8 :: theta_ig_0, dtheta_comb, phi, phi_ig, a_wiebe, m_wiebe
     real*8 :: mass_fuel_ini, mass_air_ini, mass_res_ini
     logical :: start_comb
  end type combustion

  type, BIND(C) :: scavenge
     real(C_DOUBLE) :: val_1, val_2, SRv
     logical(C_BOOL) :: close_cyl
  end type scavenge

  type :: geometry_type
      real*8 :: V_max,l_max
      integer :: l_num,V_num
      real*8, dimension(:,:),pointer :: Aw
      real*8, dimension(:,:),pointer :: Al
  end type geometry_type  

  type, BIND(C) :: this
      real(C_DOUBLE) :: Bore,crank_radius,Vol_clearance,rod_length,head_chamber_area, &
          piston_area,theta_0,delta_ca,Twall,factor_ht, &
          major_radius,minor_radius,chamber_heigh, converge_var_old, converge_var_new
      integer(C_INT) :: nnod_input,nvi,nve,nnod,ndof,model_ht, type_ig, nunit, &
          species_model,ntemp,nvanes, converge_mode
      logical(C_BOOL) :: scavenge, full_implicit,nh_temp
  end type this

  type :: cylinder
     type(fuel)::fuel_data
     type(injection)::injection_data
     type(combustion)::combustion_data
     type(scavenge)::scavenge_data
     type(geometry_type)::geometry_data
     type(valve),dimension(:),pointer::intake_valves
     type(valve),dimension(:),pointer::exhaust_valves
     real*8,dimension(:),pointer :: prop, U_crevice, data_crevice
     integer :: nvi, nve
     real*8,dimension(2) :: mean_exhaust_gamma
     real*8,dimension(3) :: state_multizone
     type(gas_properties)::gas_properties
  end type cylinder

  type (cylinder),dimension(:),allocatable :: cyl
  integer :: numcyl

contains

  include 'mrcvc.i'

  subroutine initialize_cylinders(ncyl) BIND(C)
    use, intrinsic :: ISO_C_BINDING
    integer(C_INT) :: ncyl
    allocate(cyl(ncyl))
    numcyl = ncyl
    return
  end subroutine initialize_cylinders

  subroutine initialize_valves(icyl,nvi,nve) BIND(C)
    use, intrinsic :: ISO_C_BINDING
    integer(C_INT) :: icyl,nvi,nve
    allocate(cyl(icyl)%intake_valves(nvi))
    allocate(cyl(icyl)%exhaust_valves(nve))
    cyl(icyl)%nvi = nvi
    cyl(icyl)%nve = nve
    return
  end subroutine initialize_valves

  subroutine initialize_arrays(icyl, prop, U_crevice, data_crevice,l1,l2,l3) BIND(C)
    use, intrinsic :: ISO_C_BINDING
    integer(C_INT) :: icyl,l1,l2,l3
    real(C_DOUBLE) :: prop(0:l1-1), U_crevice(0:l2-1), data_crevice(0:l3-1)
    allocate(cyl(icyl)%prop(l1))
    allocate(cyl(icyl)%U_crevice(l2))
    allocate(cyl(icyl)%data_crevice(l3))

    do i=1,(l1)
       cyl(icyl)%prop(i) = prop(i-1)
    enddo
    do i=1,(l2)
       cyl(icyl)%U_crevice(i) = U_crevice(i-1)
    enddo
    do i=1,(l3)
       cyl(icyl)%data_crevice(i) = data_crevice(i-1)
    enddo
    return
  end subroutine initialize_arrays

  subroutine initialize_fuel(icyl,fuelData) BIND(C)
    use, intrinsic :: ISO_C_BINDING
    integer(C_INT) :: icyl
    type(fuel)::fuelData
    cyl(icyl)%fuel_data%Q_fuel    = fuelData%Q_fuel
    cyl(icyl)%fuel_data%y         = fuelData%y
    cyl(icyl)%fuel_data%alpha     = fuelData%alpha
    cyl(icyl)%fuel_data%beta      = fuelData%beta
    cyl(icyl)%fuel_data%gamma     = fuelData%gamma
    cyl(icyl)%fuel_data%delta     = fuelData%delta
    cyl(icyl)%fuel_data%Mw        = fuelData%Mw
    cyl(icyl)%fuel_data%hvap_fuel = fuelData%hvap_fuel
    do i=1,5
       cyl(icyl)%fuel_data%coef_cp(i) = fuelData%coef_cp(i-1)
    end do
  end subroutine initialize_fuel

  subroutine initialize_scavenge(icyl,scavengeData) BIND(C)
    use, intrinsic :: ISO_C_BINDING
    integer(C_INT) :: icyl
    type(scavenge)::scavengeData
    cyl(icyl)%scavenge_data%val_1     = scavengeData%val_1
    cyl(icyl)%scavenge_data%val_2     = scavengeData%val_2
    cyl(icyl)%scavenge_data%SRv       = scavengeData%SRv
    cyl(icyl)%scavenge_data%close_cyl = scavengeData%close_cyl
    return
  end subroutine initialize_scavenge

  subroutine initialize_injection(icyl,pulse,m_inj,dtheta_inj,T_fuel,theta_inj_ini, &
       theta_id, integral, mfdot_array, ignition_delay_model, l1) BIND(C)
    use, intrinsic :: ISO_C_BINDING
    integer(C_INT) :: icyl, pulse, l1,ignition_delay_model
    real(C_DOUBLE) :: m_inj,dtheta_inj,T_fuel,theta_inj_ini, theta_id, integral
    real(C_DOUBLE) :: mfdot_array(0:l1-1)
    cyl(icyl)%injection_data%pulse                = pulse
    cyl(icyl)%injection_data%m_inj                = m_inj
    cyl(icyl)%injection_data%dtheta_inj           = dtheta_inj
    cyl(icyl)%injection_data%T_fuel               = T_fuel
    cyl(icyl)%injection_data%theta_inj_ini        = theta_inj_ini
    cyl(icyl)%injection_data%theta_id             = theta_id
    cyl(icyl)%injection_data%integral             = integral
    cyl(icyl)%injection_data%ignition_delay_model = ignition_delay_model

    allocate(cyl(icyl)%injection_data%mfdot_array(l1/2,2))
    do i=1,(l1/2)
       cyl(icyl)%injection_data%mfdot_array(i,1) = mfdot_array((i-1)*2)
       cyl(icyl)%injection_data%mfdot_array(i,2) = mfdot_array((i-1)*2 +1)
    enddo

    return
  end subroutine initialize_injection

  subroutine initialize_combustion(icyl,theta_ig_0, dtheta_comb, phi, phi_ig, a_wiebe, m_wiebe, &
       xbdot_array, combustion_model, start_comb, l1) BIND(C)
    use, intrinsic :: ISO_C_BINDING
    integer(C_INT) :: icyl,l1,combustion_model
    real(C_DOUBLE) :: xbdot_array(0:(l1-1))
    real(C_DOUBLE) :: theta_ig_0, dtheta_comb, phi, phi_ig, a_wiebe, m_wiebe
    logical(C_BOOL) :: start_comb

    cyl(icyl)%combustion_data%theta_ig_0       = theta_ig_0
    cyl(icyl)%combustion_data%dtheta_comb      = dtheta_comb
    cyl(icyl)%combustion_data%phi              = phi
    cyl(icyl)%combustion_data%phi_ig           = phi_ig
    cyl(icyl)%combustion_data%a_wiebe          = a_wiebe
    cyl(icyl)%combustion_data%m_wiebe          = m_wiebe
    cyl(icyl)%combustion_data%combustion_model = combustion_model
    cyl(icyl)%combustion_data%start_comb       = start_comb

    allocate(cyl(icyl)%combustion_data%xbdot_array(2,l1/2))
    do i=1,(l1/2)
       cyl(icyl)%combustion_data%xbdot_array(i,1) = xbdot_array((i-1)*2)
       cyl(icyl)%combustion_data%xbdot_array(i,2) = xbdot_array((i-1)*2 +1)
    enddo

  end subroutine initialize_combustion

  subroutine initialize_geometry(icyl,Aw,Al,V_max,l_max,V_num,l_num) BIND(C)
    use, intrinsic :: ISO_C_BINDING
    integer(C_INT) :: icyl
    integer(C_INT),intent(in) :: l_num,V_num
    real(C_DOUBLE),intent(in) :: V_max,l_max
    real(C_DOUBLE),intent(in) :: Al(0:(1+V_num)*(1+l_num)-1)
    real(C_DOUBLE),intent(in) :: Aw(0:(1+V_num)*(1+l_num)-1)
    type(dataSim) :: globalData
    integer :: i,j
    logical :: exist

    cyl(icyl)%geometry_data%V_num = V_num
    cyl(icyl)%geometry_data%V_max = V_max
    cyl(icyl)%geometry_data%l_num = l_num
    cyl(icyl)%geometry_data%l_max = l_max

    allocate(cyl(icyl)%geometry_data%Al(V_num+1,l_num+1))
    allocate(cyl(icyl)%geometry_data%Aw(V_num+1,l_num+1))


    do i=1,V_num+1
      do j=1,l_num+1
      cyl(icyl)%geometry_data%Aw(i,j) = Aw((i-1)*(l_num+1)+j-1)
      cyl(icyl)%geometry_data%Al(i,j) = Al((i-1)*(l_num+1)+j-1)
      enddo

      !DEBUG
      if (globalData%debug.gt.0) then
        write(*,*) " Aw: ", cyl(icyl)%geometry_data%Aw(i,:)
        write(*,*) " Al: ", cyl(icyl)%geometry_data%Al(i,:)
      end if
      !DEBUG

    enddo

    ! Check that Fortran received correct geometry data and formatted correctly
    if (sum(cyl(icyl)%geometry_data%Aw)/sum(cyl(icyl)%geometry_data%Aw).ne.1) then
          write(*,*) "NAN in Aw in geometry data in Fortran. Probably due to wrong l_num or V_num."
    end if
    if (sum(cyl(icyl)%geometry_data%Al)/sum(cyl(icyl)%geometry_data%Al).ne.1) then
          write(*,*) "NAN in Al in geometry data in Fortran. Probably due to wrong l_num or V_num."
    end if
    if (sum(Aw)/sum(Aw).ne.1) then
          write(*,*) "NAN in Aw in geometry data in C. Probably due to wrong l_num or V_num or bad geometry value in data."
    end if
    if (sum(Al)/sum(Al).ne.1) then
          write(*,*) "NAN in Aw in geometry data in C. Probably due to wrong l_num or V_num or bad geometry value in data."
    end if

    !DEBUG
    if (globalData%debug.gt.0) then
        inquire(file="cylinder_debug.csv", exist=exist)
            if (exist) then
                open(13, file="cylinder_debug.csv", status="old", position="append", action="write")
            else
                open(13, file="cylinder_debug.csv", status="new", action="write")
            end if
    end if
    !DEBUG

  end subroutine initialize_geometry

  subroutine initialize_intake_valves(icyl, ival, Nval, type_dat, angle_VO, angle_VC, &
       Dv, Lvmax, Cd, Lv, valve_model, l1, l2, dx_tube, Area_tube, twall_tube, &
       dAreax_tube, tube, theta_0, globalData) BIND(C)
    use, intrinsic :: ISO_C_BINDING
    integer(C_INT) :: icyl,ival,l1,l2,tube
    integer(C_INT) :: Nval, type_dat,valve_model
    real(C_DOUBLE) :: Cd(0:l1-1), Lv(0:l2-1)
    real(C_DOUBLE) :: angle_VO, angle_VC, Dv, Lvmax, theta_0
    real(C_DOUBLE) :: Area_tube, twall_tube, dAreax_tube, dx_tube
    type(dataSim) :: globalData

    real*8 :: Area_T

    cyl(icyl)%intake_valves(ival)%tube        = tube
    cyl(icyl)%intake_valves(ival)%Nval        = Nval
    cyl(icyl)%intake_valves(ival)%type_dat    = type_dat
    cyl(icyl)%intake_valves(ival)%angle_VO    = angle_VO
    cyl(icyl)%intake_valves(ival)%angle_VC    = angle_VC
    cyl(icyl)%intake_valves(ival)%dx_tube     = dx_tube
    cyl(icyl)%intake_valves(ival)%Area_tube   = Area_tube
    cyl(icyl)%intake_valves(ival)%dAreax_tube = dAreax_tube
    cyl(icyl)%intake_valves(ival)%twall_tube  = twall_tube
    cyl(icyl)%intake_valves(ival)%Dv          = Dv
    cyl(icyl)%intake_valves(ival)%Lvmax       = Lvmax
    cyl(icyl)%intake_valves(ival)%valve_model = valve_model

    allocate(cyl(icyl)%intake_valves(ival)%Cd(l1/2,2))
    allocate(cyl(icyl)%intake_valves(ival)%Lv(l2/2,2))
    do i=1,(l1/2)
       cyl(icyl)%intake_valves(ival)%Cd(i,1) = Cd((i-1)*2)
       cyl(icyl)%intake_valves(ival)%Cd(i,2) = Cd((i-1)*2 +1)
    enddo
    do i=1,(l2/2)
       cyl(icyl)%intake_valves(ival)%Lv(i,1) = Lv((i-1)*2)
       cyl(icyl)%intake_valves(ival)%Lv(i,2) = Lv((i-1)*2 +1)
    enddo

    call area_valve(theta_0, Dv, angle_VO, angle_VC, Lvmax, Nval, &
         type_dat, cyl(icyl)%intake_valves(ival)%Lv, &
         cyl(icyl)%intake_valves(ival)%Cd, globalData%theta_cycle, Area_T)
    cyl(icyl)%intake_valves(ival)%Area  = Area_T
    cyl(icyl)%intake_valves(ival)%dArea = 0.
    cyl(icyl)%intake_valves(ival)%Area_max  = Nval*pi*Dv*Lvmax

    cyl(icyl)%intake_valves(ival)%solved_case = 0

    cyl(icyl)%intake_valves(ival)%mass_res_port = 0.0d0
    cyl(icyl)%intake_valves(ival)%mass_flow_factor = 1.0d0

  end subroutine initialize_intake_valves

  subroutine initialize_exhaust_valves(icyl, ival, Nval, type_dat, angle_VO, angle_VC, &
       Dv, Lvmax, Cd, Lv, valve_model, l1, l2, dx_tube, Area_tube, twall_tube, dAreax_tube, &
       tube, theta_0, globalData) BIND(C)
    use, intrinsic :: ISO_C_BINDING
    integer(C_INT) :: icyl,ival,l1,l2,tube
    integer(C_INT) :: Nval, type_dat,valve_model
    real(C_DOUBLE) :: Cd(0:l1-1), Lv(0:l2-1)
    real(C_DOUBLE) :: angle_VO, angle_VC, Dv, Lvmax, theta_0
    real(C_DOUBLE) :: Area_tube, twall_tube, dAreax_tube, dx_tube
    type(dataSim) :: globalData

    real*8 :: Area_T

    cyl(icyl)%exhaust_valves(ival)%tube        = tube
    cyl(icyl)%exhaust_valves(ival)%Nval        = Nval
    cyl(icyl)%exhaust_valves(ival)%type_dat    = type_dat
    cyl(icyl)%exhaust_valves(ival)%angle_VO    = angle_VO
    cyl(icyl)%exhaust_valves(ival)%angle_VC    = angle_VC
    cyl(icyl)%exhaust_valves(ival)%dx_tube     = dx_tube
    cyl(icyl)%exhaust_valves(ival)%Area_tube   = Area_tube
    cyl(icyl)%exhaust_valves(ival)%dAreax_tube = dAreax_tube
    cyl(icyl)%exhaust_valves(ival)%twall_tube  = twall_tube
    cyl(icyl)%exhaust_valves(ival)%Dv          = Dv
    cyl(icyl)%exhaust_valves(ival)%Lvmax       = Lvmax
    cyl(icyl)%exhaust_valves(ival)%valve_model = valve_model

    allocate(cyl(icyl)%exhaust_valves(ival)%Cd(l1/2,2))
    allocate(cyl(icyl)%exhaust_valves(ival)%Lv(l2/2,2))
    do i=1,(l1/2)
       cyl(icyl)%exhaust_valves(ival)%Cd(i,1) = Cd((i-1)*2)
       cyl(icyl)%exhaust_valves(ival)%Cd(i,2) = Cd((i-1)*2 +1)
    enddo
    do i=1,(l2/2)
       cyl(icyl)%exhaust_valves(ival)%Lv(i,1) = Lv((i-1)*2)
       cyl(icyl)%exhaust_valves(ival)%Lv(i,2) = Lv((i-1)*2 +1)
    enddo

    call area_valve(theta_0, Dv, angle_VO, angle_VC, Lvmax, Nval, &
         type_dat, cyl(icyl)%exhaust_valves(ival)%Lv, &
         cyl(icyl)%exhaust_valves(ival)%Cd, globalData%theta_cycle, Area_T)
    cyl(icyl)%exhaust_valves(ival)%Area  = Area_T
    cyl(icyl)%exhaust_valves(ival)%dArea = 0.
    cyl(icyl)%exhaust_valves(ival)%Area_max  = Nval*pi*Dv*Lvmax

    cyl(icyl)%exhaust_valves(ival)%solved_case = 0

    cyl(icyl)%exhaust_valves(ival)%mass_res_port = 1.0d0
    cyl(icyl)%exhaust_valves(ival)%mass_flow_factor = 1.0d0

  end subroutine initialize_exhaust_valves

  subroutine state_initial_cylinder(icyl, myData, atm, globalData, state_ini, mass_C, twall) BIND(C)
    !
    !
    !  state_initial_cylinder is called by:
    !  state_initial_cylinder calls the following subroutines and functions:
    !    geometry, run_ideal_cycle, interpolant, fa_ratio
    !
    use, intrinsic :: ISO_C_BINDING
    type(this) :: myData
    type(dataSim) :: globalData
    real(C_DOUBLE) :: atm(0:2)
    integer(C_INT) :: icyl,ntemp
    real(C_DOUBLE) :: state_ini(0:((myData%nnod+myData%nnod_input)*myData%ndof)-1)
    real(C_DOUBLE) :: mass_C(6*(myData%nnod - myData%nvi - myData%nve ) )
	real*8,dimension(mydata%ntemp):: t_wall
    real(C_DOUBLE) :: twall(0:mydata%ntemp-1)


    integer :: i,ival,idof
    real*8 :: theta,Vol,Area,Vdot,phi,y,factor,theta_ig_0,theta_ig_f,EVC
    real*8 :: mass_fuel_ini,mass_air_ini,mass_res_ini,alpha,rho,pres,temp
    real*8 :: eps
    real*8, dimension(3) :: atm_state
    real*8, dimension(7,4) :: avpt
    do i=0,2
       atm_state(i+1) = atm(i)
    end do

    theta = myData%theta_0*180./pi

    call geometry(myData, globalData, Vol, Area, Vdot)
    call run_ideal_cycle(icyl, myData, globalData, atm_state, avpt)
    ! The initial state is intepolated from an ideal cycle
    call interpolant(avpt(:,1), avpt(:,2), theta, rho)
    call interpolant(avpt(:,1), avpt(:,3), theta, pres)
    call interpolant(avpt(:,1), avpt(:,4), theta, temp)

    mass_air_ini = Vol*rho
    if(myData%type_ig.eq.0) then
       phi           = cyl(icyl)%combustion_data%phi
       y             = cyl(icyl)%fuel_data%y
       factor        = fa_ratio(phi,y)
       mass_fuel_ini = mass_air_ini*factor

       theta_ig_0 = cyl(icyl)%combustion_data%theta_ig_0*180./pi
       theta_ig_f = theta_ig_0+cyl(icyl)%combustion_data%dtheta_comb*180./pi
    else
       theta_ig_0 = (cyl(icyl)%injection_data%theta_inj_ini + &
            cyl(icyl)%injection_data%theta_id)*180./pi
       theta_ig_f = theta_ig_0 + cyl(icyl)%combustion_data%dtheta_comb*180./pi

       mass_fuel_ini = cyl(icyl)%injection_data%m_inj
       y             = cyl(icyl)%fuel_data%y
       factor        = fa_ratio(1.0d0,y)
       ! cyl(icyl)%combustion_data%phi_ig = mass_fuel_ini/(mass_air_ini*factor)
    end if

    EVC = cyl(icyl)%exhaust_valves(1)%angle_VC*180./pi

    alpha = 0.0
    if(globalData%theta_cycle.eq.4.*pi) then
       if((theta.gt.theta_ig_0).and.(theta.le.theta_ig_f)) then
          ! Combustion
          alpha = (theta-theta_ig_0)/(theta_ig_f-theta_ig_0)
       elseif((theta.gt.theta_ig_f).and.(theta.le.720.)) then
          ! Expansion, gas exhaust or partial valve overlap
          alpha = 1.0
       elseif((theta.ge.0).and.(theta.le.EVC))then
          ! Valve overlap with partial load
          alpha = 1.0-(theta-0.)/(EVC-0.)
       endif
    elseif(globalData%theta_cycle.eq.2.*pi) then
       if((theta.gt.theta_ig_0).or.(theta.le.theta_ig_f)) then
          ! Combustion
          alpha = (theta-theta_ig_0-floor((theta-theta_ig_0)/360.)*360.)/ &
               (theta_ig_f-theta_ig_0-floor((theta_ig_f-theta_ig_0)/360.)*360.)
       elseif((theta.gt.theta_ig_f).and.(theta.le.180.)) then
          ! Expansion, gas exhaust or partial valve overlap
          alpha = 1.0
       elseif((theta.ge.180.).and.(theta.le.EVC)) then
          ! Valve overlap with partial load
          alpha = 1.0-(theta-180.)/(EVC-180.)
       endif
    else
       if(globalData%engine_type.eq.2) then   ! MRCVC
          if((theta.gt.theta_ig_0).and.(theta.le.theta_ig_f)) then
             ! Combustion
             alpha = (theta-theta_ig_0)/(theta_ig_f-theta_ig_0)
          elseif((theta.gt.theta_ig_f).and. &
               (theta.le.360.*(1.+2./myData%nvanes))) then
             ! Expansion, gas exhaust or partial valve overlap
             alpha = 1.0
          elseif((theta.ge.0.).and.(theta.le.EVC)) then
             ! Valve overlap with partial load
             alpha = 1.0-(theta-0.)/(EVC-0.)
          endif
       end if
    endif
    mass_fuel_ini = (1.-alpha)*mass_fuel_ini
    mass_res_ini  = alpha*mass_air_ini
    mass_air_ini  = (1.-alpha)*mass_air_ini
    if(myData%type_ig.eq.1) then
       cyl(icyl)%combustion_data%phi = 0.0d0
       if(mass_air_ini.ne.0.) &
            cyl(icyl)%combustion_data%phi = mass_fuel_ini/(mass_air_ini*factor)
       cyl(icyl)%combustion_data%phi_ig = cyl(icyl)%combustion_data%phi
    end if
    ! Cylinder state
    state_ini(0) = rho
    state_ini(1) = pres
    state_ini(2) = temp
    ! States at the pipe end connected to valves
    do i=1,myData%nnod-1
       state_ini(i*myData%ndof+0) = atm_state(1)
       state_ini(i*myData%ndof+1) = atm_state(2)
       state_ini(i*myData%ndof+2) = atm_state(3)
    enddo

    do i=1,myData%nnod-myData%nvi-myData%nve
       mass_C(6*(i-1) + 1) = mass_fuel_ini
       mass_C(6*(i-1) + 2) = mass_air_ini
       mass_C(6*(i-1) + 3) = mass_res_ini
       mass_C(6*(i-1) + 4) = mass_fuel_ini
       mass_C(6*(i-1) + 5) = mass_air_ini
       mass_C(6*(i-1) + 6) = mass_res_ini
    end do

    if(globalData%use_global_gas_prop) then
       cyl(icyl)%gas_properties%R_gas = globalData%R_gas
       cyl(icyl)%gas_properties%gamma = globalData%ga
       cyl(icyl)%gas_properties%cp    = &
            globalData%ga/(globalData%ga-1.0d0)*globalData%R_gas
       cyl(icyl)%gas_properties%cv = cyl(icyl)%gas_properties%cp - &
            cyl(icyl)%gas_properties%R_gas
       do i=1,11
          cyl(icyl)%gas_properties%composition(i) = 0.0d0
       end do
       cyl(icyl)%gas_properties%composition(3) = 0.79d0
       cyl(icyl)%gas_properties%composition(4) = 0.21d0
    else
       call compute_composition(0,cyl(icyl)%combustion_data%phi, &
            cyl(icyl)%fuel_data%alpha, cyl(icyl)%fuel_data%beta, &
            cyl(icyl)%fuel_data%gamma, cyl(icyl)%fuel_data%delta, &
            mass_fuel_ini,mass_air_ini,mass_res_ini, &
            cyl(icyl)%gas_properties%composition)
       cyl(icyl)%gas_properties%R_gas = &
            compute_Rgas(cyl(icyl)%gas_properties%composition(1:10), &
            cyl(icyl)%gas_properties%composition(11),cyl(icyl)%fuel_data%Mw)
       cyl(icyl)%gas_properties%cp = compute_cp_mix(temp, &
            cyl(icyl)%gas_properties%R_gas, &
            cyl(icyl)%gas_properties%composition(1:10), &
            cyl(icyl)%gas_properties%composition(11), &
            cyl(icyl)%fuel_data%coef_cp)
       cyl(icyl)%gas_properties%cv = cyl(icyl)%gas_properties%cp - &
            cyl(icyl)%gas_properties%R_gas
       cyl(icyl)%gas_properties%gamma = cyl(icyl)%gas_properties%cp / &
            cyl(icyl)%gas_properties%cv
    end if

    cyl(icyl)%mean_exhaust_gamma = (/0., 0./)

    do ival=1,cyl(icyl)%nvi
       do idof=1,myData%ndof
          cyl(icyl)%intake_valves(ival)%state(idof) = atm_state(idof)
          cyl(icyl)%intake_valves(ival)%state_old(idof) = atm_state(idof)
          cyl(icyl)%intake_valves(ival)%state_pipe_old(idof) = atm_state(idof)
       end do
    end do

    do ival=1,cyl(icyl)%nve
       do idof=1,myData%ndof
          cyl(icyl)%exhaust_valves(ival)%state(idof) = atm_state(idof)
          cyl(icyl)%exhaust_valves(ival)%state_old(idof) = atm_state(idof)
          cyl(icyl)%exhaust_valves(ival)%state_pipe_old(idof) = atm_state(idof)
       end do
    end do

    ! Initialize state_multizone vector to store unburnt gas state during combustion
    cyl(icyl)%state_multizone(1) = -1
    cyl(icyl)%state_multizone(2) = -1
    cyl(icyl)%state_multizone(3) = -1
  end subroutine state_initial_cylinder

  subroutine correct_gamma_exhaust(ga_exhaust) BIND(C)
    !
    !
    !
    use, intrinsic :: ISO_C_BINDING

    implicit none

    real(C_DOUBLE) :: ga_exhaust

    integer :: k,ncyl
    real*8 :: ga

    ga = 0.0d0
    ncyl = 0
    if(size(cyl).gt.0) then
       do k=1,size(cyl)
          if(cyl(k)%mean_exhaust_gamma(1).gt.0.0d0) then
             ga = ga+cyl(k)%mean_exhaust_gamma(1)
             ncyl = ncyl+1
          end if
       end do
       if(ncyl.gt.0) ga_exhaust = ga/ncyl
    end if

  end subroutine correct_gamma_exhaust

  subroutine solve_cylinder(icyl, myData, globalData, state, new_state, mass_C, twall) BIND(C)
    !
    !
    !  solve_cylinder is called by:
    !  solve_cylinder calls the following subroutines and functions:
    !    area_valve, solve_valve, cylinder_solver
    !
    use, intrinsic :: ISO_C_BINDING
    type(this) :: myData
    type(dataSim) :: globalData
    real(C_DOUBLE) :: state(0:((myData%nnod+myData%nnod_input)*myData%ndof)-1)
    real(C_DOUBLE) :: new_state(0:(myData%nnod*myData%ndof)-1)
    real(C_DOUBLE) :: mass_C(6*(myData%nnod - myData%nvi - myData%nve ) )
    integer(C_INT) :: icyl
    integer :: nnod_cyl,Nval,type_dat,i,j,ival
    real*8 :: theta_g,theta,theta_cycle,R_gas
    real*8 :: ga,dx,Area_P,dAreax_P,Twall_P
    real*8 :: Dv,Lvmax,IVO,IVC,EVO,EVC,Area_T,tol_Area
    real*8 :: EGR,alpha
    real*8, dimension(myData%ndof) :: Upipe,Uthroat,RHS
    real*8, dimension(cyl(icyl)%nvi) :: Fiv
    real*8, dimension(cyl(icyl)%nve) :: Fev
    real*8, dimension(3,myData%nnod-myData%nvi-myData%nve) :: mass_cyl,mass_cyl_old
    real*8, dimension(myData%ndof,myData%nnod-myData%nvi-myData%nve) :: Ucyl
    real*8, dimension(myData%ndof,cyl(icyl)%nvi) :: Uriv,Uiv,Utiv,RHSiv
    real*8, dimension(myData%ndof,cyl(icyl)%nve) :: Urev,Uev,Utev,RHSev
    ! This declarations are due to the multivalve model
    real*8, dimension(2) :: AreaT_MV
    real*8, dimension(myData%ndof,2) :: Uthroat_MV,Uref
    real*8, dimension(myData%ndof,2*(myData%nnod-myData%nvi-myData%nve)) :: Ucyl_MV
    real*8, dimension(myData%ndof,myData%nnod-myData%nvi-myData%nve) :: &
         Ucyl_leading, Ucyl_trailing
    integer :: leading_cyl, trailing_cyl, solved_case
    real*8 :: theta_leading,theta_trailing,AreaT_leading,AreaT_trailing
	real*8:: t_wall(mydata%ntemp)
	real(C_DOUBLE) :: twall(0:mydata%ntemp-1)


    logical :: flag

	  do i=1,mydata%ntemp
	    t_wall(i) = twall(i-1)
	  end do


    tol_Area = 1d-6

    theta_g     = globalData%theta
    theta_cycle = globalData%theta_cycle

    flag = .false.
    if(theta_g .gt. 0*pi/180.) flag = .true.

    theta = modulo(theta_g+myData%theta_0, theta_cycle)

    nnod_cyl = myData%nnod-cyl(icyl)%nvi-cyl(icyl)%nve

    EGR = 0.0d0

    leading_cyl  = icyl
    trailing_cyl = icyl
    theta_leading  = theta
    theta_trailing = theta
    AreaT_leading  = 0.0d0
    AreaT_trailing = 0.0d0

    if(globalData%save_extras) then
       write(myData%nunit,901) globalData%icycle, theta*180/pi, globalData%time
       901    format (I12,F12.4,F15.10)
    endif

    ! Get the cylinder state(s) from state vector
    do i=0,nnod_cyl-1
       do j=0,myData%ndof-1
          Ucyl(j+1,i+1) = state(i*myData%ndof+j)
       enddo
    enddo

    ! Get the intake valves state(s) from state vector
    do i=nnod_cyl,nnod_cyl+myData%nvi-1
       do j=0,myData%ndof-1
          Uiv(j+1,i-nnod_cyl+1) = state(i*myData%ndof+j)
       enddo
    enddo
    ! Get the exhaust valves state(s) from state vector
    do i=nnod_cyl+myData%nvi,nnod_cyl+myData%nvi+myData%nve-1
       do j=0,myData%ndof-1
          Uev(j+1,i-nnod_cyl-myData%nvi+1) = state(i*myData%ndof+j)
       enddo
    enddo
    ! Get the intake valves reference state(s) from state vector
    do i=myData%nnod,myData%nnod+myData%nvi-1
       do j=0,myData%ndof-1
          Uriv(j+1,i-myData%nnod+1) = state(i*myData%ndof+j)
       enddo
    enddo
    ! Get the exhaust valves reference state(s) from state vector
    do i=myData%nnod+myData%nvi,myData%nnod+myData%nvi+myData%nve-1
       do j=0,myData%ndof-1
          Urev(j+1,i-myData%nnod-myData%nvi+1) = state(i*myData%ndof+j)
       enddo
    enddo

    if(globalData%engine_type==2) then
       ! Get the 'leading' and 'trailing' cylinder state(s) from state vector
       ! For MRCVC engine type
       do i=myData%nnod+myData%nvi+myData%nve, &
            myData%nnod+myData%nvi+myData%nve+nnod_cyl-1
          do j=0,myData%ndof-1
             Ucyl_leading(j+1,i-myData%nnod-myData%nvi-myData%nve+1) = &
                  state(i*myData%ndof+j)
          enddo
       enddo
       do i=myData%nnod+myData%nvi+myData%nve+nnod_cyl, &
            myData%nnod+myData%nvi+myData%nve+2*nnod_cyl-1
          do j=0,myData%ndof-1
             Ucyl_trailing(j+1,i-myData%nnod-myData%nvi-myData%nve-nnod_cyl+1) = &
                  state(i*myData%ndof+j)
          enddo
       enddo

       leading_cyl  = mod(mod(icyl-1,globalData%ncyl)+globalData%ncyl, &
            globalData%ncyl)
       trailing_cyl = mod(mod(icyl+1,globalData%ncyl)+globalData%ncyl, &
            globalData%ncyl)
       if(leading_cyl.eq.0) leading_cyl = globalData%ncyl
       if(trailing_cyl.eq.0) trailing_cyl = globalData%ncyl
    end if

    do i=1,nnod_cyl
       do j=1,3
          mass_cyl(j,i)     = mass_C(6*(i-1)+j)
          mass_cyl_old(j,i) = mass_C(6*(i-1)+j+3)
       end do
    end do

    ! Intake valves
    do ival=1,cyl(icyl)%nvi
       dx       = cyl(icyl)%intake_valves(ival)%dx_tube
       Area_P   = cyl(icyl)%intake_valves(ival)%Area_tube
       dAreax_P = cyl(icyl)%intake_valves(ival)%dAreax_tube
       Twall_P  = cyl(icyl)%intake_valves(ival)%twall_tube

       Dv       = cyl(icyl)%intake_valves(ival)%Dv
       Lvmax    = cyl(icyl)%intake_valves(ival)%Lvmax
       IVO      = cyl(icyl)%intake_valves(ival)%angle_VO
       IVC      = cyl(icyl)%intake_valves(ival)%angle_VC
       Nval     = cyl(icyl)%intake_valves(ival)%Nval
       type_dat = cyl(icyl)%intake_valves(ival)%type_dat
       call area_valve(theta, Dv, IVO, IVC, Lvmax, Nval, type_dat, &
            cyl(icyl)%intake_valves(ival)%Lv, cyl(icyl)%intake_valves(ival)%Cd, &
            theta_cycle, Area_T)
       Fiv(ival) = Area_T
       cyl(icyl)%intake_valves(ival)%dArea = Area_T-cyl(icyl)%intake_valves(ival)%Area
       cyl(icyl)%intake_valves(ival)%Area  = Area_T

       if(globalData%engine_type==2) then
          if(leading_cyl.lt.icyl) then
             AreaT_leading = cyl(leading_cyl)%intake_valves(ival)%Area
          else
             theta_leading = modulo(theta+theta_cycle/(myData%nvanes+2.),theta_cycle)
             call area_valve(theta_leading, Dv, IVO, IVC, Lvmax, Nval, &
                  type_dat, cyl(leading_cyl)%intake_valves(ival)%Lv, &
                  cyl(leading_cyl)%intake_valves(ival)%Cd, &
                  theta_cycle, AreaT_leading)
          end if
          if(trailing_cyl.lt.icyl) then
             AreaT_trailing = cyl(trailing_cyl)%intake_valves(ival)%Area
          else
             theta_trailing = modulo(theta-theta_cycle/(myData%nvanes+2.),theta_cycle)
             call area_valve(theta_trailing, Dv, IVO, IVC, Lvmax, Nval, &
                  type_dat, cyl(trailing_cyl)%intake_valves(ival)%Lv, &
                  cyl(trailing_cyl)%intake_valves(ival)%Cd, &
                  theta_cycle, AreaT_trailing)
          end if
       end if

       ga    = globalData%ga_intake
       R_gas = globalData%R_gas

       if(cyl(icyl)%intake_valves(ival)%valve_model.eq.1 .or. myData%full_implicit) then
          call rhschar(Uriv(:,ival), Area_P, dAreax_P, Twall_P, ga, R_gas, &
               globalData%dt, globalData%viscous_flow, globalData%heat_flow, RHS, 0.0d0, 0.0d0, 0.0d0, 0.0d0)
          RHSiv(:,ival) = RHS
       end if

       cyl(icyl)%intake_valves(ival)%mass_flow_factor = 1.0d0

       if(myData%full_implicit) then
          ! call rhschar(Uriv(:,ival), Area_P, dAreax_P, Twall_P, ga, R_gas, &
          !      globalData%dt, globalData%viscous_flow, globalData%heat_flow, RHS)
          ! RHSiv(:,ival) = RHS
       else
          alpha = 1.
          select case (cyl(icyl)%intake_valves(ival)%valve_model)
          case(0)
             call solve_valve(Ucyl, Uriv(:,ival), 1, Area_T, Area_P, &
                  ga, R_gas, Upipe, Uthroat)
             if(Area_T.gt.0.) alpha = 0.15
             if(globalData%engine_type==2) &
                  stop ' Multivalve solved with valve model 0 - Not implemented '
          case (1)
             if(any(isnan(cyl(icyl)%intake_valves(ival)%state_ref))) then
                write(*,*) 'INTAKE - ', &
                     cyl(icyl)%intake_valves(ival)%state_ref
                stop
             end if
             Upipe = Uiv(:,ival)
             if(globalData%engine_type==2 .and. &
                  cyl(icyl)%intake_valves(ival)%Area.gt.tol_Area .and. &
                  (AreaT_leading.gt.tol_Area .or. AreaT_trailing.gt.tol_Area)) then
                ! Multivalve
                Ucyl_MV(:,1) = Ucyl(:,1)
                AreaT_MV(1) = Area_T
                if(AreaT_leading.gt.tol_Area) then
                   Ucyl_MV(:,2) = Ucyl_leading(:,1)
                   AreaT_MV(2) = AreaT_leading
                else
                   Ucyl_MV(:,2) = Ucyl_trailing(:,1)
                   AreaT_MV(2) = AreaT_trailing
                end if
                solved_case = cyl(icyl)%intake_valves(ival)%solved_case
                Uref = cyl(icyl)%intake_valves(ival)%state_ref
                call solve_multivalve(Ucyl_MV, Uref, 1, AreaT_MV, Area_P, &
                     RHSiv(:,ival), ga, Upipe, Uthroat_MV, solved_case, .false.)
                Uthroat = Uthroat_MV(:,1)
                cyl(icyl)%intake_valves(ival)%solved_case = solved_case

                if(cyl(icyl)%intake_valves(ival)%solved_case.ne.0) then
                   if(Uthroat_MV(2,1).gt.0. .and. Uthroat_MV(2,2).gt.0.) &
                        cyl(icyl)%intake_valves(ival)%mass_flow_factor = &
                        Uthroat_MV(1,1)*Uthroat_MV(2,1)*AreaT_MV(1)/ &
                        Upipe(1)/Upipe(2)/Area_P
                else
                   cyl(icyl)%intake_valves(ival)%solved_case = 0
                    Uthroat = 2.*cyl(icyl)%intake_valves(ival)%state- &
                        cyl(icyl)%intake_valves(ival)%state_old
                   Upipe = 2.*Uiv(:,ival)- &
                        cyl(icyl)%intake_valves(ival)%state_pipe_old
                   solved_case = 0
                end if
             else
                cyl(icyl)%intake_valves(ival)%solved_case = 0
                Uthroat = cyl(icyl)%intake_valves(ival)%state

                Uref = cyl(icyl)%intake_valves(ival)%state_ref

                call solve_valve_implicit(Ucyl, Uref, 1, Area_T, Area_P, &
                     RHSiv(:,ival), ga, Upipe, Uthroat, solved_case)

                if(solved_case.eq.0 .and. Area_T/Area_P.gt.1d-6) &
                     call solve_valve(Ucyl, Uriv(:,ival), 1, &
                     Area_T, Area_P, ga, R_gas, Upipe, Uthroat)

                if(any(isnan(Uthroat))) then
                   Uthroat = 2.*cyl(icyl)%intake_valves(ival)%state- &
                        cyl(icyl)%intake_valves(ival)%state_old
                   Upipe = 2.*Uiv(:,ival)- &
                        cyl(icyl)%intake_valves(ival)%state_pipe_old
                end if
             end if
          case default
             stop ' Wrong valve model option '
          end select

          cyl(icyl)%intake_valves(ival)%state_pipe_old = Uiv(:,ival)

          alpha = 1.0
          Uiv(:,ival)  = alpha*Upipe + &
               (1.-alpha)*Uiv(:,ival)
          Utiv(:,ival) = alpha*Uthroat + &
               (1.-alpha)*cyl(icyl)%intake_valves(ival)%state

          cyl(icyl)%intake_valves(ival)%state_old = &
               cyl(icyl)%intake_valves(ival)%state
          cyl(icyl)%intake_valves(ival)%state = Utiv(:,ival)

          if(any(isnan(Utiv(:,ival)))) stop 'NAN in intake valve'

          if(cyl(icyl)%intake_valves(ival)%mass_res_port.gt.0. .and. &
               Area_T.eq.0.) &
               cyl(icyl)%intake_valves(ival)%mass_res_port = 0.0d0

       end if
    end do

    ! Exhaust valves
    do ival=1,cyl(icyl)%nve
       dx       = cyl(icyl)%exhaust_valves(ival)%dx_tube
       Area_P   = cyl(icyl)%exhaust_valves(ival)%Area_tube
       dAreax_P = cyl(icyl)%exhaust_valves(ival)%dAreax_tube
       Twall_P  = cyl(icyl)%exhaust_valves(ival)%twall_tube

       Dv       = cyl(icyl)%exhaust_valves(ival)%Dv
       Lvmax    = cyl(icyl)%exhaust_valves(ival)%Lvmax
       EVO      = cyl(icyl)%exhaust_valves(ival)%angle_VO
       EVC      = cyl(icyl)%exhaust_valves(ival)%angle_VC
       Nval     = cyl(icyl)%exhaust_valves(ival)%Nval
       type_dat = cyl(icyl)%exhaust_valves(ival)%type_dat
       call area_valve(theta, Dv, EVO, EVC, Lvmax, Nval, type_dat, &
            cyl(icyl)%exhaust_valves(ival)%Lv, cyl(icyl)%exhaust_valves(ival)%Cd, &
            theta_cycle, Area_T)
       Fev(ival) = Area_T
       cyl(icyl)%exhaust_valves(ival)%dArea = Area_T-cyl(icyl)%exhaust_valves(ival)%Area
       cyl(icyl)%exhaust_valves(ival)%Area  = Area_T

       if(Area_T.gt.0.0d0) then
          cyl(icyl)%mean_exhaust_gamma(1) = &
               (cyl(icyl)%mean_exhaust_gamma(1)* &
               cyl(icyl)%mean_exhaust_gamma(2)+ &
               cyl(icyl)%gas_properties%gamma)/ &
               (cyl(icyl)%mean_exhaust_gamma(2)+1)
          cyl(icyl)%mean_exhaust_gamma(2) = cyl(icyl)%mean_exhaust_gamma(2)+1
       end if

       if(globalData%engine_type==2) then
          if(leading_cyl.lt.icyl) then
             AreaT_leading = cyl(leading_cyl)%exhaust_valves(ival)%Area
          else
             theta_leading = modulo(theta+theta_cycle/(myData%nvanes+2.),theta_cycle)
             call area_valve(theta_leading, Dv, EVO, EVC, Lvmax, Nval, &
                  type_dat, cyl(leading_cyl)%exhaust_valves(ival)%Lv, &
                  cyl(leading_cyl)%exhaust_valves(ival)%Cd, &
                  theta_cycle, AreaT_leading)
          end if
          if(trailing_cyl.lt.icyl) then
             AreaT_trailing = cyl(trailing_cyl)%exhaust_valves(ival)%Area
          else
             theta_trailing = modulo(theta-theta_cycle/(myData%nvanes+2.),theta_cycle)
             call area_valve(theta_trailing, Dv, EVO, EVC, Lvmax, Nval, &
                  type_dat, cyl(trailing_cyl)%exhaust_valves(ival)%Lv, &
                  cyl(trailing_cyl)%exhaust_valves(ival)%Cd, &
                  theta_cycle, AreaT_trailing)
          end if
       end if

       ga    = cyl(icyl)%gas_properties%gamma
       ! ga    = globalData%ga_exhaust
       R_gas = cyl(icyl)%gas_properties%R_gas

       if(cyl(icyl)%exhaust_valves(ival)%valve_model.eq.1 .or. myData%full_implicit) then
          call rhschar(Urev(:,ival), Area_P, dAreax_P, Twall_P, ga, R_gas, &
               globalData%dt, globalData%viscous_flow, globalData%heat_flow, RHS, 0.0d0, 0.0d0, 0.0d0, 0.0d0)
          RHSev(:,ival) = RHS
       end if

       if(myData%full_implicit) then
          ! call rhschar(Urev(:,ival), Area_P, dAreax_P, Twall_P, ga, R_gas, &
          !      globalData%dt, globalData%viscous_flow, globalData%heat_flow, RHS)
          ! RHSev(:,ival) = RHS
       else
          alpha = 1.
          select case (cyl(icyl)%exhaust_valves(ival)%valve_model)
          case (0)
             call solve_valve(Ucyl, Urev(:,ival), -1, Area_T, Area_P, &
                  ga, R_gas, Upipe, Uthroat)
             if(Area_T.gt.0.) alpha = 0.15
             if(globalData%engine_type==2) &
                  stop ' Multivalve solved with valve model 0 - Not implemented '
          case (1)
             if(any(isnan(cyl(icyl)%exhaust_valves(ival)%state_ref))) then
                write(*,*) 'EXHAUST - ', &
                     cyl(icyl)%exhaust_valves(ival)%state_ref
                stop
             end if
             Upipe   = Uev(:,ival)
             if(globalData%engine_type==2 .and. &
                  cyl(icyl)%exhaust_valves(ival)%Area.gt.tol_Area .and. &
                  (AreaT_leading.gt.tol_Area .or. AreaT_trailing.gt.tol_Area)) then

                ! Multivalve
                Ucyl_MV(:,1) = Ucyl(:,1)
                AreaT_MV(1) = Area_T
                if(AreaT_leading.gt.tol_Area) then
                   Ucyl_MV(:,2) = Ucyl_leading(:,1)
                   AreaT_MV(2) = AreaT_leading
                else
                   Ucyl_MV(:,2) = Ucyl_trailing(:,1)
                   AreaT_MV(2) = AreaT_trailing
                end if
                solved_case = cyl(icyl)%exhaust_valves(ival)%solved_case
                Uref = cyl(icyl)%exhaust_valves(ival)%state_ref
                call solve_multivalve(Ucyl_MV, Uref, -1, AreaT_MV, Area_P, &
                     RHSev(:,ival), ga, Upipe, Uthroat_MV, solved_case, .false.)
                Uthroat = Uthroat_MV(:,1)
                cyl(icyl)%exhaust_valves(ival)%solved_case = solved_case

                if(cyl(icyl)%exhaust_valves(ival)%solved_case.eq.0) then
                   cyl(icyl)%exhaust_valves(ival)%solved_case = 0
                   Uthroat = 2.*cyl(icyl)%exhaust_valves(ival)%state- &
                        cyl(icyl)%exhaust_valves(ival)%state_old
                   Upipe = 2.*Uev(:,ival)- &
                        cyl(icyl)%exhaust_valves(ival)%state_pipe_old
                   solved_case = 0
                end if

                if(any(isnan(Uthroat_MV))) stop 'NAN in exhaust multi-valve'
             else
                cyl(icyl)%exhaust_valves(ival)%solved_case = 0
                Uthroat = cyl(icyl)%exhaust_valves(ival)%state

                Uref = cyl(icyl)%exhaust_valves(ival)%state_ref

                call solve_valve_implicit(Ucyl, Uref, -1, Area_T, Area_P, &
                     RHSev(:,ival), ga, Upipe, Uthroat, solved_case)

                if(solved_case.eq.0 .and. Area_T/Area_P.gt.1d-6) then
                   Uthroat = 2.*cyl(icyl)%exhaust_valves(ival)%state- &
                        cyl(icyl)%exhaust_valves(ival)%state_old
                   Upipe = 2.*Uev(:,ival)- &
                        cyl(icyl)%exhaust_valves(ival)%state_pipe_old
                end if

                if(any(isnan(Uthroat))) then ! stop 'NAN in exhaust valve'
                   Uthroat = 2.*cyl(icyl)%exhaust_valves(ival)%state- &
                        cyl(icyl)%exhaust_valves(ival)%state_old
                   Upipe = 2.*Uev(:,ival)- &
                        cyl(icyl)%exhaust_valves(ival)%state_pipe_old
                end if
             end if
          case default
             stop ' Wrong valve model option '
          end select

          cyl(icyl)%exhaust_valves(ival)%state_pipe_old = Uev(:,ival)

          alpha = 1.0
          Uev(:,ival)  = alpha*Upipe + &
               (1.-alpha)*Uev(:,ival)
          Utev(:,ival) = alpha*Uthroat + &
               (1.-alpha)*cyl(icyl)%exhaust_valves(ival)%state

          cyl(icyl)%exhaust_valves(ival)%state_old = &
               cyl(icyl)%exhaust_valves(ival)%state
          cyl(icyl)%exhaust_valves(ival)%state = Utev(:,ival)
       end if
    end do

    if(myData%full_implicit) then
       ! Solves the cylinder and the valves in a monolythic system
       stop ' NOT IMPLEMENTED '
    else
       ! Solves the cylinder
       if (globalData%nzones.eq.1) then
        call cylinder_solver(icyl, myData, globalData, Ucyl, Utiv, Utev, &
            Uiv, Uev, Fiv, Fev, EGR, mass_cyl_old, mass_cyl, t_wall)
       elseif (globalData%nzones.eq.2) then
        call cylinder_solver_multizone(icyl, myData, globalData, Ucyl, Utiv, Utev, &
            Uiv, Uev, Fiv, Fev, EGR, mass_cyl_old, mass_cyl, t_wall)
       end if
    end if

    ! Actualizes the cylinder state(s)
    do i=0,nnod_cyl-1
       do j=0,myData%ndof-1
          new_state(i*myData%ndof+j) = Ucyl(j+1,i+1)
       enddo
    enddo

    ! Actualizes the intake valve state(s)
    do i=nnod_cyl,nnod_cyl+myData%nvi-1
       do j=0,myData%ndof-1
          new_state(i*myData%ndof+j) = Uiv(j+1,i-nnod_cyl+1)
       enddo
    enddo

    ! Actualizes the exhaust valve state(s)
    do i=nnod_cyl+myData%nvi,nnod_cyl+myData%nvi+myData%nve-1
       do j=0,myData%ndof-1
          new_state(i*myData%ndof+j) = Uev(j+1,i-nnod_cyl-myData%nvi+1)
       enddo
    enddo

    do i=1,nnod_cyl
       do j=1,3
          mass_C(6*(i-1)+j)   = mass_cyl(j,i)
          mass_C(6*(i-1)+j+3) = mass_cyl(j,i)
       end do
    end do

  end subroutine solve_cylinder

  subroutine geometry(myData, globalData, Vol, Area, Vdot)
    !
    !  Computes the surface chamber area, the volume and
    !    the volume time derivative
    !
    !  geometry is called by: state_initial_cylinder, ignition_delay,
    !    cylinder_solver
    !  geometry calls the following subroutines and functions:
    !    geometry_alternative, geometry_mrcvc
    !
    implicit none

    type(this), intent(in) :: myData
    type(dataSim), intent(in) :: globalData
    real*8, intent(out) :: Vol,Area,Vdot

    if(globalData%engine_type==0.or.globalData%engine_type==1) then
       call geometry_alternative(myData, globalData, Vol, Area, Vdot)
    elseif(globalData%engine_type==2) then
       call geometry_mrcvc(myData, globalData, Vol, Area, Vdot)
    end if

  end subroutine geometry

  subroutine geometry_alternative(myData, globalData, Vol, Area, Vdot)
    !
    !  Computes the surface chamber area, the volume and
    !    the volume time derivative for the alternative engine
    !
    !  geometry_alternative is called by: geometry
    !  geometry_alternative calls the following subroutines and
    !    functions: none
    !
    implicit none

    type(this), intent(in) :: myData
    type(dataSim), intent(in) :: globalData
    real*8, intent(out) :: Vol,Area,Vdot

    real*8 :: theta_cycle,beta,rpm,theta_g,theta
    real*8 :: Vc,Bo,l,a,Ach,Ap,s1,sdot1,s2,sdot2

    theta_cycle = globalData%theta_cycle
    rpm         = globalData%rpm
    theta_g     = globalData%theta

    theta = modulo(theta_g+myData%theta_0, theta_cycle)

    ! Alternative engine geometry
    Vc  = myData%Vol_clearance     ! clearance volume
    Bo  = myData%Bore              ! Bore
    l   = myData%rod_length        ! connecting road length
    a   = myData%crank_radius      ! cranck radius
    Ach = myData%head_chamber_area ! cylinder head surface area
    Ap  = myData%piston_area       ! piston crown surface Area

    ! Computing the stroke (distance between the cranck axis and piston pin axis)
    s1 = a*dcos(theta)+dsqrt(l**2-a**2*dsin(theta)**2)

    sdot1 = -(a*dsin(theta)+a**2*dsin(2.0*theta)/2./ &
         dsqrt(l**2-a**2*dsin(theta)**2))
    if(globalData%engine_type.eq.1) then
       beta = myData%delta_ca
       s2 = a*dcos(theta-beta)+dsqrt(l**2-a**2*dsin(theta-beta)**2)
       sdot2 = -(a*dsin(theta-beta)+a**2*dsin(2.0*(theta-beta))/2./ &
            dsqrt(l**2-a**2*dsin(theta-beta)**2))
       Vol  = Vc + pi*Bo**2/4.0*(2.0*(l+a)-(s1+s2))
       Area = Ach + 2.0*Ap + pi*Bo*(2.0*(l+a)-(s1+s2))
       Vdot = -rpm*2.0*pi/60.0*pi*Bo**2/4.0*(sdot1+sdot2)
    else
       !  Computing the engine volume
       Vol  = Vc + pi*Bo**2/4*(l+a-s1)
       !  Computing the engine area
       Area = Ach + Ap + pi*Bo*(l+a-s1)
       !  Computing the volume rate (dV/dt)
       Vdot = -rpm*2*pi/60*pi*Bo**2/4*sdot1
    end if

  end subroutine geometry_alternative

  subroutine geometry_multizone(Al,Aw,icyl,V,L)
    !
    ! Computes Flame area and wetted wall area (multizone model).
    ! Needs piston position (L) and burnt gas volume (V) as input, where L is 
    ! the distance from piston to TDC.
    ! 
    ! geometry_multizone is called by: solve_cylinder_multizone
    ! geometry_multizone calls the folowing subroutines and fuctions: None
    !
    implicit none
    real*8, intent(in) :: V,L
    integer, intent(in) :: icyl
    type(geometry_type) :: geo
    real*8, intent(out) :: Aw,Al
    integer :: i,j
    real*8 :: Aw1,Aw2,Aw3,Aw4,Al1,Al2,Al3,Al4,x,y,V_step,l_step

    ! Get geometry data of the cylinder
    geo = cyl(icyl)%geometry_data

    ! Initializate output variables to non-sense values to detect errors.
    Aw = -1
    Al = -1

    ! Calculate volume step and piston position step
    V_step = geo%V_max/geo%V_num
    l_step = geo%l_max/geo%l_num

    ! Get indexes corresponding to current state of cylinder position and burnt gas volume
    i=FLOOR(V/V_step)+1
    j=FLOOR(L/l_step)+1

    ! Check indexes
    if ((V.gt.geo%V_max).or.(V.lt.0)) then
        write(*,*) "ERROR: input V is greater than V_max or is negative. V: ", V, " , V_max: ", geo%V_max
        stop
    end if
    if ((l.gt.geo%l_max).or.(l.lt.0)) then
        write(*,*) "ERROR: input l is greater than l_max or is negative. l: ", l, " , l_max: ", geo%l_max
        stop
    end if

    x = V/V_step+1
    y = L/l_step+1
    
    ! Perform bilinear interpolation to estimate output variables.
    Aw1 = (i+1-x)*(j+1-y)*geo%Aw(i,j)
    Aw2 = (x-i)*(j+1-y)*geo%Aw(i+1,j)
    Aw3 = (i+1-x)*(y-j)*geo%Aw(i,j+1)
    Aw4 = (x-i)*(y-j)*geo%Aw(i+1,j+1)
    Al1 = (i+1-x)*(j+1-y)*geo%Al(i,j)
    Al2 = (x-i)*(j+1-y)*geo%Al(i+1,j)
    Al3 = (i+1-x)*(y-j)*geo%Al(i,j+1)
    Al4 = (x-i)*(y-j)*geo%Al(i+1,j+1)

    Aw = (Aw1+Aw2+Aw3+Aw4)
    Al = (Al1+Al2+Al3+Al4)
  end subroutine

  subroutine heat_transfer(myData, globalData, Ucyl, &
       Area, cp, dQ_ht, t_wall)
    !
    !  Computes the heat losses in the cylinder or chamber
    !
    !  heat_transfer is called by: cylinder_solver
    !  heat_transfer calls the following subroutines and functions:
    !    heat_transfer_alternative, heat_transfer_mrcvc
    !
    implicit none

    real*8, intent(in) :: Area,cp
    real*8, dimension(3), intent(in) :: Ucyl
    type(this), intent(in) :: myData
    type(dataSim), intent(in) :: globalData
    real*8, intent(out) :: dQ_ht
	  real*8,dimension(myData%ntemp) :: t_wall

    if(globalData%engine_type==0.or.globalData%engine_type==1) then
       call heat_transfer_alternative(myData, globalData, Ucyl, &
            Area, cp, dQ_ht, t_wall)
    elseif(globalData%engine_type==2) then
       call heat_transfer_mrcvc(myData, globalData, Ucyl, &
            Area, cp, dQ_ht)
    end if

  end subroutine heat_transfer

  subroutine heat_transfer_alternative(myData, globalData, Ucyl, &
       Area, cp, dQ_ht, t_wall)

    !
    !  Computes the heat losses in the cylinder for alternative
    !    engines
    !
    !  model = 1 -> Annand model
    !  model = 2 -> Woschni model 1
    !  model = 3 -> Woschni model 2
    !  model = 4 -> Taylor
    !
    !  heat_transfer_alternative is called by: heat_transfer
    !  heat_transfer_alternative calls the following subroutines
    !    and functions: compute_cp, compute_visco,
    !    average_piston_speed
    !
    implicit none

    real*8, intent(in) :: Area,cp
    real*8, dimension(3), intent(in) :: Ucyl
    type(this), intent(in) :: myData
    type(dataSim), intent(in) :: globalData
    real*8, intent(out) :: dQ_ht

    integer :: ispecie,i,m
    real*8 :: Bo,l,a,rho,p,T,twall,Ach,Ap,Area_n,A_restante
    real*8 :: mu,Pr,kappa,Sp,Re,Nu
    real*8 :: factor,C_h,dQ_hth,dQ_htr,C_r_medio
	  real*8, dimension(myData%ntemp) :: C_r,t_wall
    logical :: exist

    Bo    = myData%Bore         ! bore
    l     = myData%rod_length   ! connecting rod length
    a     = myData%crank_radius ! cranck radius
	  Ach = myData%head_chamber_area ! cylinder head surface area
    Ap  = myData%piston_area       ! piston crown surface Area
	  Area_n = pi*Bo*2*a/(myData%ntemp-2) ! section piston wall area
	  m = floor((Area-Ap-Ach)/Area_n) ! number of sections
	  A_restante = Area-Ach-Ap-m*Area_n ! remaining piston wall area

    rho = Ucyl(1)
    p   = Ucyl(2)
    T   = Ucyl(3)

    ! computing Cp for a given mixture (isp) at a given temperature
    ! ispecie = 0
    ! cp = compute_cp(T,ispecie,globalData%R_gas)

    mu    = compute_visco(T) ! dynamic viscosity
    Pr    = 0.72             ! Prandtl number
    kappa = mu*cp/Pr         ! thermal conductivity

    Sp = average_piston_speed(globalData%rpm, myData%crank_radius, &
         globalData%engine_type)
    Re = rho*dabs(Sp)*Bo/mu        ! Reynolds number

    ! Nusselt number
    ! According to Woschni but with a velocity different with respect
    ! to the piston speed in order to compute the Reynolds number,
    ! see Heywood pp. 678
    if(myData%model_ht.eq.1) then
       ! According to Annand (Heywood pp. 678)
       factor = myData%factor_ht * 0.49
       Nu     =  factor * Re**0.7
    elseif(myData%model_ht.eq.2) then
       ! factor is a constant times 0.035
       ! Some authors use a sensibility analysis in order to set this parameter.
       ! For instance, John Abraham uses in his code the value 4.5 times 0.035;
       ! Yacoub and Bata apply between 1 and 3 times this value in their
       ! '98 paper.
       factor = myData%factor_ht * 0.035
       Nu    = factor*Re**0.8*Pr**0.33
    elseif(myData%model_ht.eq.3) then
       factor = myData%factor_ht * 0.037
       Nu     = factor*Re**0.8*Pr**0.3
    else
       ! Taylor model
       factor = myData%factor_ht * 10.4
       Nu     = factor*Re**0.75
    endif

    ! Heat transfer coefficient
    C_h = Nu*kappa/Bo

	  dQ_hth=0
	  dQ_htr=0
	  C_r_medio=0

	  do i = 1,m+2
		  twall = t_wall(i)

		  if(myData%type_ig.eq.0) then
			  ! SI Engine
			  C_r(i) = 4.25d-9*((T**2+twall**2)*(T+twall))
		  elseif(myData%type_ig.eq.1) then
			  ! CI Engine
			  C_r(i) = 3.2602d-8*((T**2+twall**2)*(T+twall))
		  endif


		  !Cylinder head heat transfer
		  if (i.eq.1) then
		    C_r_medio=C_r_medio+C_r(i)*Ach
			  dQ_hth = dQ_hth + Ach * C_h * (T-twall)
			  dQ_htr = dQ_htr + Ach * C_r(i) * (T-twall)
		  !Piston crown heat transfer
		  else if (i.eq.2) then
		    C_r_medio=C_r_medio+C_r(i)*Ap
			  dQ_hth = dQ_hth + Ap * C_h * (T-twall)
			  dQ_htr = dQ_htr + Ap * C_r(i) * (T-twall)
		  !Cylinder wall heat transfer
		  else
		    C_r_medio=C_r_medio+C_r(i)*Area_n
			  dQ_hth = dQ_hth + Area_n * C_h * (T-twall)
			  dQ_htr = dQ_htr + Area_n * C_r(i) * (T-twall)
		  endif
	  end do

	  !Calculates heat transfer in the last cylinder wall section
	  if ((A_restante.ne.0).and.((m+2).lt.mydata%ntemp)) then
		  twall = t_wall(m+3)
		  if(myData%type_ig.eq.0) then
			  ! SI Engine
			  C_r(m+3) = 4.25d-9*((T**2+twall**2)*(T+twall))
		  elseif(myData%type_ig.eq.1) then
			  ! CI Engine
			  C_r(m+3) = 3.2602d-8*((T**2+twall**2)*(T+twall))
		  endif
		  C_r_medio=C_r_medio+C_r(m+3)*A_restante

		  dQ_hth = dQ_hth +  A_restante * C_h * (T-twall)
		  dQ_htr = dQ_htr + A_restante * C_r(m+3) * (T-twall)
	  end if

	  C_r_medio=C_r_medio/Area
	  dQ_ht =  dQ_hth + dQ_htr

	  !DEBUG (warning: assumes monocyl engine)
    if (globalData%debug.gt.1) then
        inquire(file="cyl_heat_debug.csv", exist=exist)
        if (exist) then
            open(11, file="cyl_heat_debug.csv", status="old", position="append", action="write")
        else
            open(11, file="cyl_heat_debug.csv", status="new", action="write")
        endif
        write(11,"(F20.3,A1,F10.5,A1,F10.5,A1,I4)") &
                dQ_ht, ";", C_r_medio, ";", globaldata%time,";", globalData%icycle
        close(11)
    end if

    if(globalData%save_extras) then
       write(myData%nunit,902) C_h, C_r_medio, dQ_hth, dQ_htr
    902    format (F12.6,F12.6,E15.6,E15.6)
    endif

  end subroutine heat_transfer_alternative
  
  subroutine heat_transfer_multizone(myData, globalData, rho, P, T, &
      Area, cp, dQ_ht, t_wall)

   !
   !  Computes the heat losses in the cylinder for alternative
   !    engines (multizone model)
   !
   !  model = 1 -> Annand model
   !  model = 2 -> Woschni model 1
   !  model = 3 -> Woschni model 2
   !  model = 4 -> Taylor
   !
   !  heat_transfer_multizone is called by: solve_cylinder_multizone
   !  heat_transfer_alternative calls the following subroutines
   !    and functions: compute_cp, compute_visco,
   !    average_piston_speed
   !
   implicit none

   real*8, intent(in) :: Area,cp,rho,p,T
   type(this), intent(in) :: myData
   type(dataSim), intent(in) :: globalData
   real*8, intent(out) :: dQ_ht

   real*8 :: Bo,twall
   real*8 :: mu,Pr,kappa,Sp,Re,Nu
   real*8 :: factor,C_h,dQ_hth,dQ_htr,C_r
   real*8, dimension(myData%ntemp) :: t_wall
   logical :: exist
  
   Bo  = myData%Bore
 
   ! As a first aproximation we use a mean wall temperature. We should implement the variable twall model.
   twall = sum(t_wall)/myData%ntemp

   mu    = compute_visco(T) ! dynamic viscosity
   Pr    = 0.72             ! Prandtl number
   kappa = mu*cp/Pr         ! thermal conductivity

   Sp = average_piston_speed(globalData%rpm, myData%crank_radius, &
        globalData%engine_type)
   Re = rho*dabs(Sp)*Bo/mu        ! Reynolds number

   ! Nusselt number
   ! According to Woschni but with a velocity different with respect
   ! to the piston speed in order to compute the Reynolds number,
   ! see Heywood pp. 678
   if(myData%model_ht.eq.1) then
      ! According to Annand (Heywood pp. 678)
      factor = myData%factor_ht * 0.49
      Nu     =  factor * Re**0.7
   elseif(myData%model_ht.eq.2) then
      ! factor is a constant times 0.035
      ! Some authors use a sensibility analysis in order to set this parameter.
      ! For instance, John Abraham uses in his code the value 4.5 times 0.035;
      ! Yacoub and Bata apply between 1 and 3 times this value in their
      ! '98 paper.
      factor = myData%factor_ht * 0.035
      Nu    = factor*Re**0.8*Pr**0.33
   elseif(myData%model_ht.eq.3) then
      factor = myData%factor_ht * 0.037
      Nu     = factor*Re**0.8*Pr**0.3
   else
      ! Taylor model
      factor = myData%factor_ht * 10.4
      Nu     = factor*Re**0.75
   endif

   ! Heat transfer coefficient
   C_h = Nu*kappa/Bo

    if(myData%type_ig.eq.0) then
      ! SI Engine
      C_r = 4.25d-9*((T**2+twall**2)*(T+twall))
    elseif(myData%type_ig.eq.1) then
      ! CI Engine
      C_r = 3.2602d-8*((T**2+twall**2)*(T+twall))
    endif

      dQ_hth = Area * C_h * (T-twall)
      dQ_htr = Area * C_r * (T-twall)
  
   dQ_ht =  dQ_hth + dQ_htr
   !DEBUG (warning: assumes monocyl engine)
   if (globalData%debug.gt.1) then
       inquire(file="cyl_heat_debug.csv", exist=exist)
       if (exist) then
           open(11, file="cyl_heat_debug.csv", status="old", position="append", action="write")
       else
           open(11, file="cyl_heat_debug.csv", status="new", action="write")
       endif
       write(11,"(F20.3,A1,F10.5,A1,F10.5,A1,I4)") &
               dQ_ht, ";", C_r, ";", globaldata%time,";", globalData%icycle
       close(11)
   end if

   if(globalData%save_extras) then
      write(myData%nunit,902) C_h, C_r, dQ_hth, dQ_htr
   902    format (F12.6,F12.6,E15.6,E15.6)
   endif

  end subroutine heat_transfer_multizone

  subroutine SI_combustion(icyl, theta, mass_fuel, omega, theta_cycle, &
    x_burned, xbdot, dQ_chem, dQ_ht_fuel, save_extras, nunit)
    !
    !  Computes the heat released by combustion for spark-ignition engines
    !    by a Wiebe function pp. 390 Heywood
    !
    !  SI_combustion is called by: heat_released
    !  SI_combustion calls the following subroutines and functions: none
    !
    implicit none

    integer, intent(in) :: icyl,nunit
    real*8, intent(in) :: theta,theta_cycle,mass_fuel,omega
    real*8, intent(out) :: x_burned,dQ_chem,dQ_ht_fuel,xbdot
    logical, intent(in) :: save_extras

    real*8 :: theta_ig,dtheta_comb,a_wiebe,m_wiebe,Q_fuel,hvap
    real*8 :: pot
    a_wiebe     = cyl(icyl)%combustion_data%a_wiebe
    m_wiebe     = cyl(icyl)%combustion_data%m_wiebe
    theta_ig    = cyl(icyl)%combustion_data%theta_ig_0
    dtheta_comb = cyl(icyl)%combustion_data%dtheta_comb

    Q_fuel = cyl(icyl)%fuel_data%Q_fuel
    hvap   = cyl(icyl)%fuel_data%hvap_fuel

    pot      = -a_wiebe*(modulo(theta-theta_ig,theta_cycle)/dtheta_comb)**(m_wiebe+1.)
    x_burned = 1.0d0 - dexp(pot)

    xbdot = dexp(pot)*a_wiebe*(m_wiebe+1.)* &
            (modulo(theta-theta_ig,theta_cycle)/dtheta_comb)**m_wiebe/dtheta_comb
    xbdot = omega * xbdot

    dQ_chem    = mass_fuel * Q_fuel * xbdot

    dQ_ht_fuel = mass_fuel * xbdot * hvap

    if(save_extras) then
       write(nunit,904) x_burned, xbdot
      904    format (F12.8,F12.6)
    endif

  end subroutine SI_combustion

  subroutine CI_combustion(icyl, theta, mass_fuel, omega, theta_cycle, &
       x_burned, dQ_chem, dQ_ht_fuel, save_extras, nunit)
    !
    !  Computes the heat released by combustion for compression-ignition engines
    !
    !    Model 0 -> 'user-defined'
    !    Model 1 -> 'Wiebe-2'
    !    Model 2 -> 'Wiebe-3'
    !    Model 3 -> 'Watson'
    !
    !  CI_combustion is called by: heat_released
    !  CI_combustion calls the following subroutines and functions: interpolant
    !
    implicit none

    integer, intent(in) :: icyl,nunit
    real*8, intent(in) :: theta,theta_cycle,mass_fuel,omega
    real*8, intent(out) :: x_burned,dQ_chem,dQ_ht_fuel
    logical :: save_extras
    integer :: k,indx
    real*8 :: a,mp,mdi,pot,pote,theta_ig,dtheta_p,dtheta_di
    real*8 :: x_p,x_di,factor,dtheta_comb,xbdot,Q_fuel,hvap
    real*8 :: Fp,Fm,Ft,Ep,Em,Et,Dp,Dm,Dt,WCp,WCm,WCt,pot_p,pot_m,pot_t
    real*8 :: theta_id,phi_ig,tau,beta,theta_deg,rpm
    real*8, dimension(2) :: coef,coefp

    theta_ig    = cyl(icyl)%combustion_data%theta_ig_0
    dtheta_comb = cyl(icyl)%combustion_data%dtheta_comb

    Q_fuel = cyl(icyl)%fuel_data%Q_fuel
    hvap   = cyl(icyl)%fuel_data%hvap_fuel

    if(cyl(icyl)%combustion_data%combustion_model.eq.1) then
       !  Two Wiebe's functions to model the premixed and diffussive
       !    stages in the CI combustion
       ! a       = 5.0
       a       = cyl(icyl)%combustion_data%a_wiebe
       mp      = 1.5
       mdi     = 1.05
       x_p     = 0.3
       !x_p     = 0.2
       !x_p     = 0.15
       x_di    = 1.-x_p
       factor  = 0.17857
       !factor  = 0.125

       dtheta_p  = factor*dtheta_comb
       dtheta_di = dtheta_comb-dtheta_p
       pot       = -a*(modulo(theta-theta_ig,theta_cycle)/dtheta_p)**(mp+1.)
       pote      = -a*(modulo(theta-theta_ig,theta_cycle)/dtheta_di)**(mdi+1.)

       x_burned = 1.0d0 - x_p*dexp(pot) - x_di*dexp(pote)

       xbdot = x_p*dexp(pot)*a*(mp+1.)* &
            (modulo(theta-theta_ig,theta_cycle)/dtheta_p)**mp/dtheta_p
       xbdot = xbdot + x_di*dexp(pote)*a*(mdi+1.)* &
            (modulo(theta-theta_ig,theta_cycle)/dtheta_di)**mdi/dtheta_di
       xbdot = omega * xbdot
    elseif(cyl(icyl)%combustion_data%combustion_model.eq.2) then
       ! Three Wiebe's functions to model the premixed, main and tail
       ! stages in the CI combustion
       Fp = .02
       Ft = .05
       Fm = 1.-Fp-Ft

       Ep =  .7
       Et = 1.5
       Em =  .9

       Dp = 2.
       Dm = 35.
       Dt = 40.

       WCp = (Dp/2.302**(1./Ep) - .105**(1./Ep))**(-Ep)
       WCm = (Dm/2.302**(1./Em) - .105**(1./Em))**(-Em)
       WCt = (Dt/2.302**(1./Et) - .105**(1./Et))**(-Et)

       pot_p = -WCp*(modulo(theta-theta_ig,theta_cycle)*180.0d0/pi)**Ep
       pot_m = -WCm*(modulo(theta-theta_ig,theta_cycle)*180.0d0/pi)**Em
       pot_t = -WCt*(modulo(theta-theta_ig,theta_cycle)*180.0d0/pi)**Et

       x_burned = Fp*(1.0d0 - dexp(pot_p)) + Fm*(1.0d0 - dexp(pot_m)) + &
            Ft*(1.0d0 - dexp(pot_t))

       xbdot =         Fp*dexp(pot_p) * WCp * Ep * &
            (modulo(theta-theta_ig,theta_cycle)*180.0d0/pi)**(Ep-1.0)
       xbdot = xbdot + Fm*dexp(pot_m) * WCm * Em * &
            (modulo(theta-theta_ig,theta_cycle)*180.0d0/pi)**(Em-1.0)
       xbdot = xbdot + Ft*dexp(pot_t) * WCt * Et * &
            (modulo(theta-theta_ig,theta_cycle)*180.0d0/pi)**(Et-1.0)
       xbdot = omega * xbdot * 180.0d0/pi
    elseif(cyl(icyl)%combustion_data%combustion_model.eq.3) then
       theta_id = cyl(icyl)%injection_data%theta_id
       phi_ig   = cyl(icyl)%combustion_data%phi_ig
       rpm      = 30.*omega/pi

       coef     = (/ 2.0d0 + 1.25d-8*(500.0/3.0*theta_id)**2.4, 5000d0/)
       coefp    = (/ 14.2d0/phi_ig**0.644, 0.79d0*(14.2d0/phi_ig**0.644)**0.25 /)
       beta     = 1d0 - 0.926d0*phi_ig**0.37/(500.0/3.0*theta_id/rpm)**0.26

       tau = modulo(theta-theta_ig*pi/180.,theta_cycle)/dtheta_comb

       x_burned = beta*(1.-(1.-tau**coef(1))**coef(2)) + &
            (1.-beta)*(1.-dexp(-coefp(1)*tau**coefp(2)))

       xbdot = omega/dtheta_comb*(beta*coef(1)*coef(2)*tau**(coef(1)-1.)* &
            (1.-tau**coef(1))**(coef(2)-1) + &
            (1.-beta)*coefp(1)*coefp(2)*tau**(coefp(2)-1.)*dexp(-coefp(1)*tau**coefp(2)))
    elseif(cyl(icyl)%combustion_data%combustion_model.eq.0) then
       theta_deg = theta*180./pi

       call interpolant(cyl(icyl)%combustion_data%xbdot_array(:,1), &
            cyl(icyl)%combustion_data%xbdot_array(:,2), theta_deg, xbdot)
       k = iminloc(dabs(cyl(icyl)%combustion_data%xbdot_array(:,2)-xbdot))
       if(cyl(icyl)%combustion_data%xbdot_array(k,2).gt.xbdot) &
            k = k-1
       x_burned = 0.
       indx     = k-1
       do k=1,indx
          x_burned = x_burned + .5* &
               (cyl(icyl)%combustion_data%xbdot_array(k+1,1) - &
               cyl(icyl)%combustion_data%xbdot_array(k,1))* &
               (cyl(icyl)%combustion_data%xbdot_array(k+1,2) + &
               cyl(icyl)%combustion_data%xbdot_array(k,2))
       end do
       x_burned = x_burned + .5* &
            (theta_deg-cyl(icyl)%combustion_data%xbdot_array(k,1))* &
            (xbdot+cyl(icyl)%combustion_data%xbdot_array(k,2))

       xbdot = omega * xbdot * 180./pi
    end if

    dQ_chem = mass_fuel * Q_fuel * xbdot

    dQ_ht_fuel = mass_fuel * xbdot * hvap

    if(save_extras) then
       write(nunit,903) x_burned, xbdot
       903    format (F12.8,F12.6)
    endif

  end subroutine CI_combustion

  subroutine comp_scavenge(icyl, mass_cyl, SE)
    !
    !
    !  comp_scavenge is called by: cylinder_solver
    !  comp_scavenge calls the following subroutines and functions: fa_ratio
    !
    implicit none

    integer, intent(in) :: icyl
    real*8, dimension(3), intent(inout) :: mass_cyl
    real*8, intent(out) :: SE

    real*8 :: M,C,mass_tr,SRv,phi,y,factor

    M   = cyl(icyl)%scavenge_data%val_1
    C   = cyl(icyl)%scavenge_data%val_2
    SRv = cyl(icyl)%scavenge_data%SRv

    phi = cyl(icyl)%combustion_data%phi
    y   = cyl(icyl)%fuel_data%y

    factor = fa_ratio(phi,y)

    SE = dmax1(1.0d0 - dexp(M*SRv+C),0.0d0)
    if(cyl(icyl)%scavenge_data%close_cyl.and.(SRv.gt.0.)) then
       mass_tr     = sum(mass_cyl(1:3))
       mass_cyl(2) = mass_tr*SE
       mass_cyl(1) = mass_cyl(2)*factor
       mass_cyl(3) = mass_tr-(mass_cyl(1)+mass_cyl(2))
       SRv = 0.0d0
       mass_cyl(3) = dmax1(mass_cyl(3),0.0d0)
    end if
    cyl(icyl)%scavenge_data%SRv = SRv

  end subroutine comp_scavenge

  subroutine scavenge_ratio(UC, UP, F_P, V_C, dt, SRv)
    !
    !  Computes the scavenge ratio by volume
    !
    !  scavenge_ratio is called by:
    !  scavenge_ratio calls the following subroutines and functions: none
    !
    implicit none

    real*8, intent(in) :: F_P,V_C,dt
    real*8, dimension(3), intent(in) :: UC,UP
    real*8, intent(inout) :: SRv

    real*8 :: u_P,p_P,p_C,expand

    u_P = UP(2)
    p_P = UP(3)
    p_C = UC(2)

    expand = p_P/p_C

    SRv = SRv + expand*dt*u_P*F_P/V_C

  end subroutine scavenge_ratio

  subroutine ignition_delay(icyl, myData, globalData, Ucyl)
    !
    !
    !
    !  ignition_delay is called by: cylinder_solver
    !  ignition_delay calls the following subroutines and functions:
    !    geometry, average_piston_speed
    !
    implicit none

    integer, intent(in) :: icyl
    real*8, dimension(3), intent(in) :: Ucyl
    type(this), intent(in) :: myData
    type(dataSim), intent(in) :: globalData

    integer :: ignition_delay_model
    real*8 :: theta_g,theta,theta_cycle,rpm,dt
    real*8 :: theta_id,angle_aux,theta_inj_ini,dtheta_comb
    real*8 :: A_d,n_d,Ta,t_d,Vch,Vol,Area,Vdot
    real*8 :: nc,T_TC,p_TC,Sp,CN,Ea

    dt          = globalData%dt
    rpm         = globalData%rpm
    theta_cycle = globalData%theta_cycle
    theta_g     = globalData%theta

    theta_id             = cyl(icyl)%injection_data%theta_id
    theta_inj_ini        = cyl(icyl)%injection_data%theta_inj_ini
    dtheta_comb          = cyl(icyl)%combustion_data%dtheta_comb
    ignition_delay_model = cyl(icyl)%injection_data%ignition_delay_model

    theta = modulo(theta_g+myData%theta_0, theta_cycle)

    angle_aux = 0d0
    if(ignition_delay_model.eq.0) then
       ! 'Integral' ignition delay model by Livengood and Wu
       if(theta_id.eq.0. .and. modulo(theta-theta_inj_ini,theta_cycle) .ge. 0. .and. &
            modulo(theta-theta_inj_ini,theta_cycle) .le. dtheta_comb) then
          A_d = 3.45d0
          n_d = 1.02d0
          Ta  = 2100.0d0
          t_d = A_d/((Ucyl(2)*1.0197162d-5)**n_d)*dexp(Ta/Ucyl(3))*1d-3
          if(cyl(icyl)%injection_data%integral + dt/t_d .lt. 1.) then
             cyl(icyl)%injection_data%integral = cyl(icyl)%injection_data%integral + dt/t_d
             angle_aux = dtheta_comb
          else
             angle_aux = 0d0
             theta_id = theta-theta_inj_ini
          endif
       endif
    elseif(ignition_delay_model.eq.1) then
       ! Correlation for the ignition delay proposed by Hardenber and Hase
       Vch = myData%Vol_clearance
       if(theta_id.eq.0. .and. modulo(theta,theta_cycle)-theta_inj_ini .ge. 0. .and. &
            modulo(theta,theta_cycle)-theta_inj_ini .le. dtheta_comb) then
          ! Average piston speed
          Sp = average_piston_speed(rpm, myData%crank_radius, globalData%engine_type)
          CN = 40.
          Ea = 618840./(CN+25.)
          ! We estimates the temperature and pressure at TDC from the start of injection
          call geometry(myData, globalData, Vol, Area, Vdot)
          nc = 1.4
          T_TC = Ucyl(3)*(Vol/Vch)**(nc-1.)
          p_TC = Ucyl(2)*(Vol/Vch)**nc
          theta_id = (0.36d0+0.22d0*Sp)*dexp(Ea*(1d0/(8.3143d0*T_TC)-1d0/17190d0)* &
               (21.2d0/(1d-5*p_TC-12.4d0))**0.63d0)
          theta_id = theta_id*pi/180.
          write(*,*) theta_id, T_TC, p_TC
       endif
    elseif(ignition_delay_model.eq.2) then
       ! A constant user-defined ignition delay angle
    else
       stop ' Unknown ignition delay model '
    endif

    cyl(icyl)%combustion_data%theta_ig_0 = &
         modulo(theta_inj_ini+theta_id+angle_aux,theta_cycle)
    cyl(icyl)%injection_data%theta_id    = theta_id

  end subroutine ignition_delay

  subroutine restart_injection_var(icyl, theta_cycle, theta, theta_id, &
       theta_ig_0, dtheta_comb, mass_cyl)
    !
    !
    !
    !  restart_injection_var is called by: cylinder_solver
    !  restart_injection_var calls the following subroutines and functions: none
    !
    implicit none

    integer, intent(in) :: icyl
    real*8, intent(in) :: theta,theta_cycle,theta_id,theta_ig_0,dtheta_comb
    real*8, dimension(3), intent(inout) :: mass_cyl

    if(theta_id.ne.0.0 .and. &
         modulo(theta-theta_ig_0,theta_cycle) .gt. dtheta_comb .and. &
         .not.(cyl(icyl)%combustion_data%start_comb)) then
       mass_cyl(1)     = 0.0d0

       cyl(icyl)%injection_data%theta_id    = 0.0d0
       cyl(icyl)%injection_data%integral    = 0d0
       cyl(icyl)%combustion_data%phi        = 0d0
       cyl(icyl)%combustion_data%start_comb = .true.
    end if

  end subroutine restart_injection_var

  subroutine heat_released(icyl, type_ig, theta, omega, theta_cycle, &
       dQ_chem, dQ_ht_fuel, xb, xbdot, mass_cyl, save_extras, nunit)
    !
    !
    !
    !  heat_released is called by: cylinder_solver, cylinder_solver_multizone
    !  heat_released calls the following subroutines and functions:
    !    SI_combustion, CI_combustion
    !
    implicit none

    integer, intent(in) :: icyl,type_ig,nunit
    real*8, intent(in) :: theta,theta_cycle,omega
    real*8, dimension(3), intent(inout) :: mass_cyl
    real*8, intent(out) :: dQ_chem,dQ_ht_fuel,xb,xbdot
    logical, intent(in) :: save_extras
    real*8 :: dtheta_comb,theta_ig
    real*8 :: mass_fuel,mass_air,mass_res

    dQ_chem    = 0.
    dQ_ht_fuel = 0.
    xb = 0.
    xbdot = 0.

    dtheta_comb = cyl(icyl)%combustion_data%dtheta_comb
    theta_ig    = cyl(icyl)%combustion_data%theta_ig_0

    if(modulo(theta-theta_ig,theta_cycle).ge.0. .and. &
         modulo(theta-theta_ig,theta_cycle).le. &
         modulo(theta-(theta_ig+dtheta_comb),theta_cycle)) then
       mass_fuel = cyl(icyl)%combustion_data%mass_fuel_ini
       mass_air  = cyl(icyl)%combustion_data%mass_air_ini
       mass_res  = cyl(icyl)%combustion_data%mass_res_ini

       if(type_ig.eq.0) then
          call SI_combustion(icyl, theta, mass_fuel, omega, theta_cycle, &
               xb, xbdot, dQ_chem, dQ_ht_fuel,save_extras, nunit)
          cyl(icyl)%combustion_data%start_comb = .false.
       else
          if(cyl(icyl)%combustion_data%start_comb) &
               cyl(icyl)%combustion_data%phi_ig = cyl(icyl)%combustion_data%phi
          call CI_combustion(icyl, theta, mass_fuel, omega, theta_cycle, &
               xb, dQ_chem, dQ_ht_fuel, save_extras, nunit)
          cyl(icyl)%combustion_data%start_comb = .false.
       endif

       mass_cyl(1) = (1.-xb)*mass_fuel
       mass_cyl(2) = (1.-xb)*mass_air
       mass_cyl(3) = mass_res+xb*(mass_fuel+mass_air)

       mass_cyl(1) = dmax1(mass_cyl(1),0.0d0)
       mass_cyl(2) = dmax1(mass_cyl(2),0.0d0)
       mass_cyl(3) = dmax1(mass_cyl(3),0.0d0)

    else
       if(.not.cyl(icyl)%combustion_data%start_comb) &
            cyl(icyl)%combustion_data%start_comb = .true.
       if(save_extras) then
          write(nunit,905) 0,0
          905 format(I12,I12)
       endif
    end if

  end subroutine heat_released

  subroutine fuel_injection(icyl, theta_cycle, theta, rpm, dt, mass_cyl_old, mass_cyl)
    !
    !
    !
    !  fuel_injection is called by: cylinder_solver
    !  fuel_injection calls the following subroutines and functions:
    !    mass_injection, fa_ratio
    !
    implicit none

    integer, intent(in) :: icyl
    real*8, intent(in) :: theta_cycle,theta,rpm,dt
    real*8, dimension(3), intent(in) :: mass_cyl_old
    real*8, dimension(3), intent(inout) :: mass_cyl

    real*8 :: theta_inj_ini,dtheta_inj,delta_mass_fuel
    real*8 :: f_st,phi

    theta_inj_ini = cyl(icyl)%injection_data%theta_inj_ini
    dtheta_inj    = cyl(icyl)%injection_data%dtheta_inj

    delta_mass_fuel = 0.0

    if(modulo(theta-theta_inj_ini,theta_cycle) .ge. 0.0 .and. &
         modulo(theta-theta_inj_ini,theta_cycle) .le. dtheta_inj) then
       call mass_injection(icyl, theta, rpm, dt, delta_mass_fuel)

       f_st = fa_ratio(1.0d0, cyl(icyl)%fuel_data%y)
       phi  = cyl(icyl)%combustion_data%phi
       phi  = phi + (1.+phi*f_st)/((mass_cyl(1)+mass_cyl(2))*f_st)* &
            (delta_mass_fuel - 0.*phi*f_st*(mass_cyl(2)-mass_cyl_old(2)))
       phi  = dmax1(phi,0.0d0)
       cyl(icyl)%combustion_data%phi = phi
    end if

    mass_cyl(1) = mass_cyl(1)+delta_mass_fuel

  end subroutine fuel_injection

  subroutine mass_injection(icyl, theta, rpm, dt, dmass)
    !
    !
    !
    !  mass_injection is called by: fuel_injection
    !  mass_injection calls the following subroutines and functions:
    !    interpolant
    !
    implicit none

    integer, intent(in) :: icyl
    real*8, intent(in) :: theta,rpm,dt
    real*8, intent(out) :: dmass

    real*8 :: m_inj,theta_inj_ini,dtheta_inj
    real*8 :: mass_dot,omega

    omega = rpm*pi/ 30.

    theta_inj_ini = cyl(icyl)%injection_data%theta_inj_ini
    dtheta_inj    = cyl(icyl)%injection_data%dtheta_inj
    m_inj         = cyl(icyl)%injection_data%m_inj

    if(cyl(icyl)%injection_data%pulse.eq.1) then
       mass_dot = 2.0d0*m_inj*omega/dtheta_inj* &
            (dsin(pi*theta/dtheta_inj))**2
    elseif(cyl(icyl)%injection_data%pulse.eq.2) then
       mass_dot = m_inj*omega/dtheta_inj
    elseif(cyl(icyl)%injection_data%pulse.eq.3) then
       call interpolant(cyl(icyl)%injection_data%mfdot_array(:,1), &
            cyl(icyl)%injection_data%mfdot_array(:,2), theta*180./pi, mass_dot)
    else
       stop 'Bad pulse type for fuel injection'
    end if

    dmass = dt * mass_dot

  end subroutine mass_injection

  subroutine comp_cyl_masses(icyl, nvi, nve, dt, mass_in, mass_out, EGR, &
       mass_cyl_old, mass_cyl)
    !
    !
    !
    !  comp_cyl_masses is called by: cylinder_solver
    !  comp_cyl_masses calls the following subroutines and functions:
    !    fa_ratio
    !
    implicit none

    integer, intent(in) :: icyl, nvi, nve
    real*8, intent(in) :: dt, EGR
    real*8, dimension(nvi), intent(in) :: mass_in
    real*8, dimension(nve), intent(in) :: mass_out
    real*8, dimension(3), intent(in) :: mass_cyl_old
    real*8, dimension(3), intent(out) :: mass_cyl

    integer :: ival
    real*8 :: mass_old, xr, phi, y, factor
    real*8 :: delta_mass_air, delta_mass_fuel, delta_mass_res
    real*8 :: mass_res_port, mf_factor

    mass_old = sum(mass_cyl_old)
    xr       = mass_cyl_old(3)/mass_old

    phi = cyl(icyl)%combustion_data%phi
    y   = cyl(icyl)%fuel_data%y

    factor = fa_ratio(phi,y)

    delta_mass_air = 0.0d0
    delta_mass_res = 0.0d0

    do ival=1,nvi
       mass_res_port = cyl(icyl)%intake_valves(ival)%mass_res_port
       mf_factor     = cyl(icyl)%intake_valves(ival)%mass_flow_factor
       if(mass_in(ival).gt.0.) then
          if(mass_in(ival)*dt.gt.mass_res_port*mf_factor) then
             delta_mass_air = delta_mass_air + &
                  (dt*mass_in(ival)-mass_res_port*mf_factor)* &
                  (1.-EGR)/(1.+factor)
             delta_mass_res = delta_mass_res + &
                  mass_res_port*mf_factor*(1.-EGR) + &
                  dt*mass_in(ival)*EGR
             mass_res_port  = mass_res_port*(1.-mf_factor)
          else
             delta_mass_res = delta_mass_res + mass_in(ival)*dt
             mass_res_port  = mass_res_port  - mass_in(ival)*dt
          end if
       else
          delta_mass_air = delta_mass_air + &
               dt*mass_in(ival)*(1.-xr)/(1.+factor)
          delta_mass_res = delta_mass_res + mass_in(ival)*dt*xr
          mass_res_port  = mass_res_port  - mass_in(ival)*dt*xr
       endif
       cyl(icyl)%intake_valves(ival)%mass_res_port = &
            dmax1(mass_res_port, 0.0d0)
    end do

    do ival=1,nve
       if(mass_out(ival).gt.0.) then
          delta_mass_res = delta_mass_res + mass_out(ival)*dt
       else
          delta_mass_res = delta_mass_res + mass_out(ival)*dt*xr
          delta_mass_air = delta_mass_air + &
               dt*(1.-xr)*mass_out(ival)/(1.+factor)
       end if
    end do

    delta_mass_fuel = factor*delta_mass_air

    mass_cyl(1) = dmax1(mass_cyl_old(1)+delta_mass_fuel,0.0d0)
    mass_cyl(2) = dmax1(mass_cyl_old(2)+delta_mass_air,0.0d0)
    mass_cyl(3) = dmax1(mass_cyl_old(3)+delta_mass_res,0.0d0)

  end subroutine comp_cyl_masses

  subroutine cylinder_solver(icyl, myData, globalData, Ucyl, Uiv, Uev, &
       Upiv, Upev, Fiv, Fev, EGR, mass_cyl_old, mass_cyl, t_wall)
    !
    !
    !
    !  cylinder_solver is called by: solve_cylinder
    !  cylinder_solver calls the following subroutines and functions:
    !    valve_flow, geometry, heat_transfer, comp_cyl_masses,
    !    ignition_delay, restart_injection_var, fuel_injection,
    !    heat_released, compute_cp
    !
    implicit none

    integer, intent(in) :: icyl
    real*8, intent(in) :: EGR
    real*8, dimension(3), intent(in) :: mass_cyl_old
    real*8, dimension(cyl(icyl)%nvi), intent(in) :: Fiv
    real*8, dimension(cyl(icyl)%nve), intent(in) :: Fev
    real*8, dimension(3,cyl(icyl)%nvi), intent(in) :: Uiv,Upiv
    real*8, dimension(3,cyl(icyl)%nve), intent(in) :: Uev,Upev
    type(this), intent(inout) :: myData
    type(dataSim), intent(inout) :: globalData
    real*8, dimension(3), intent(inout) :: Ucyl
    real*8, dimension(3), intent(out) :: mass_cyl
	  real*8,dimension(mydata%ntemp):: t_wall

    integer :: ispecie,type_ig, nunit, engine_type, converge_mode
    real*8 :: dt,rpm,theta_g,theta,theta_cycle
    real*8 :: Vol,Area,Vdot,mass_old,mass_new
    real*8 :: omega,rho_cyl,p_cyl,T_cyl
    real*8 :: dQ_ht,dQ_chem,dQ_ht_fuel,phi,xb,xbdot
    real*8 :: edot,ene_old,ene_new,Bo,a
    real*8 :: SE, Torque, converge_var_new
    real*8, dimension(cyl(icyl)%nvi) :: mass_in, h_in
    real*8, dimension(cyl(icyl)%nve) :: mass_out, h_out
    logical :: save_extras,exist

    real*8, dimension(3) :: Ucyl_old

    theta_cycle = globalData%theta_cycle
    dt          = globalData%dt
    rpm         = globalData%rpm
    theta_g     = globalData%theta
    save_extras = globalData%save_extras
    engine_type = globalData%engine_type
    nunit       = myData%nunit
    type_ig     = myData%type_ig
    Bo  = myData%Bore              ! Bore
    a   = myData%crank_radius

    theta = modulo(theta_g+myData%theta_0, theta_cycle)

    omega = rpm*pi/30.

    rho_cyl = Ucyl(1)
    p_cyl   = Ucyl(2)
    T_cyl   = Ucyl(3)

    Ucyl_old = Ucyl

    call valve_flow(cyl(icyl)%nvi, 1, globalData%ga_intake, &
         Fiv, Uiv, Upiv, Ucyl, mass_in, h_in)
    call valve_flow(cyl(icyl)%nve, -1, cyl(icyl)%gas_properties%gamma, &
         Fev, Uev, Upev, Ucyl, mass_out, h_out)

    ! Engine geometrical data
    call geometry(myData, globalData, Vol, Area, Vdot)

    !Chequeo convergencia
    call convergence(myData, globalData, p_cyl, T_cyl, mass_in, mass_out, Vdot, icyl)

    ! Computing heat losses
    call heat_transfer(myData, globalData, Ucyl, Area, &
         cyl(icyl)%gas_properties%cp, dQ_ht, t_wall)
    ! Computing the fuel mass, air mass and gas residual mass into the cylinder
    call comp_cyl_masses(icyl, cyl(icyl)%nvi, cyl(icyl)%nve, dt, mass_in, &
         mass_out, EGR, mass_cyl_old, mass_cyl)
    ! Computing scavenge
    if(myData%scavenge) call comp_scavenge(icyl, mass_cyl, SE)
    if(type_ig.eq.1) then
       ! Computing the ignition delay (for CI engines only)
       call ignition_delay(icyl, myData, globalData, Ucyl)
       call restart_injection_var(icyl, theta_cycle, theta, cyl(icyl)%injection_data%theta_id, &
            cyl(icyl)%combustion_data%theta_ig_0, cyl(icyl)%combustion_data%dtheta_comb, &
            mass_cyl)
       ! Computing the fuel injection (for CI engines only)
       call fuel_injection(icyl, theta_cycle, theta, rpm, dt, mass_cyl_old, mass_cyl)
    end if
    ! Computing the heat released by combustion
    if(cyl(icyl)%combustion_data%start_comb) then
       cyl(icyl)%combustion_data%mass_fuel_ini = mass_cyl_old(1)
       cyl(icyl)%combustion_data%mass_air_ini  = mass_cyl_old(2)
       cyl(icyl)%combustion_data%mass_res_ini  = mass_cyl_old(3)
    end if
    call heat_released(icyl, type_ig, theta, omega, theta_cycle, &
         dQ_chem, dQ_ht_fuel, xb, xbdot, mass_cyl, save_extras, nunit)

    mass_old = sum(mass_cyl_old)
    mass_new = sum(mass_cyl)

    edot    = (sum(h_in)+sum(h_out))-p_cyl*Vdot+dQ_chem-(dQ_ht+dQ_ht_fuel)
    ene_old = mass_old*cyl(icyl)%gas_properties%cv*T_cyl
    ene_new = ene_old + dt*edot

    ! Continuity equation
    rho_cyl = mass_new/Vol
    ! Energy equation
    T_cyl  = ene_new/(mass_new*cyl(icyl)%gas_properties%cv)
    ! State equation
    p_cyl  = rho_cyl*cyl(icyl)%gas_properties%R_gas*T_cyl

    Ucyl(1) = rho_cyl
    Ucyl(2) = p_cyl
    Ucyl(3) = T_cyl

    !DEBUG
    if (globalData%debug.gt.0) then
       if (mod(globaldata%iter_sim1d,1)==0) then
           inquire(file="cylinder_debug.csv", exist=exist)
           if (exist) then
               open(13, file="cylinder_debug.csv", status="old", position="append", action="write")
           else
               open(13, file="cylinder_debug.csv", status="new", action="write")
           end if
           write(13,"(F20.3,A1,F20.3,A1,F20.3,A1,I4,A1,I4,A1,F10.5,A1,F10.5)") &
               p_cyl, ";", Ucyl(3), ";", cyl(icyl)%state_multizone(3), ";", icyl, &
                   ";", globalData%icycle, ";", globalData%time, ";", theta
           close(13)
       end if
    end if
    !END DEBUG

    if(globalData%use_global_gas_prop) then
       ispecie = 0
       cyl(icyl)%gas_properties%cp = compute_cp(T_cyl, ispecie, &
            cyl(icyl)%gas_properties%R_gas)
       cyl(icyl)%gas_properties%cv = cyl(icyl)%gas_properties%cp - &
            cyl(icyl)%gas_properties%R_gas
       cyl(icyl)%gas_properties%gamma = globalData%ga
    else
       phi = cyl(icyl)%combustion_data%phi
       if(type_ig.eq.1) phi = cyl(icyl)%combustion_data%phi_ig
       call compute_composition(0, phi, cyl(icyl)%fuel_data%alpha, &
            cyl(icyl)%fuel_data%beta, cyl(icyl)%fuel_data%gamma, &
            cyl(icyl)%fuel_data%delta, mass_cyl(1), mass_cyl(2), mass_cyl(3), &
            cyl(icyl)%gas_properties%composition)
       cyl(icyl)%gas_properties%R_gas = &
            compute_Rgas(cyl(icyl)%gas_properties%composition(1:10), &
            cyl(icyl)%gas_properties%composition(11),cyl(icyl)%fuel_data%Mw)
       cyl(icyl)%gas_properties%cp = compute_cp_mix(T_cyl, &
            cyl(icyl)%gas_properties%R_gas, &
            cyl(icyl)%gas_properties%composition(1:10), &
            cyl(icyl)%gas_properties%composition(11), &
            cyl(icyl)%fuel_data%coef_cp)
       cyl(icyl)%gas_properties%cv = cyl(icyl)%gas_properties%cp - &
            cyl(icyl)%gas_properties%R_gas
       cyl(icyl)%gas_properties%gamma = cyl(icyl)%gas_properties%cp / &
            cyl(icyl)%gas_properties%cv

       write(30,907) globalData%icycle, theta*180/pi, &
            cyl(icyl)%gas_properties%gamma, cyl(icyl)%gas_properties%R_gas, &
            cyl(icyl)%gas_properties%cp, cyl(icyl)%gas_properties%composition
    907    format (I12,F12.4,F15.10,F15.6,F15.6,F15.10,F15.10,F15.10,F15.10, &
            F15.10,F15.10,F15.10,F15.10,F15.10,F15.10,F15.10)
    end if

    Torque = 0.0
    call fun_cyl_Torque(myData, globalData, p_cyl, theta, Torque)

    if(globalData%save_extras) then
       write(myData%nunit,900) sum(mass_in), sum(mass_out), Vol, Vdot, &
            mass_cyl, dQ_ht, dQ_chem, Torque
    900    format (E15.6,E15.6,E15.6,E15.6,E15.6,E15.6,E15.6,E15.6,E15.6,E15.6)
    endif

  end subroutine cylinder_solver

  subroutine cylinder_solver_multizone(icyl, myData, globalData, Ucyl, Uiv, Uev, &
      Upiv, Upev, Fiv, Fev, EGR, mass_cyl_old, mass_cyl, t_wall)
   !
   !
   !
   !  cylinder_solver_2zone is called by: solve_cylinder
   !  cylinder_solver calls the following subroutines and functions:
   !    valve_flow, geometry, heat_transfer, comp_cyl_masses,
   !    ignition_delay, restart_injection_var, fuel_injection,
   !    heat_released, compute_cp
   !
   implicit none

   integer, intent(in) :: icyl
   real*8, intent(in) :: EGR
   real*8, dimension(3), intent(in) :: mass_cyl_old
   real*8, dimension(cyl(icyl)%nvi), intent(in) :: Fiv
   real*8, dimension(cyl(icyl)%nve), intent(in) :: Fev
   real*8, dimension(3,cyl(icyl)%nvi), intent(in) :: Uiv,Upiv
   real*8, dimension(3,cyl(icyl)%nve), intent(in) :: Uev,Upev
   type(this), intent(inout) :: myData
   type(dataSim), intent(inout) :: globalData
   real*8, dimension(3), intent(inout) :: Ucyl
   real*8, dimension(3), intent(out) :: mass_cyl
   real*8,dimension(mydata%ntemp):: t_wall
   real*8 :: dtheta_comb,theta_ig

   integer :: ispecie,type_ig, nunit, engine_type
   real*8 :: dt,rpm,theta_g,theta,theta_cycle
   real*8 :: Vol,Area,Vdot,mass_old,mass_new,LHV
   real*8 :: omega,rho_cyl,p_cyl,T_cyl,rho_b,T_b,rho_u,T_u,T_avg
   real*8 :: cp_u,cv_u,R_gas_u,dQ_ht_u,dQ_ht_b,Tdot_u,Tdot_b,cv_b,cp_b,R_gas_b
   real*8 :: xb,xbdot,m_b,mdot_b,m_u,mdot_u,yb,ybdot,V_b,Vdot_b,V_u,Vdot_u,piston_pos,A_fdl,Area_u,Area_b
   real*8 :: dQ_ht,dQ_chem,dQ_ht_fuel,phi
   real*8 :: edot,ene_old,ene_new,Bo,a,l
   real*8 :: SE, Torque
   real*8, dimension(cyl(icyl)%nvi) :: mass_in, h_in
   real*8, dimension(cyl(icyl)%nve) :: mass_out, h_out
   logical :: save_extras,exist

   real*8, dimension(3) :: Ucyl_old

   theta_cycle = globalData%theta_cycle
   dt          = globalData%dt
   rpm         = globalData%rpm
   theta_g     = globalData%theta
   dtheta_comb = cyl(icyl)%combustion_data%dtheta_comb
   theta_ig    = cyl(icyl)%combustion_data%theta_ig_0
   save_extras = globalData%save_extras
   engine_type = globalData%engine_type
   nunit       = myData%nunit
   type_ig     = myData%type_ig
   Bo          = myData%Bore
   a           = myData%crank_radius
   l           = myData%rod_length 
   theta       = modulo(theta_g+myData%theta_0, theta_cycle)
   omega       = rpm*pi/30.

   rho_cyl = Ucyl(1)
   p_cyl   = Ucyl(2)
   T_cyl   = Ucyl(3)
   
   rho_u = cyl(icyl)%state_multizone(1)
   T_u = cyl(icyl)%state_multizone(3)

   Ucyl_old = Ucyl
   
   call valve_flow(cyl(icyl)%nvi, 1, globalData%ga_intake, &
        Fiv, Uiv, Upiv, Ucyl, mass_in, h_in)
   call valve_flow(cyl(icyl)%nve, -1, cyl(icyl)%gas_properties%gamma, &
        Fev, Uev, Upev, Ucyl, mass_out, h_out)

   ! Engine geometrical data
   call geometry(myData, globalData, Vol, Area, Vdot)

   ! Check convergence of the cilinder model
   call convergence(myData, globalData, p_cyl, T_cyl, mass_in, mass_out, Vdot, icyl)
  
   ! Computing the fuel mass, air mass and gas residual mass into the cylinder
   call comp_cyl_masses(icyl, cyl(icyl)%nvi, cyl(icyl)%nve, dt, mass_in, &
        mass_out, EGR, mass_cyl_old, mass_cyl)
  
   ! Computing scavenge
   if(myData%scavenge) then
     call comp_scavenge(icyl, mass_cyl, SE)
   end if

   ! CI engine specific code
   if(type_ig.eq.1) then
      write(*,*) "Multizone model NOT implemented for CI engines."
      STOP
   end if

    ! Computing the heat released by combustion
    if(cyl(icyl)%combustion_data%start_comb) then
      cyl(icyl)%combustion_data%mass_fuel_ini = mass_cyl_old(1)
      cyl(icyl)%combustion_data%mass_air_ini  = mass_cyl_old(2)
      cyl(icyl)%combustion_data%mass_res_ini  = mass_cyl_old(3)
    end if

    ! Check if we are in combustion and create second zone
    if(modulo(theta-theta_ig,theta_cycle).ge.0. .and. &
       modulo(theta-theta_ig,theta_cycle).le. &
       modulo(theta-(theta_ig+dtheta_comb),theta_cycle)) then

      ! Get state variables for burnt zone
      rho_b = Ucyl(1)
      T_b = Ucyl(3)
       
      ! Compute heat released by combustion, mass fraction and volume fraction of burnt gases
      call heat_released(icyl, type_ig, theta, omega, theta_cycle, &
              dQ_chem, dQ_ht_fuel, xb, xbdot, mass_cyl, save_extras, nunit)

      ! Compute cv,cp and R for unburnt zone
      call comp_gas_prop(myData,globalData,mass_cyl,T_u,cv_u,cp_u,R_gas_u,icyl)

      ! If we are at the start of combustion, we create a second zone copying state from single zone model to unburnt
      ! gas zone and estimate initial burnt gas temperature using adiabatic flame temperature model.
      if((modulo(theta-theta_ig,theta_cycle).ge.0).and.(modulo(theta-theta_ig,theta_cycle).lt.(omega*dt))) then
          ! the entalpy diference in the zones is the lower heating value of the fuel per unit of total mass.
          LHV = cyl(icyl)%fuel_data%Q_fuel*mass_cyl(1)/sum(mass_cyl)
          ! First we estimate T_b using cp for unbunrt gas because we don't know bunrt gas temperature
          T_b = Ucyl(3)+LHV/cp_u
          ! After, we calculate cp for bunrt gas with new temperature, we recalculate T_b using average cp. (iterative)
          ! and take the 90% of that temperature to account for heat losses to the wall of the cylinder.
          call comp_gas_prop(myData,globalData,mass_cyl,T_b,cv_b,cp_b,R_gas_b,icyl)
          T_b = 0.9*(Ucyl(3)+2.0*LHV/(cp_b+cp_u))
          rho_u = Ucyl(1)
          T_u = Ucyl(3)
          write(*,*) "INFO: Estimated initial burnt gas temperature (adiabatic flame temperature) is ", T_b
      end if
      ! Compute cv,cp and R for burnt zone
      call comp_gas_prop(myData,globalData,mass_cyl,T_b,cv_b,cp_b,R_gas_b,icyl)

      ! Get volume of zones and its time derivatives
      call comp_volume_multizone(Vol,Vdot,V_b,Vdot_b,V_u,Vdot_u,xb,xbdot,rho_u,rho_b,yb,ybdot)

      ! Get area of zones which is in contact with cylinder wall
      piston_pos = l+a*(1-dcos(theta))-dsqrt(l**2-(a*dsin(theta))**2)
      call geometry_multizone(A_fdl,Area_b,icyl,V_b,piston_pos)
      Area_u = Area-Area_b

      ! Compute heat transfer to cylinder wall for both zone.
      call heat_transfer_multizone(myData, globalData, rho_u, P_cyl, T_u, Area_u, cp_u, dQ_ht_u, t_wall)
      call heat_transfer_multizone(myData, globalData, rho_b, P_cyl, T_b, Area_b, cp_b, dQ_ht_b, t_wall)

      !DEBUG (warning: assumes monocyl engine)
      if (globalData%debug.gt.5) then
          inquire(file="cyl_heat_debug_multizone.csv", exist=exist)
          if (exist) then
              open(99, file="cyl_heat_debug_multizone.csv", status="old", position="append", action="write")
          else
              open(99, file="cyl_heat_debug_multizone.csv", status="new", action="write")
          endif
          write(99,"(F20.3,A1,F10.5,A1,F10.5,A1,F10.5)") &
                  dQ_ht_b, ";", dQ_ht_u, ";", globaldata%time,";", globalData%theta
          close(99)
      end if

      ! Compute new temperature, density and pressure of unburnt zone
      m_u = sum(mass_cyl)*(1-xb)
      mdot_u = -sum(mass_cyl)*xbdot

      ! Calculate unburnt zone gas properties
      if (xb.le.0.9999) then
          Tdot_u = (-P_cyl*Vdot_u-dQ_ht_u+R_gas_u*T_u*mdot_u)/(cv_u*m_u)
          T_u = T_u+Tdot_u*dt
          if ((T_u/T_u).ne.1) then
              write(*,*) "ERROR: NAN in unburnt gas temperature.", Tdot_u, m_u, xb, xbdot, sum(mass_cyl), P_cyl, Vdot_u
          end if
      else
          write(*,*) "WARNING: Wrong Wiebe function parameters. Xb should not be equal to 1 at the end of combustion."
      end if


      !OBSERVACION: en caso de que xb=0 rho_b y T_b coindicien con el estado del modelo de una zona
      ! Calculate burnt zone gas properties
      if (xb.ne.0.0) then
          m_b = MAX(sum(mass_cyl)*xb,1e-10)
          mdot_b = sum(mass_cyl)*xbdot
          Tdot_b = -P_cyl*Vdot_b-dQ_ht_b+dQ_chem-dQ_ht_fuel
          Tdot_b = Tdot_b+(cp_u*T_u-cv_b*T_b)*mdot_b
          Tdot_b = Tdot_b/(m_b*cv_b)
          T_b = T_b+Tdot_b*dt
          if ((T_b/T_b).ne.1) then
              write(*,*) "ERROR: NAN in burnt gas temperature.", T_b, Tdot_b
          end if
      else
          write(*,*) "WARNING: xb=0 check your combustion parameters.", xb
      end if


      ! Calculate cylinder pressure
      P_cyl = (m_u*R_gas_u*T_u+m_b*R_gas_b*T_b)/Vol

      ! Calulate density of each zone
      rho_b = P_cyl/(R_gas_b*T_b)
      rho_u = P_cyl/(R_gas_u*T_u)

      ! Refresh state vectors
      Ucyl(1) = rho_b
      Ucyl(2) = P_cyl
      Ucyl(3) = T_b
      cyl(icyl)%state_multizone(1) = rho_u
      cyl(icyl)%state_multizone(2) = P_cyl
      cyl(icyl)%state_multizone(3) = T_u

      !DEBUG
      if (globalData%debug.gt.4) then
        if (mod(globaldata%iter_sim1d,10)==0) then
           inquire(file="cylinder_multizone_debug.csv", exist=exist)
           if (exist) then
               open(17, file="cylinder_multizone_debug.csv", status="old", position="append", action="write")
           else
               open(17, file="cylinder_multizone_debug.csv", status="new", action="write")
           end if
           write(17,"(F20.3,A1,F20.10,A1,F10.9,A1,F20.3,A1,F20.3,A1,F20.3,A1,F10.9,A1,F20.3,A1,F20.3,A1,&
                   F20.3,A1,F20.3,A1,F20.3,A1,F20.3,A1,F10.5,A1,F10.5,A1,I4,A1,I4,A1,F10.5,A1,F10.5)") &
                   xb, ";", (dQ_ht_b+dQ_chem-dQ_ht_fuel+dQ_ht_u)/(omega*(180/pi)), ";", m_b, ";", mdot_b, ";", V_b*1e6, ";"&
                   , Vdot_b*1e6*60/(omega*2*pi), &
                   ";", m_u,";", mdot_u, ";", V_u*1e6, ";", Vdot_u*1e6*60/(omega*2*pi), ";", Vol*1e6, ";",&
                   Vdot*1e6*60/(omega*2*pi), ";", rho_b/rho_u, ";", Area_b, ";", Area, ";", icyl, ";", &
                   globalData%icycle, ";", globalData%time, ";", theta
           close(17)
        end if
      end if
      !END DEBUG
    else

      call heat_released(icyl, type_ig, theta, omega, theta_cycle, &
                         xb, xbdot,dQ_chem, dQ_ht_fuel, mass_cyl, save_extras, nunit)
      ! Computing heat losses
      call heat_transfer(myData, globalData, Ucyl, Area, &
                         cyl(icyl)%gas_properties%cp, dQ_ht, t_wall)

      mass_old = sum(mass_cyl_old)
      mass_new = sum(mass_cyl)

      edot     = (sum(h_in)+sum(h_out))-p_cyl*Vdot+dQ_chem-(dQ_ht+dQ_ht_fuel)
      ene_old  = mass_old*cyl(icyl)%gas_properties%cv*T_cyl
      ene_new  = ene_old + dt*edot

      ! Continuity equation
      rho_cyl = mass_new/Vol
      ! Energy equation
      T_cyl  = ene_new/(mass_new*cyl(icyl)%gas_properties%cv)
      ! State equation
      p_cyl  = rho_cyl*cyl(icyl)%gas_properties%R_gas*T_cyl

      Ucyl(1) = rho_cyl
      Ucyl(2) = p_cyl
      Ucyl(3) = T_cyl

      ! while not in combustion the unburnt zone does not exist
      cyl(icyl)%state_multizone(1) = -1
      cyl(icyl)%state_multizone(2) = -1
      cyl(icyl)%state_multizone(3) = -1
    end if

   !DEBUG
   if (globalData%debug.gt.0) then
       if (mod(globaldata%iter_sim1d,30)==0) then
           write(13,"(F20.3,A1,F20.3,A1,F20.3,A1,I4,A1,I4,A1,F10.5,A1,F10.5)") &
               p_cyl, ";", Ucyl(3), ";", cyl(icyl)%state_multizone(3), ";", icyl, &
                   ";", globalData%icycle, ";", globalData%time, ";", theta
       end if
   end if
   !END DEBUG

   ! Compute gas properties 
   if(globalData%use_global_gas_prop) then
      ispecie = 0
      cyl(icyl)%gas_properties%cp = compute_cp(T_cyl, ispecie, &
           cyl(icyl)%gas_properties%R_gas)
      cyl(icyl)%gas_properties%cv = cyl(icyl)%gas_properties%cp - &
           cyl(icyl)%gas_properties%R_gas
      cyl(icyl)%gas_properties%gamma = globalData%ga
   else
      phi = cyl(icyl)%combustion_data%phi
      if(type_ig.eq.1) phi = cyl(icyl)%combustion_data%phi_ig
      call compute_composition(0, phi, cyl(icyl)%fuel_data%alpha, &
           cyl(icyl)%fuel_data%beta, cyl(icyl)%fuel_data%gamma, &
           cyl(icyl)%fuel_data%delta, mass_cyl(1), mass_cyl(2), mass_cyl(3), &
           cyl(icyl)%gas_properties%composition)
      cyl(icyl)%gas_properties%R_gas = &
           compute_Rgas(cyl(icyl)%gas_properties%composition(1:10), &
           cyl(icyl)%gas_properties%composition(11),cyl(icyl)%fuel_data%Mw)
      cyl(icyl)%gas_properties%cp = compute_cp_mix(T_cyl, &
           cyl(icyl)%gas_properties%R_gas, &
           cyl(icyl)%gas_properties%composition(1:10), &
           cyl(icyl)%gas_properties%composition(11), &
           cyl(icyl)%fuel_data%coef_cp)
      cyl(icyl)%gas_properties%cv = cyl(icyl)%gas_properties%cp - &
           cyl(icyl)%gas_properties%R_gas
      cyl(icyl)%gas_properties%gamma = cyl(icyl)%gas_properties%cp / &
           cyl(icyl)%gas_properties%cv

      write(30,907) globalData%icycle, theta*180/pi, &
           cyl(icyl)%gas_properties%gamma, cyl(icyl)%gas_properties%R_gas, &
           cyl(icyl)%gas_properties%cp, cyl(icyl)%gas_properties%composition
           907 format (I12,F12.4,F15.10,F15.6,F15.6,F15.10,F15.10,F15.10,F15.10, &
           F15.10,F15.10,F15.10,F15.10,F15.10,F15.10,F15.10)
   end if

   Torque = 0.0
   call fun_cyl_Torque(myData, globalData, p_cyl, theta, Torque)

   if(globalData%save_extras) then
      write(myData%nunit,900) sum(mass_in), sum(mass_out), Vol, Vdot, &
           mass_cyl, dQ_ht, dQ_chem, Torque
      900 format (E15.6,E15.6,E15.6,E15.6,E15.6,E15.6,E15.6,E15.6,E15.6,E15.6)
   endif

 end subroutine cylinder_solver_multizone

  subroutine run_ideal_cycle(icyl, myData, globalData, atm_state, AVPT)
    !
    !
    !
    !  run_ideal_cycle is called by: state_initial_cylinder
    !  run_ideal_cycle calls the following subroutines and functions:
    !    fa_ratio, ideal_cycle_4S, ideal_cycle_2S
    !
    implicit none

    integer, intent(in) :: icyl
    real*8, dimension(3), intent(in) :: atm_state
    type(this), intent(in) :: myData
    type(dataSim), intent(in) :: globalData
    real*8, dimension(:,:), intent(out) :: AVPT

    real*8 :: rho_i,T_i,p_i,phi,y,Q_fuel,factor,AF

    Q_fuel = cyl(icyl)%fuel_data%Q_fuel
    phi    = cyl(icyl)%combustion_data%phi
    y      = cyl(icyl)%fuel_data%y

    factor = fa_ratio(phi,y)
    AF     = 1./factor

    rho_i = atm_state(1)
    p_i   = atm_state(3)
    T_i   = p_i/(globalData%R_gas*rho_i)

    if(globalData%theta_cycle.eq.4.*pi) then
       call ideal_cycle_4S(myData, globalData, 0.3*Q_fuel, T_i, p_i, &
            AF, AVPT)
    elseif(globalData%theta_cycle.eq.2.*pi) then
       call ideal_cycle_2S(myData, globalData, 0.3*Q_fuel, T_i, p_i, &
            AF, AVPT)
    elseif(globalData%engine_type.eq.2) then
       call ideal_cycle_mrcvc(myData, globalData, 0.15*Q_fuel, T_i, p_i, &
            AF, AVPT)
    endif

  end subroutine run_ideal_cycle

  subroutine ideal_cycle_4S(myData, globalData, Q_LHV, T_i, p_i, &
       AF, AVPT)
    !
    !  AVPT = [angle , density , pressure , temperature ]
    !
    !  ideal_cycle_4S is called by: run_ideal_cycle
    !  ideal_cycle_4S calls the following subroutines and functions: none
    !
    implicit none

    real*8, intent(in) :: Q_LHV,T_i,p_i,AF
    type(this), intent(in) :: myData
    type(dataSim), intent(in) :: globalData
    real*8, dimension(7,4), intent(out) :: AVPT

    real*8 :: cv,R_gas,ga,Vmin,Vmax,Bo,a,Vd,Vc
    real*8 :: theta1,theta2,theta3,theta4,theta5,theta6,theta7
    real*8 :: rho1,rho2,rho3,rho4,rho5,rho6,rho7
    real*8 :: V1,V2,V3,V4,V5,V6,V7
    real*8 :: p1,p2,p3,p4,p5,p6,p7
    real*8 :: T1,T2,T3,T4,T5,T6,T7
    real*8 :: m1,m2,m3,m4,m5,m6,m7,mf

    ga    = globalData%ga
    R_gas = globalData%R_gas
    cv    = R_gas/(ga-1.)

    Vc  = myData%Vol_clearance  ! Clearance volume
    Bo  = myData%Bore           ! Bore
    a   = myData%crank_radius   ! Cranck radius

    Vd   = a*pi*Bo**2/2.
    Vmin = Vc
    Vmax = Vc+Vd

    ! point 1
    V1     = Vmin
    p1     = p_i
    T1     = T_i
    rho1   = p1/R_gas/T1
    m1     = rho1*V1
    theta1 = 0.

    ! point 2
    V2     = Vmax
    p2     = p1
    T2     = T1
    rho2   = rho1
    m2     = rho2*V2
    theta2 = 180.

    mf = m2/AF
    ! point 3
    V3     = Vmin
    m3     = m2
    rho3   = m3/V3
    p3     = p2*(rho3/rho2)**ga
    T3     = p3/R_gas/rho3
    theta3 = 360.-1.

    ! point 4
    V4     = Vmin
    m4     = m3
    rho4   = rho3
    T4     = T3+mf*Q_LHV/m4/cv
    p4     = R_gas*rho4*T4
    theta4 = 360.+1.

    ! point 5
    V5     = Vmax
    m5     = m4
    rho5   = m5/V5
    p5     = p4*(rho5/rho4)**ga
    T5     = p5/R_gas/rho5
    theta5 = 540.-1.

    ! point 6
    V6     = Vmax
    p6     = p_i
    T6     = T_i
    rho6   = p6/R_gas/T6
    m6     = rho6*V6
    theta6 = 540.+1.

    ! point 7
    V7     = V1
    p7     = p1
    T7     = T1
    rho7   = rho1
    m7     = m1
    theta7 = 720.

    AVPT(:,1) = (/theta1,theta2,theta3,theta4,theta5,theta6,theta7/)
    AVPT(:,2) = (/rho1,rho2,rho3,rho4,rho5,rho6,rho7/)
    AVPT(:,3) = (/p1,p2,p3,p4,p5,p6,p7/)
    AVPT(:,4) = (/T1,T2,T3,T4,T5,T6,T7/)

  end subroutine ideal_cycle_4S

  subroutine ideal_cycle_2S(myData, globalData, Q_LHV, T_i, p_i, &
       AF, AVPT)
    !
    !      AVPT = [angle , density , pressure , temperature ]
    !
    !  ideal_cycle_2S is called by: run_ideal_cycle
    !  ideal_cycle_2S calls the following subroutines and functions: none
    !
    implicit none

    real*8, intent(in) :: Q_LHV,T_i,p_i,AF
    type(this), intent(in) :: myData
    type(dataSim), intent(in) :: globalData
    real*8, dimension(7,4), intent(out) :: AVPT

    real*8 :: cv,R_gas,ga,Vmin,Vmax,Bo,a,Vd,Vc, &
         mass,mf,rho_i,Vivc,m1
    real*8 :: theta1,theta2,theta3,theta4,theta5,theta6,theta7
    real*8 :: rho1,rho2,rho3,rho4,rho5,rho6,rho7
    real*8 :: V1,V2,V3,V4,V5,V6,V7
    real*8 :: p1,p2,p3,p4,p5,p6,p7
    real*8 :: T1,T2,T3,T4,T5,T6,T7

    ga    = globalData%ga
    R_gas = globalData%R_gas
    cv    = R_gas/(ga-1.)

    Vc  = myData%Vol_clearance  ! Clearance volume
    Bo  = myData%Bore           ! Bore
    a   = myData%crank_radius   ! Cranck radius

    Vd   = a*pi*Bo**2/2.
    if(globalData%engine_type.eq.1) &
         Vd = 2.*Vd
    Vmin = Vc
    Vmax = Vc+Vd

    Vivc  = 2./3.*Vmax ! Hay que calcularlo bien!!!!
    rho_i = p_i/(R_gas*T_i)
    mass  = rho_i*Vivc
    mf    = mass/AF

    ! point 1
    V1     = Vmin
    m1     = mass
    rho1   = m1/V1
    T1     = p_i*(rho1/rho_i)**ga/(R_gas*rho1)+mf*Q_LHV/m1/cv
    p1     = R_gas*rho1*T1
    theta1 = 0.

    ! point 2
    V2     = Vivc
    rho2   = m1/V2
    p2     = p1*(rho2/rho1)**ga
    T2     = p2/(R_gas*rho2)
    theta2 = 135.-1.

    ! point 3
    V3     = Vivc
    p3     = p_i
    T3     = T_i
    rho3   = p3/R_gas/T3
    theta3 = 135.+1.

    ! point 4
    V4     = Vmax
    p4     = p_i
    T4     = T_i
    rho4   = rho_i
    theta4 = 180.-1.

    ! point 5
    V5     = Vmax
    p5     = p_i
    T5     = T_i
    rho5   = rho_i
    theta5 = 180.+1.

    ! point 6
    V6     = Vivc
    rho6   = rho_i
    p6     = p_i
    T6     = T_i
    theta6 = 225.

    ! point 7
    V7     = Vmin
    rho7   = mass/Vmin
    p7     = p_i*(rho7/rho_i)**ga
    T7     = p7/(R_gas*rho7)
    theta7 = 360.

    AVPT(:,1) = (/theta1,theta2,theta3,theta4,theta5,theta6,theta7/)
    AVPT(:,2) = (/rho1,rho2,rho3,rho4,rho5,rho6,rho7/)
    AVPT(:,3) = (/p1,p2,p3,p4,p5,p6,p7/)
    AVPT(:,4) = (/T1,T2,T3,T4,T5,T6,T7/)

  end subroutine ideal_cycle_2S

  function average_piston_speed(rpm, a, engine_type)
    !
    !  Computes the average piston speed
    !
    implicit none

    integer, intent(in) :: engine_type
    real*8, intent(in) :: rpm,a
    real*8 :: average_piston_speed

    average_piston_speed = rpm/30.*(2.*a)
    if(engine_type.eq.1) &
         average_piston_speed = 2.*average_piston_speed

  end function average_piston_speed

  function fa_ratio(phi, y)
    !
    !
    !
    implicit none

    real*8, intent(in) :: phi,y
    real*8 :: fa_ratio

    fa_ratio = (12.011+1.008*y)/(34.56*(4+y))*phi

  end function fa_ratio

  subroutine fun_cyl_Torque(myData, globalData, pcyl, theta, Torque)

    implicit none

    real*8, intent(in) :: pcyl, theta
    type(this), intent(in) :: myData
    type(dataSim), intent(in) :: globalData
    real*8, intent(inout) :: Torque

    real*8 :: lambda,Area_piston
    real*8 :: crank_radius,rod_length
    real*8 :: exce,piston_mass,rod_mass,rod_a,rod_b,mass_A,mass_B,mass_t
    real*8 :: sin_phi,cos_phi,tan_phi
    real*8 :: kphi,ks,kphiprime,ksprime
    real*8 :: inercia_J_AB,crankcase_pressure, inercia_crank

    Area_piston  = pi/4.0*myData%Bore**2
    crank_radius = myData%crank_radius
    rod_length   = myData%rod_length
    lambda       = crank_radius/rod_length
    exce         = 0.0
    piston_mass = 0.0
    rod_mass    = 0.0
    rod_a       = 0.0*rod_length;
    rod_b       = rod_length-rod_a

    mass_B      = rod_a/rod_length*rod_mass
    mass_A      = rod_b/rod_length*rod_mass
    mass_t      = piston_mass+mass_B

    inercia_J_AB  = 0.0
    inercia_crank = 0.0

    !theta     = globalData%theta_sim1d
    !theta_cyl = globalData%theta+myData%theta_0;
    ! Modificado Black (04/12/07)
    ! theta_cyl = theta_cyl-floor(theta_cyl/(4*pi))*(4*pi);
    !theta_cyl = modulo(theta_cyl,myData%nstroke*pi)
    ! Fin modificado Black (04/12/07)
    !theta     = theta_cyl

    crankcase_pressure = 0.0

    sin_phi   = (lambda*dsin(theta)-exce/rod_length)
    cos_phi   = dsqrt(1.0d0-sin_phi**2)
    tan_phi   = sin_phi/cos_phi
    kphi      = lambda*dcos(theta)/dsqrt(1.0d0-(lambda*dsin(theta)-exce/rod_length)**2)
    ks        = -crank_radius*(dsin(theta)+kphi/lambda*sin_phi)
    kphiprime = -lambda*dsin(theta)/cos_phi+kphi**2*tan_phi
    ksprime   = -crank_radius*(dcos(theta) + &
         1.0d0/lambda*kphiprime*sin_phi+1.0d0/lambda*kphi**2*cos_phi)
    ! Agregado Black (04/12/07)
    ! Ojo, solo para calcular el torque del gas
    ! No chequeado para calcular la dinamica del mecanismo
    if(globalData%engine_type .eq. 1) then
       sin_phi   = (lambda*dsin(theta-myData%delta_ca)-exce/rod_length)
       cos_phi   = dsqrt(1.0d0-sin_phi**2)
       kphi      = lambda*dcos(theta-myData%delta_ca)/ &
            dsqrt(1.0d0-(lambda*dsin(theta-myData%delta_ca)-exce/rod_length)**2)
       ks        = ks - crank_radius*(dsin(theta-myData%delta_ca)+kphi/lambda*sin_phi)
    end if
    ! Fin agregado Black (04/12/07)

    Torque = (pcyl-crankcase_pressure)*Area_piston*ks

  end subroutine fun_cyl_Torque

  subroutine convergence(myData,globalData,p_cyl,T_cyl,mass_in,mass_out,vdot,icyl)
    implicit none
    integer :: converge_mode
    integer, intent(in) :: icyl
    real*8, intent(in) :: p_cyl, Vdot, T_cyl
    real*8, dimension(cyl(icyl)%nvi), intent(in) :: mass_in
    real*8, dimension(cyl(icyl)%nve), intent(in) :: mass_out
    type(this), intent(inout) :: myData
    type(dataSim), intent(inout) :: globalData
    real*8 :: dt, rpm, theta_g, theta, theta_cycle, omega, time
    real*8 :: converge_var_new, converge_var_old, err  
    logical :: exist

    theta_cycle = globalData%theta_cycle
    time        = globalData%time
    dt          = globalData%dt
    rpm         = globalData%rpm
    theta_g     = globalData%theta
    theta = modulo(theta_g+myData%theta_0, theta_cycle)
    omega = rpm*pi/30.
    converge_var_new = myData%converge_var_new
    converge_mode = myData%converge_mode

    !Criterio: presion maxima por ciclo
    if (converge_mode.eq.1) then
      if (p_cyl.ge.converge_var_new) then
        converge_var_new = p_cyl
      end if
    !Criterio: presion media por ciclo
    elseif (converge_mode.eq.2) then
      converge_var_new=converge_var_new+p_cyl*dt
    !Criterio: masa entrada por ciclo
    elseif (converge_mode.eq.3) then
      converge_var_new=converge_var_new+sum(mass_in)*dt
    !Criterio: masa salida por ciclo
    elseif (converge_mode.eq.4) then
      converge_var_new=converge_var_new+sum(mass_out)*dt
    !Criterio: presion media efectiva por ciclo
    elseif (converge_mode.eq.5) then
      converge_var_new=converge_var_new+vdot*p_cyl*dt
      !Criterio: temperatura media por ciclo
    elseif (converge_mode.eq.6) then
      converge_var_new=converge_var_new+T_cyl*dt
    end if
    myData%converge_var_new=converge_var_new
    
    if (converge_mode.ne.0) then
      if (globalData%icycle.eq.floor(omega*GlobalData%time/(theta_cycle))) then
        err = dabs(myData%converge_var_old-converge_var_new)/dabs(converge_var_new)
        if (globalData%icycle.ne.1) then
             write(*,"(A26,I3,A2,F10.9,A13,I2)") "Error relativo en el ciclo", globalData%icycle-1, ": ", &
                     err, " - Cilindro: ", icyl
             if (err.le.globalData%tol) then
                write(*,"(A42,I2,A13,I2)") "Se alcanzó la convergencia segun criterio", converge_mode, &
                        " - Cilindro: ", icyl
                globalData%has_converged = globalData%has_converged+1
             endif
             !DEBUG
             if (globalData%debug.gt.2) then
                inquire(file="convergence_debug.csv", exist=exist)
                if (exist) then
                    open(8, file="convergence_debug.csv", status="old", position="append", action="write")
                else
                    open(8, file="convergence_debug.csv", status="new", action="write")
                end if
                write(8,"(F12.10,A1,I2,A1,I4,A1,F7.1,A1)") err, ";", icyl, ";", globalData%icycle-1, ";", rpm, ";"
                close(8)
             end if
             !END DEBUG
        end if
        myData%converge_var_old = converge_var_new
        myData%converge_var_new = 0.0
      endif
    end if
  end subroutine convergence

  subroutine comp_volume_multizone(V,Vdot,V_b,Vdot_b,V_u,Vdot_u,xb,xbdot,rho_u,rho_b,yb,ybdot)
    implicit none
    real*8, intent(in) :: V,Vdot,xb,xbdot,rho_u,rho_b
    real*8, intent(out) :: V_b,Vdot_b,V_u,Vdot_u,yb,ybdot
    real*8 :: c

    ! Simplication: we assume dc/dt=0.
    c = rho_u/rho_b
    if (xb.eq.0) then
        ! limit of xb-->0
        yb = 0.0
        ybdot = c*xbdot
    elseif (xb.gt.0.9999) then
        ! limit of xb-->1
        yb = 1.0
        ybdot = xbdot/c
    else
        yb = 1/((((1/xb)-1)/c)+1)
        ybdot = xbdot/(c*xb**2*((-1+1/xb)/c+1)**2)
    end if

    V_b = yb*V
    V_u = V-v_b

    Vdot_b = V*ybdot+yb*Vdot
    Vdot_u = Vdot-Vdot_b

    if ((Vdot_b.lt.0).or.(Vdot_u.gt.0).or.((Vdot_b/Vdot_b).ne.1).or.((Vdot_u/Vdot_u).ne.1)) then
        write(*,*) "WARNING: Multizone volume variation is bad. dV_u/dt: ", Vdot_u, " , dV_b/dt: ", Vdot_b
        write(*,*) V,Vdot,V_b,Vdot_b,V_u,Vdot_u,xb,xbdot,rho_u,rho_b,yb,ybdot
    end if

  end subroutine comp_volume_multizone

  subroutine comp_gas_prop(myData,globalData,mass_cyl,T,cv,cp,R_gas,icyl)
    implicit none
    type(this), intent(inout) :: myData
    type(dataSim), intent(in) :: globalData
    real*8, dimension(3), intent(in) :: mass_cyl
    real*8, intent(out) :: cp,cv,R_gas
    real*8, intent(in) :: T
    real*8 :: Tmax
    integer, intent(in) :: icyl
    real*8 :: phi

    if(globalData%use_global_gas_prop) then
      cp = compute_cp(T, 0, cyl(icyl)%gas_properties%R_gas)
      cv = cp - cyl(icyl)%gas_properties%R_gas
      R_gas = cyl(icyl)%gas_properties%R_gas
    else
      phi = cyl(icyl)%combustion_data%phi
      if(myData%type_ig.eq.1) then
        phi = cyl(icyl)%combustion_data%phi_ig
      end if

      call compute_composition(0, phi, cyl(icyl)%fuel_data%alpha, &
           cyl(icyl)%fuel_data%beta, cyl(icyl)%fuel_data%gamma, &
           cyl(icyl)%fuel_data%delta, mass_cyl(1), mass_cyl(2), mass_cyl(3), &
           cyl(icyl)%gas_properties%composition)

      R_gas = compute_Rgas(cyl(icyl)%gas_properties%composition(1:10), &
           cyl(icyl)%gas_properties%composition(11),cyl(icyl)%fuel_data%Mw)

      cp = compute_cp_mix(T, &
           cyl(icyl)%gas_properties%R_gas, &
           cyl(icyl)%gas_properties%composition(1:10), &
           cyl(icyl)%gas_properties%composition(11), &
           cyl(icyl)%fuel_data%coef_cp)
   
      cv = cp - R_gas
    end if

    Tmax = 5000.0
    if (T.gt.Tmax) then
        write(*,*) "WARNING: gas temperature too high for cp correlation. Continue?"
        read(*,*)
        cp = compute_cp(Tmax, 0, cyl(icyl)%gas_properties%R_gas)
    else
        cp = compute_cp(T, 0, cyl(icyl)%gas_properties%R_gas)
    end if

    cv = cp - cyl(icyl)%gas_properties%R_gas
    R_gas = cyl(icyl)%gas_properties%R_gas
  end subroutine comp_gas_prop

end module def_cylinder
