#### ---- ####
# Archivo generado por SimulatorGUI
# CIMEC - Santa Fe - Argentina 
# Adecuado para levantar desde Interfaz Grafica 
# O para correr desde consola mediante $python main.py 
#### ---- ####


#--------- Inicializacion de Simulator

Simulator0 = dict()
Simulator0['dtheta_rpm'] = 1.0
Simulator0['filein_state'] = ''
Simulator0['calc_engine_data'] = 1
Simulator0['Courant'] = 0.8
Simulator0['heat_flow'] = 1.0
Simulator0['R_gas'] = 287.0
Simulator0['rpms'] = [6000]
Simulator0['filesave_spd'] = ''
Simulator0['filesave_state'] = 'multicyl4TSI'
Simulator0['ncycles'] = 10
Simulator0['folder_name'] = 'multicyl4TSI'
Simulator0['ga'] = 1.3
Simulator0['viscous_flow'] = 1.0
Simulator0['nsave'] = 5
Simulator0['ig_order'] = [0, 2, 3, 1]
Simulator0['get_state'] = 2
Simulator0['nappend'] = 5.0
Simulator0['engine_type'] = 0
Simulator0['nstroke'] = 4
Simulator0['tolerance'] = 0.001

Simulator = Simulator0


#--------- FIN Inicializacion de Simulator


#--------- Inicializacion de Cylinders

Cylinders = []

Cylinders0 = dict()
Cylinders0['crank_radius'] = 0.05
Cylinders0['type_ig'] = 0
Cylinders0['ndof'] = 3
Cylinders0['full_implicit'] = 0.0
Cylinders0['model_ht'] = 1
Cylinders0['factor_ht'] = 1.0
Cylinders0['piston_area'] = 0.005026548
Cylinders0['ownState'] = 1
Cylinders0['mass_C'] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
Cylinders0['nnod'] = 3
Cylinders0['label'] = 'cyl0'
Cylinders0['twall'] = [450.0]
Cylinders0['state_ini'] = [[1.1769, 101330.0, 300.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Cylinders0['nve'] = 1
Cylinders0['head_chamber_area'] = 0.007819075
Cylinders0['type_temperature'] = 0
Cylinders0['rod_length'] = 0.125
Cylinders0['species_model'] = 0
Cylinders0['nvi'] = 1
Cylinders0['delta_ca'] = 0.0
Cylinders0['extras'] = 1
Cylinders0['histo'] = [0]
Cylinders0['Vol_clearance'] = 5.58505360638e-05
Cylinders0['Bore'] = 0.08
Cylinders0['scavenge'] = 0.0
Cylinders0['converge_mode'] = 5


#--------- Inicializacion de fuel

fuel0 = dict()
fuel0['y'] = 2.25
fuel0['hvap_fuel'] = 350000.0
fuel0['Q_fuel'] = 44300000.0

Cylinders0['fuel'] = fuel0


#--------- FIN Inicializacion de fuel


#--------- Inicializacion de combustion

combustion0 = dict()
combustion0['phi'] = 1.0
combustion0['a_wiebe'] = 6.02
combustion0['dtheta_comb'] = 1.0471975512
combustion0['combustion_model'] = 1
combustion0['m_wiebe'] = 1.64
combustion0['theta_ig_0'] = 5.8643062867

Cylinders0['combustion'] = combustion0


#--------- FIN Inicializacion de combustion


#--------- Inicializacion de injection

injection0 = dict()

Cylinders0['injection'] = injection0


#--------- FIN Inicializacion de injection

Cylinders0['position'] = (319,78)
Cylinders0['exhaust_valves'] = []
Cylinders0['intake_valves'] = []

Cylinders.append(Cylinders0)

Cylinders1 = dict()
Cylinders1['crank_radius'] = 0.05
Cylinders1['type_ig'] = 0
Cylinders1['ndof'] = 3
Cylinders1['full_implicit'] = 0.0
Cylinders1['model_ht'] = 1
Cylinders1['factor_ht'] = 1.0
Cylinders1['piston_area'] = 0.005026548
Cylinders1['ownState'] = 1
Cylinders1['mass_C'] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
Cylinders1['nnod'] = 3
Cylinders1['label'] = 'cyl1'
Cylinders1['twall'] = [450.0]
Cylinders1['state_ini'] = [[1.1769, 101330.0, 300.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Cylinders1['nve'] = 1
Cylinders1['head_chamber_area'] = 0.007819075
Cylinders1['type_temperature'] = 0
Cylinders1['rod_length'] = 0.125
Cylinders1['species_model'] = 0
Cylinders1['nvi'] = 1
Cylinders1['delta_ca'] = 0.0
Cylinders1['extras'] = 1
Cylinders1['histo'] = [0]
Cylinders1['Vol_clearance'] = 5.58505360638e-05
Cylinders1['Bore'] = 0.08
Cylinders1['scavenge'] = 0.0
Cylinders1['converge_mode'] = 5


#--------- Inicializacion de fuel

fuel0 = dict()
fuel0['y'] = 2.25
fuel0['hvap_fuel'] = 350000.0
fuel0['Q_fuel'] = 44300000.0

Cylinders1['fuel'] = fuel0


#--------- FIN Inicializacion de fuel


#--------- Inicializacion de combustion

combustion0 = dict()
combustion0['phi'] = 1.0
combustion0['a_wiebe'] = 6.02
combustion0['dtheta_comb'] = 1.0471975512
combustion0['combustion_model'] = 1
combustion0['m_wiebe'] = 1.64
combustion0['theta_ig_0'] = 5.8643062867

Cylinders1['combustion'] = combustion0


#--------- FIN Inicializacion de combustion


#--------- Inicializacion de injection

injection0 = dict()

Cylinders1['injection'] = injection0


#--------- FIN Inicializacion de injection

Cylinders1['position'] = (324,156)
Cylinders1['exhaust_valves'] = []
Cylinders1['intake_valves'] = []

Cylinders.append(Cylinders1)

Cylinders2 = dict()
Cylinders2['crank_radius'] = 0.05
Cylinders2['type_ig'] = 0
Cylinders2['ndof'] = 3
Cylinders2['full_implicit'] = 0.0
Cylinders2['model_ht'] = 1
Cylinders2['factor_ht'] = 1.0
Cylinders2['piston_area'] = 0.005026548
Cylinders2['ownState'] = 1
Cylinders2['mass_C'] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
Cylinders2['nnod'] = 3
Cylinders2['label'] = 'cyl2'
Cylinders2['twall'] = [450.0]
Cylinders2['state_ini'] = [[1.1769, 101330.0, 300.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Cylinders2['nve'] = 1
Cylinders2['head_chamber_area'] = 0.007819075
Cylinders2['type_temperature'] = 0
Cylinders2['rod_length'] = 0.125
Cylinders2['species_model'] = 0
Cylinders2['nvi'] = 1
Cylinders2['delta_ca'] = 0.0
Cylinders2['extras'] = 1
Cylinders2['histo'] = [0]
Cylinders2['Vol_clearance'] = 5.58505360638e-05
Cylinders2['Bore'] = 0.08
Cylinders2['scavenge'] = 0.0
Cylinders2['converge_mode'] = 5


#--------- Inicializacion de fuel

fuel0 = dict()
fuel0['y'] = 2.25
fuel0['hvap_fuel'] = 350000.0
fuel0['Q_fuel'] = 44300000.0

Cylinders2['fuel'] = fuel0


#--------- FIN Inicializacion de fuel


#--------- Inicializacion de combustion

combustion0 = dict()
combustion0['phi'] = 1.0
combustion0['a_wiebe'] = 6.02
combustion0['dtheta_comb'] = 1.0471975512
combustion0['combustion_model'] = 1
combustion0['m_wiebe'] = 1.64
combustion0['theta_ig_0'] = 5.8643062867

Cylinders2['combustion'] = combustion0


#--------- FIN Inicializacion de combustion


#--------- Inicializacion de injection

injection0 = dict()

Cylinders2['injection'] = injection0


#--------- FIN Inicializacion de injection

Cylinders2['position'] = (310,277)
Cylinders2['exhaust_valves'] = []
Cylinders2['intake_valves'] = []

Cylinders.append(Cylinders2)

Cylinders3 = dict()
Cylinders3['crank_radius'] = 0.05
Cylinders3['type_ig'] = 0
Cylinders3['ndof'] = 3
Cylinders3['full_implicit'] = 0.0
Cylinders3['model_ht'] = 1
Cylinders3['factor_ht'] = 1.0
Cylinders3['piston_area'] = 0.005026548
Cylinders3['ownState'] = 1
Cylinders3['mass_C'] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
Cylinders3['nnod'] = 3
Cylinders3['label'] = 'cyl3'
Cylinders3['twall'] = [450.0]
Cylinders3['state_ini'] = [[1.1769, 101330.0, 300.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Cylinders3['nve'] = 1
Cylinders3['head_chamber_area'] = 0.007819075
Cylinders3['type_temperature'] = 0
Cylinders3['rod_length'] = 0.125
Cylinders3['species_model'] = 0
Cylinders3['nvi'] = 1
Cylinders3['delta_ca'] = 0.0
Cylinders3['extras'] = 1
Cylinders3['histo'] = [0]
Cylinders3['Vol_clearance'] = 5.58505360638e-05
Cylinders3['Bore'] = 0.08
Cylinders3['scavenge'] = 0.0
Cylinders3['converge_mode'] = 5


#--------- Inicializacion de fuel

fuel0 = dict()
fuel0['y'] = 2.25
fuel0['hvap_fuel'] = 350000.0
fuel0['Q_fuel'] = 44300000.0

Cylinders3['fuel'] = fuel0


#--------- FIN Inicializacion de fuel


#--------- Inicializacion de combustion

combustion0 = dict()
combustion0['phi'] = 1.0
combustion0['a_wiebe'] = 6.02
combustion0['dtheta_comb'] = 1.0471975512
combustion0['combustion_model'] = 1
combustion0['m_wiebe'] = 1.64
combustion0['theta_ig_0'] = 5.8643062867

Cylinders3['combustion'] = combustion0


#--------- FIN Inicializacion de combustion


#--------- Inicializacion de injection

injection0 = dict()

Cylinders3['injection'] = injection0


#--------- FIN Inicializacion de injection

Cylinders3['position'] = (315,370)
Cylinders3['exhaust_valves'] = []
Cylinders3['intake_valves'] = []

Cylinders.append(Cylinders3)


#--------- FIN Inicializacion de Cylinders


#--------- Inicializacion de Valves

Valves = []

Valves0 = dict()
Valves0['angle_VC'] = 3.83972435439
Valves0['Lvmax'] = 0.009
Valves0['label'] = 'ivalve0'
Valves0['histo'] = 0
Valves0['Nval'] = 1
Valves0['Dv'] = 0.035
Valves0['type_dat'] = 0
Valves0['Cd'] = [[0.0, 0.8], [0.009, 0.8]]
Valves0['type'] = 0
Valves0['angle_V0'] = 12.3918376892
Valves0['valve_model'] = 1
Valves0['position'] = (269,84)
Valves0['tube'] = 0
Valves0['ncyl'] = 0
Valves0['typeVal'] = 'int'
Cylinders0['intake_valves'].append(Valves0)
Valves.append(Valves0)

Valves1 = dict()
Valves1['angle_VC'] = 3.83972435439
Valves1['Lvmax'] = 0.009
Valves1['label'] = 'ivalve1'
Valves1['histo'] = 0
Valves1['Nval'] = 1
Valves1['Dv'] = 0.035
Valves1['type_dat'] = 0
Valves1['Cd'] = [[0.0, 0.8], [0.009, 0.8]]
Valves1['type'] = 0
Valves1['angle_V0'] = 12.3918376892
Valves1['valve_model'] = 1
Valves1['position'] = (279,166)
Valves1['tube'] = 1
Valves1['ncyl'] = 1
Valves1['typeVal'] = 'int'
Cylinders1['intake_valves'].append(Valves1)
Valves.append(Valves1)

Valves2 = dict()
Valves2['angle_VC'] = 3.83972435439
Valves2['Lvmax'] = 0.009
Valves2['label'] = 'ivalve2'
Valves2['histo'] = 0
Valves2['Nval'] = 1
Valves2['Dv'] = 0.035
Valves2['type_dat'] = 0
Valves2['Cd'] = [[0.0, 0.8], [0.009, 0.8]]
Valves2['type'] = 0
Valves2['angle_V0'] = 12.3918376892
Valves2['valve_model'] = 1
Valves2['position'] = (266,278)
Valves2['tube'] = 2
Valves2['ncyl'] = 2
Valves2['typeVal'] = 'int'
Cylinders2['intake_valves'].append(Valves2)
Valves.append(Valves2)

Valves3 = dict()
Valves3['angle_VC'] = 3.83972435439
Valves3['Lvmax'] = 0.009
Valves3['label'] = 'ivalve3'
Valves3['histo'] = 0
Valves3['Nval'] = 1
Valves3['Dv'] = 0.035
Valves3['type_dat'] = 0
Valves3['Cd'] = [[0.0, 0.8], [0.009, 0.8]]
Valves3['type'] = 0
Valves3['angle_V0'] = 12.3918376892
Valves3['valve_model'] = 1
Valves3['position'] = (266,367)
Valves3['tube'] = 3
Valves3['ncyl'] = 3
Valves3['typeVal'] = 'int'
Cylinders3['intake_valves'].append(Valves3)
Valves.append(Valves3)

Valves4 = dict()
Valves4['angle_VC'] = 0.349065850399
Valves4['Lvmax'] = 0.009
Valves4['label'] = 'evalve0'
Valves4['histo'] = 0
Valves4['Nval'] = 1
Valves4['Dv'] = 0.035
Valves4['type_dat'] = 0
Valves4['Cd'] = [[0.0, 0.75], [0.009, 0.75]]
Valves4['type'] = 1
Valves4['angle_V0'] = 8.55211333477
Valves4['valve_model'] = 1
Valves4['position'] = (369,79)
Valves4['tube'] = 4
Valves4['ncyl'] = 0
Valves4['typeVal'] = 'exh'
Cylinders0['exhaust_valves'].append(Valves4)
Valves.append(Valves4)

Valves5 = dict()
Valves5['angle_VC'] = 0.349065850399
Valves5['Lvmax'] = 0.009
Valves5['label'] = 'evalve1'
Valves5['histo'] = 0
Valves5['Nval'] = 1
Valves5['Dv'] = 0.035
Valves5['type_dat'] = 0
Valves5['Cd'] = [[0.0, 0.75], [0.009, 0.75]]
Valves5['type'] = 1
Valves5['angle_V0'] = 8.55211333477
Valves5['valve_model'] = 1
Valves5['position'] = (368,161)
Valves5['tube'] = 5
Valves5['ncyl'] = 1
Valves5['typeVal'] = 'exh'
Cylinders1['exhaust_valves'].append(Valves5)
Valves.append(Valves5)

Valves6 = dict()
Valves6['angle_VC'] = 0.349065850399
Valves6['Lvmax'] = 0.009
Valves6['label'] = 'evalve2'
Valves6['histo'] = 0
Valves6['Nval'] = 1
Valves6['Dv'] = 0.035
Valves6['type_dat'] = 0
Valves6['Cd'] = [[0.0, 0.75], [0.009, 0.75]]
Valves6['type'] = 1
Valves6['angle_V0'] = 8.55211333477
Valves6['valve_model'] = 1
Valves6['position'] = (374,280)
Valves6['tube'] = 6
Valves6['ncyl'] = 2
Valves6['typeVal'] = 'exh'
Cylinders2['exhaust_valves'].append(Valves6)
Valves.append(Valves6)

Valves7 = dict()
Valves7['angle_VC'] = 0.349065850399
Valves7['Lvmax'] = 0.009
Valves7['label'] = 'evalve3'
Valves7['histo'] = 0
Valves7['Nval'] = 1
Valves7['Dv'] = 0.035
Valves7['type_dat'] = 0
Valves7['Cd'] = [[0.0, 0.75], [0.009, 0.75]]
Valves7['type'] = 1
Valves7['angle_V0'] = 8.55211333477
Valves7['valve_model'] = 1
Valves7['position'] = (365,369)
Valves7['tube'] = 7
Valves7['ncyl'] = 3
Valves7['typeVal'] = 'exh'
Cylinders3['exhaust_valves'].append(Valves7)
Valves.append(Valves7)


#--------- FIN Inicializacion de Valves


#--------- Inicializacion de Tubes

Tubes = []

Tubes0 = dict()
Tubes0['diameter'] = [0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045]
Tubes0['numNorm'] = 2
Tubes0['nnod'] = 31
Tubes0['twall'] = [300.0, 301.666666667, 303.333333333, 305.0, 306.666666667, 308.333333333, 310.0, 311.666666667, 313.333333333, 315.0, 316.666666667, 318.333333333, 320.0, 321.666666667, 323.333333333, 325.0, 326.666666667, 328.333333333, 330.0, 331.666666667, 333.333333333, 335.0, 336.666666667, 338.333333333, 340.0, 341.666666667, 343.333333333, 345.0, 346.666666667, 348.333333333, 350.0]
Tubes0['ndof'] = 3
Tubes0['state_ini'] = [[1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Tubes0['label'] = 'tube0'
Tubes0['histo'] = [0, 30]
Tubes0['xnod'] = [0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.21, 0.22, 0.23, 0.24, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3]
Tubes0['posNorm'] = [0.0, 1.0]
Tubes0['longitud'] = 0.3
Tubes0['typeSave'] = 1
Tubes0['position'] = (211,86)
Tubes0['nleft'] = 0
Tubes0['tleft'] = 'tank'
Tubes0['nright'] = 0
Tubes0['tright'] = 'cylinder'

Tubes.append(Tubes0)

Tubes1 = dict()
Tubes1['diameter'] = [0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045]
Tubes1['numNorm'] = 2
Tubes1['nnod'] = 31
Tubes1['twall'] = [300.0, 301.666666667, 303.333333333, 305.0, 306.666666667, 308.333333333, 310.0, 311.666666667, 313.333333333, 315.0, 316.666666667, 318.333333333, 320.0, 321.666666667, 323.333333333, 325.0, 326.666666667, 328.333333333, 330.0, 331.666666667, 333.333333333, 335.0, 336.666666667, 338.333333333, 340.0, 341.666666667, 343.333333333, 345.0, 346.666666667, 348.333333333, 350.0]
Tubes1['ndof'] = 3
Tubes1['state_ini'] = [[1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Tubes1['label'] = 'tube1'
Tubes1['histo'] = [0, 30]
Tubes1['xnod'] = [0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.21, 0.22, 0.23, 0.24, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3]
Tubes1['posNorm'] = [0.0, 1.0]
Tubes1['longitud'] = 0.3
Tubes1['typeSave'] = 1
Tubes1['position'] = (200,171)
Tubes1['nleft'] = 0
Tubes1['tleft'] = 'tank'
Tubes1['nright'] = 1
Tubes1['tright'] = 'cylinder'

Tubes.append(Tubes1)

Tubes2 = dict()
Tubes2['diameter'] = [0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045]
Tubes2['numNorm'] = 2
Tubes2['nnod'] = 31
Tubes2['twall'] = [300.0, 301.666666667, 303.333333333, 305.0, 306.666666667, 308.333333333, 310.0, 311.666666667, 313.333333333, 315.0, 316.666666667, 318.333333333, 320.0, 321.666666667, 323.333333333, 325.0, 326.666666667, 328.333333333, 330.0, 331.666666667, 333.333333333, 335.0, 336.666666667, 338.333333333, 340.0, 341.666666667, 343.333333333, 345.0, 346.666666667, 348.333333333, 350.0]
Tubes2['ndof'] = 3
Tubes2['state_ini'] = [[1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Tubes2['label'] = 'tube2'
Tubes2['histo'] = [0, 30]
Tubes2['xnod'] = [0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.21, 0.22, 0.23, 0.24, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3]
Tubes2['posNorm'] = [0.0, 1.0]
Tubes2['longitud'] = 0.3
Tubes2['typeSave'] = 1
Tubes2['position'] = (199,280)
Tubes2['nleft'] = 0
Tubes2['tleft'] = 'tank'
Tubes2['nright'] = 2
Tubes2['tright'] = 'cylinder'

Tubes.append(Tubes2)

Tubes3 = dict()
Tubes3['diameter'] = [0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045, 0.045]
Tubes3['numNorm'] = 2
Tubes3['nnod'] = 31
Tubes3['twall'] = [300.0, 301.666666667, 303.333333333, 305.0, 306.666666667, 308.333333333, 310.0, 311.666666667, 313.333333333, 315.0, 316.666666667, 318.333333333, 320.0, 321.666666667, 323.333333333, 325.0, 326.666666667, 328.333333333, 330.0, 331.666666667, 333.333333333, 335.0, 336.666666667, 338.333333333, 340.0, 341.666666667, 343.333333333, 345.0, 346.666666667, 348.333333333, 350.0]
Tubes3['ndof'] = 3
Tubes3['state_ini'] = [[1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Tubes3['label'] = 'tube3'
Tubes3['histo'] = [0, 30]
Tubes3['xnod'] = [0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.21, 0.22, 0.23, 0.24, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3]
Tubes3['posNorm'] = [0.0, 1.0]
Tubes3['longitud'] = 0.3
Tubes3['typeSave'] = 1
Tubes3['position'] = (211,374)
Tubes3['nleft'] = 0
Tubes3['tleft'] = 'tank'
Tubes3['nright'] = 3
Tubes3['tright'] = 'cylinder'

Tubes.append(Tubes3)

Tubes4 = dict()
Tubes4['diameter'] = [0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04]
Tubes4['numNorm'] = 2
Tubes4['nnod'] = 51
Tubes4['twall'] = [450.0, 449.0, 448.0, 447.0, 446.0, 445.0, 444.0, 443.0, 442.0, 441.0, 440.0, 439.0, 438.0, 437.0, 436.0, 435.0, 434.0, 433.0, 432.0, 431.0, 430.0, 429.0, 428.0, 427.0, 426.0, 425.0, 424.0, 423.0, 422.0, 421.0, 420.0, 419.0, 418.0, 417.0, 416.0, 415.0, 414.0, 413.0, 412.0, 411.0, 410.0, 409.0, 408.0, 407.0, 406.0, 405.0, 404.0, 403.0, 402.0, 401.0, 400.0]
Tubes4['ndof'] = 3
Tubes4['state_ini'] = [[1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Tubes4['label'] = 'tube4'
Tubes4['histo'] = [0, 50]
Tubes4['xnod'] = [0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.21, 0.22, 0.23, 0.24, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3, 0.31, 0.32, 0.33, 0.34, 0.35, 0.36, 0.37, 0.38, 0.39, 0.4, 0.41, 0.42, 0.43, 0.44, 0.45, 0.46, 0.47, 0.48, 0.49, 0.5]
Tubes4['posNorm'] = [0.0, 1.0]
Tubes4['longitud'] = 0.5
Tubes4['typeSave'] = 1
Tubes4['position'] = (445,79)
Tubes4['nleft'] = 0
Tubes4['tleft'] = 'cylinder'
Tubes4['nright'] = 0
Tubes4['tright'] = 'junction'

Tubes.append(Tubes4)

Tubes5 = dict()
Tubes5['diameter'] = [0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04]
Tubes5['numNorm'] = 2
Tubes5['nnod'] = 51
Tubes5['twall'] = [450.0, 449.0, 448.0, 447.0, 446.0, 445.0, 444.0, 443.0, 442.0, 441.0, 440.0, 439.0, 438.0, 437.0, 436.0, 435.0, 434.0, 433.0, 432.0, 431.0, 430.0, 429.0, 428.0, 427.0, 426.0, 425.0, 424.0, 423.0, 422.0, 421.0, 420.0, 419.0, 418.0, 417.0, 416.0, 415.0, 414.0, 413.0, 412.0, 411.0, 410.0, 409.0, 408.0, 407.0, 406.0, 405.0, 404.0, 403.0, 402.0, 401.0, 400.0]
Tubes5['ndof'] = 3
Tubes5['state_ini'] = [[1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Tubes5['label'] = 'tube5'
Tubes5['histo'] = [0, 50]
Tubes5['xnod'] = [0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.21, 0.22, 0.23, 0.24, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3, 0.31, 0.32, 0.33, 0.34, 0.35, 0.36, 0.37, 0.38, 0.39, 0.4, 0.41, 0.42, 0.43, 0.44, 0.45, 0.46, 0.47, 0.48, 0.49, 0.5]
Tubes5['posNorm'] = [0.0, 1.0]
Tubes5['longitud'] = 0.5
Tubes5['typeSave'] = 1
Tubes5['position'] = (443,171)
Tubes5['nleft'] = 1
Tubes5['tleft'] = 'cylinder'
Tubes5['nright'] = 0
Tubes5['tright'] = 'junction'

Tubes.append(Tubes5)

Tubes6 = dict()
Tubes6['diameter'] = [0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04]
Tubes6['numNorm'] = 2
Tubes6['nnod'] = 51
Tubes6['twall'] = [450.0, 449.0, 448.0, 447.0, 446.0, 445.0, 444.0, 443.0, 442.0, 441.0, 440.0, 439.0, 438.0, 437.0, 436.0, 435.0, 434.0, 433.0, 432.0, 431.0, 430.0, 429.0, 428.0, 427.0, 426.0, 425.0, 424.0, 423.0, 422.0, 421.0, 420.0, 419.0, 418.0, 417.0, 416.0, 415.0, 414.0, 413.0, 412.0, 411.0, 410.0, 409.0, 408.0, 407.0, 406.0, 405.0, 404.0, 403.0, 402.0, 401.0, 400.0]
Tubes6['ndof'] = 3
Tubes6['state_ini'] = [[1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Tubes6['label'] = 'tube6'
Tubes6['histo'] = [0, 50]
Tubes6['xnod'] = [0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.21, 0.22, 0.23, 0.24, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3, 0.31, 0.32, 0.33, 0.34, 0.35, 0.36, 0.37, 0.38, 0.39, 0.4, 0.41, 0.42, 0.43, 0.44, 0.45, 0.46, 0.47, 0.48, 0.49, 0.5]
Tubes6['posNorm'] = [0.0, 1.0]
Tubes6['longitud'] = 0.5
Tubes6['typeSave'] = 1
Tubes6['position'] = (439,281)
Tubes6['nleft'] = 2
Tubes6['tleft'] = 'cylinder'
Tubes6['nright'] = 0
Tubes6['tright'] = 'junction'

Tubes.append(Tubes6)

Tubes7 = dict()
Tubes7['diameter'] = [0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04]
Tubes7['numNorm'] = 2
Tubes7['nnod'] = 51
Tubes7['twall'] = [450.0, 449.0, 448.0, 447.0, 446.0, 445.0, 444.0, 443.0, 442.0, 441.0, 440.0, 439.0, 438.0, 437.0, 436.0, 435.0, 434.0, 433.0, 432.0, 431.0, 430.0, 429.0, 428.0, 427.0, 426.0, 425.0, 424.0, 423.0, 422.0, 421.0, 420.0, 419.0, 418.0, 417.0, 416.0, 415.0, 414.0, 413.0, 412.0, 411.0, 410.0, 409.0, 408.0, 407.0, 406.0, 405.0, 404.0, 403.0, 402.0, 401.0, 400.0]
Tubes7['ndof'] = 3
Tubes7['state_ini'] = [[1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Tubes7['label'] = 'tube7'
Tubes7['histo'] = [0, 50]
Tubes7['xnod'] = [0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.21, 0.22, 0.23, 0.24, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3, 0.31, 0.32, 0.33, 0.34, 0.35, 0.36, 0.37, 0.38, 0.39, 0.4, 0.41, 0.42, 0.43, 0.44, 0.45, 0.46, 0.47, 0.48, 0.49, 0.5]
Tubes7['posNorm'] = [0.0, 1.0]
Tubes7['longitud'] = 0.5
Tubes7['typeSave'] = 1
Tubes7['position'] = (417,370)
Tubes7['nleft'] = 3
Tubes7['tleft'] = 'cylinder'
Tubes7['nright'] = 0
Tubes7['tright'] = 'junction'

Tubes.append(Tubes7)

Tubes8 = dict()
Tubes8['diameter'] = [0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06, 0.06]
Tubes8['numNorm'] = 2
Tubes8['nnod'] = 21
Tubes8['twall'] = [300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0]
Tubes8['ndof'] = 3
Tubes8['state_ini'] = [[1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Tubes8['label'] = 'tube8'
Tubes8['histo'] = [0, 20]
Tubes8['xnod'] = [0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2]
Tubes8['posNorm'] = [0.0, 1.0]
Tubes8['longitud'] = 0.2
Tubes8['typeSave'] = 1
Tubes8['position'] = (58,214)
Tubes8['nleft'] = 0
Tubes8['tleft'] = 'atmosphere'
Tubes8['nright'] = 0
Tubes8['tright'] = 'tank'

Tubes.append(Tubes8)

Tubes9 = dict()
Tubes9['diameter'] = [0.055, 0.0553, 0.0556, 0.0559, 0.0562, 0.0565, 0.0568, 0.0571, 0.0574, 0.0577, 0.058, 0.0583, 0.0586, 0.0589, 0.0592, 0.0595, 0.0598, 0.0601, 0.0604, 0.0607, 0.061, 0.0613, 0.0616, 0.0619, 0.0622, 0.0625, 0.0628, 0.0631, 0.0634, 0.0637, 0.064, 0.0643, 0.0646, 0.0649, 0.0652, 0.0655, 0.0658, 0.0661, 0.0664, 0.0667, 0.067, 0.0673, 0.0676, 0.0679, 0.0682, 0.0685, 0.0688, 0.0691, 0.0694, 0.0697, 0.07]
Tubes9['numNorm'] = 2
Tubes9['nnod'] = 51
Tubes9['twall'] = [400.0, 399.0, 398.0, 397.0, 396.0, 395.0, 394.0, 393.0, 392.0, 391.0, 390.0, 389.0, 388.0, 387.0, 386.0, 385.0, 384.0, 383.0, 382.0, 381.0, 380.0, 379.0, 378.0, 377.0, 376.0, 375.0, 374.0, 373.0, 372.0, 371.0, 370.0, 369.0, 368.0, 367.0, 366.0, 365.0, 364.0, 363.0, 362.0, 361.0, 360.0, 359.0, 358.0, 357.0, 356.0, 355.0, 354.0, 353.0, 352.0, 351.0, 350.0]
Tubes9['ndof'] = 3
Tubes9['state_ini'] = [[1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Tubes9['label'] = 'tube9'
Tubes9['histo'] = [0, 50]
Tubes9['xnod'] = [0.0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.21, 0.22, 0.23, 0.24, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3, 0.31, 0.32, 0.33, 0.34, 0.35, 0.36, 0.37, 0.38, 0.39, 0.4, 0.41, 0.42, 0.43, 0.44, 0.45, 0.46, 0.47, 0.48, 0.49, 0.5]
Tubes9['posNorm'] = [0.0, 1.0]
Tubes9['longitud'] = 0.5
Tubes9['typeSave'] = 1
Tubes9['position'] = (610,233)
Tubes9['nleft'] = 0
Tubes9['tleft'] = 'junction'
Tubes9['nright'] = 1
Tubes9['tright'] = 'atmosphere'

Tubes.append(Tubes9)


#--------- FIN Inicializacion de Tubes


#--------- Inicializacion de Tanks

Tanks = []

Tanks0 = dict()
Tanks0['Area_wall'] = 0.15
Tanks0['nnod'] = 6
Tanks0['ndof'] = 3
Tanks0['label'] = 'tank0'
Tanks0['Volume'] = 0.003
Tanks0['state_ini'] = [[1.1769, 101330.0, 300.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Tanks0['extras'] = 1
Tanks0['mass'] = 0.00354
Tanks0['histo'] = [0]
Tanks0['Cd_ports'] = [0.9, 0.8, 0.8, 0.8, 0.8]
Tanks0['T_wall'] = 300.0
Tanks0['h_film'] = 300.0
Tanks0['position'] = (123,205)
Tanks0['int2tube'] = [8]
Tanks0['exh2tube'] = [0, 1, 2, 3]

Tanks.append(Tanks0)


#--------- FIN Inicializacion de Tanks


#--------- Inicializacion de Junctions

Junctions = []

Junctions0 = dict()
Junctions0['nnod'] = 5
Junctions0['ndof'] = 3
Junctions0['label'] = 'junc0'
Junctions0['extras'] = 0
Junctions0['histo'] = []
Junctions0['modelo_junc'] = 1
Junctions0['position'] = (518,225)
Junctions0['type_end'] = [1, 1, 1, 1, -1]
Junctions0['node2tube'] = [4, 5, 6, 7, 9]
Junctions0['state_ini'] = [[1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0], [1.1769, 0.1, 101330.0]]
Junctions.append(Junctions0)


#--------- FIN Inicializacion de Junctions


#--------- Inicializacion de Atmospheres

Atmospheres = []

Atmospheres0 = dict()
Atmospheres0['nnod'] = 1
Atmospheres0['ndof'] = 3
Atmospheres0['state_ini'] = [1.1842, 1.0, 101330.0]
Atmospheres0['position'] = (14,271)

Atmospheres.append(Atmospheres0)

Atmospheres1 = dict()
Atmospheres1['nnod'] = 1
Atmospheres1['ndof'] = 3
Atmospheres1['state_ini'] = [1.1842, 1.0, 101330.0]
Atmospheres1['position'] = (673,234)

Atmospheres.append(Atmospheres1)


#--------- FIN Inicializacion de Atmospheres



kargs = {'Simulator':Simulator, 'Cylinders':Cylinders, 'Junctions':Junctions, 'Tubes':Tubes, 'Tanks':Tanks, 'Atmospheres':Atmospheres}
