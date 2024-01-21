# Surface-Expression-Of-Low-Basal-Friction
This repository shares the MATLAB code and data associated with the drafted publication titled "Surface Expression of Low Basal Friction Under Antarctic Grounding Lines" which will be submitted for review to the Journal of Glaciology.

*work in progress*

## Model Code
### Friction Ramp Modeling
The model_code/friction_ramp subfolder holds files pertinent to the baseline friction ramp modeling discussed in the "Hypothesis from Modeling" section of the paper.
#### Scripts, Inputs, and Outputs
- **ssa_wshelf_fine_fxn.m**: Runs the flowline model described in the paper with a fine resolution grid upstream of the grounding line. Allows for the implementation of both a basal friction ramp and basal melt ramp at the same "intrusion distance" L.
  	- Inputs:
  
	Input  |  Data Type  |  Description
	------------- | -------------  |  -------------
	L  |  Double  | The length (m) of the friction ramp and/or basal melt ramp.
	frxn_ramp  |  Boolean |  Describes whether a friction ramp is simulated (true = 1, false = 0).
	bmbi  |  Double  | The highest ("initial") rate of basal melt (km/yr) prescribed on the basal melt ramp. When set to 0, no basal melt ramp is applied.
	shelf_only  |  Boolean  | Describes whether basal melt is applied to the ice shelf only (1) or upstream of the grounding line (0).

	- Outputs:
   
	The function returns a data structure called **params** described below:
	Field  |  Data Type  |  Description
	------------- | -------------  |  -------------
	b0	|  a	| a
	bx	|  a	| a
	sill_min	|  a	| a
	sill_max	|  a	| a
	sill_slope	|  a	| a
	year	|  a	| a
	Aglen	|  a	| a
	nglen	|  a	| a
	Bglen	|  a	| a
	m	|  a	| a
	accum	|  a	| a
	bmbi	|  a	| a
	shelf_only	|  a	| a
	L	|  a	| a
	C	|  a	| a
	frxn_ramp	|  a	| a
	rhoi	|  a	| a
	rhow	|  a	| a
	g	|  a	| a
	hscale	|  a	| a
	ascale	|  a	| a
	bmbscale|  a	| a
	uscale	|  a	| a
	xscale	|  a	| a
	tscale	|  a	| a
	eps	|  a	| a
	lambda	|  a	| a
	transient	|  a	| a
	tfinal	|  a	| a
	Nt	|  a	| a
	dt	|  a	| a
	Nx	|  a	| a
	N1	|  a	| a
	N2	|  a	| a
	Ntot|  a	| a
	sigGZ	|  a	| a
	sigma	|  a	| a
	sigma_elem |  a	| a
	dsigma	|  a	| a
	h_old	|  a	| a
	xg_old	|  a	| a
	sfc_elev	|  a	| a
	sfc_d1	|  a	| a
	sfc_d2	|  a	| a
	h	|  a	| a
	u	|  a	| a
	xg	|  a	| a
	hf	|  a	| a
	b	|  a	| a
	x_real	|  a	| a

- **friction_ramp_simulation.m**: Uses **ssa_wshelf_fine_fxn.m** to run the friction ramp simulations shared in the paper with the following outputs following the structure of **params**:
  	- Outputs:
  
  	Output File Name  |  Data Type  |  Description
	------------- | -------------  |  -------------
  	ctl.mat	|  Data structure (See **params**)| Standard simulation with no friction ramp, meaning a constant friction coefficient under the entire grounded portion.
 	frxn1.mat	|  Data structure (See **params**)	| Simulation with a friction ramp 1 km in length.
	frxn5.mat	|  Data structure (See **params**)	| Simulation with a friction ramp 5 km in length.
	frxn10.mat	|  Data structure (See **params**)	| Simulation with a friction ramp 10 km in length.
	
- **friction_ramp_figure.m**:	Uses the output files produced by **friction_ramp_simulation.m** to reproduce Figure 1b in the paper. Plots the surface slope over the distance upstream of the grounding line for the ctl, frxn1, frxn5, and frxn10 scenarios.

### Basal Melt Modeling
The model_code/friction_ramp subfolder holds files pertinent to the basal melt ramp modeling discussed in the "Hypothesis from Modeling" section of the paper.
#### Scripts, Inputs, and Outputs
- **ssa_wshelf_fine_fxn.m**: Same as the **ssa_wshelf_fine_fxn.m** described in the Friction Ramp Modeling section.
- **basal_melt_simulation.m**: Uses **ssa_wshelf_fine_fxn.m** to run the basal melt simulations shared in the paper with the following outputs following the structure of **params**:
  	- Outputs:
  
  	Output File Name  |  Data Type  |  Description
	------------- | -------------  |  -------------
  	ctl_1.mat	|  Data structure (See **params**)| Simulation with 1 m/yr of basal melt on the ice shelf only.
 	bmb1_1.mat	|  Data structure (See **params**)	| Simulation with 1 m/yr of basal melt on the ice shelf and on a linearly decreasing "ramp" that reaches 0 m/yr at 1 km upstream of the grounding line.
	bmb1_5.mat	|  Data structure (See **params**)	| Simulation with 1 m/yr of basal melt on the ice shelf and on a linearly decreasing "ramp" that reaches 0 m/yr at 5 km upstream of the grounding line.
	bmb1_10.mat	|  Data structure (See **params**)	| Simulation with 1 m/yr of basal melt on the ice shelf and on a linearly decreasing "ramp" that reaches 0 m/yr at 10 km upstream of the grounding line.
  	ctl_10.mat	|  Data structure (See **params**)| Simulation with 10 m/yr of basal melt on the ice shelf only.
 	bmb10_1.mat	|  Data structure (See **params**)	| Simulation with 10 m/yr of basal melt on the ice shelf and on a linearly decreasing "ramp" that reaches 0 m/yr at 1 km upstream of the grounding line.
	bmb10_5.mat	|  Data structure (See **params**)	| Simulation with 10 m/yr of basal melt on the ice shelf and on a linearly decreasing "ramp" that reaches 0 m/yr at 5 km upstream of the grounding line.
	bmb10_10.mat	|  Data structure (See **params**)	| Simulation with 10 m/yr of basal melt on the ice shelf and on a linearly decreasing "ramp" that reaches 0 m/yr at 10 km upstream of the grounding line.

- **basal_melt_figure.m**: Uses the output files produced by **basal_melt_simulation.m** to reproduce Figure 2 in the paper. Plots the surface slope over the distance upstream of the grounding line for the ctl_1, bmb1_1, bmb1_5, bmb1_10, ctl_10, bmb1_10, bmb5_10, and bmb10_10 scenarios.

### Topography Ridge Modeling
The model_code/friction_ramp subfolder holds files pertinent to the bed topography ridges modeling discussed in the "Hypothesis from Modeling" section of the paper.
#### Scripts, Inputs, and Outputs
- **ssa_wshelf_ridge_fxn.m**: Runs the flowline model described in the paper with a fine resolution grid upstream of the grounding line. Allows for the implementation of both a basal friction ramp and basal melt ramp at the same "intrusion distance" L. Allows for the implementation of "ridges" in the bed topography, namely a sudden onset of a different slope, at a defined distance upstream of the grounding line.
  	- Inputs:
 
  	Input  |  Data Type  |  Description
	------------- | -------------  |  -------------
	L  |  Double  | The length (m) of the friction ramp and/or basal melt ramp.
	frxn_ramp  |  Boolean |  Describes whether a friction ramp is simulated (true = 1, false = 0).
	bmbi  |  Double  | The highest ("initial") rate of basal melt (km/yr) prescribed on the basal melt ramp. When set to 0, no basal melt ramp is applied.
	shelf_only  |  Boolean  | Describes whether basal melt is applied to the ice shelf only (1) or upstream of the grounding line (0).
	ridge	|  Data structure with fields "rx" and "rx0"  | Defines the slope of the ridge (field "rx") and the distance upstream of the grounding line where the ridge is implemented (field "rx0"). The baseline slope "rx" is 1e-3.

  	- Outputs:
- **topography_ridge_simulation.m**: Uses **ssa_wshelf_ridge_fxn.m** to run the topography ridge simulations shared in the paper, where no friction ramp or basal melt is applies, with the following outputs following the structure of **params**, with the addition of the 'ridge' field described above:
  	- Outputs:
  	  
	Output File Name  |  Data Type  |  Description
	------------- | -------------  |  -------------
  	ctl.mat	|  Data structure (See **params**)| Simulation with standard 
 	shlw1.mat	|  Data structure (See **params**)	| Simulation with a topography ridge that is 1/4x of the control slope implemented 1 km upstream of the grounding line.
	shlw5.mat	|  Data structure (See **params**)	| Simulation with a topography ridge that is 1/4x of the control slope implemented 5 km upstream of the grounding line.
  	shlw10.mat	|  Data structure (See **params**)	| Simulation with a topography ridge that is 1/4x of the control slope implemented 10 km upstream of the grounding line.
  	stp1.mat	|  Data structure (See **params**)	| Simulation with a topography ridge that is 2x of the control slope implemented 1 km upstream of the grounding line.
 	stp5.mat	|  Data structure (See **params**)	| Simulation with a topography ridge that is 2x of the control slope implemented 5 km upstream of the grounding line.
	stp10.mat	|  Data structure (See **params**)	| Simulation with a topography ridge that is 2x of the control slope implemented 10 km upstream of the grounding line.

- **topography_ridge_figure.m**: Uses the output files produced by **topography_ridge_simulation.m** to reproduce Figure 3 in the paper. Plots the surface slope over the distance upstream of the grounding line for the ctl, shlw1, shlw5, shlw10, stp1, stp5, and stp10 scenarios.

## Algorithm Code
The along-flow distance algorithm aims to find a nearest neighbor slope break point and nearest along-flow slope break point from a linear interpolation between the nearby slope break points.

- Inputs: The inputs for this algorithm include the flexure point and slope break point datasets from Li and others (2022) along with data from BedMachine. Due to size constraints, we are unable to share the BedMachine dataset, so the script allows for users to process their own BedMachine data. This will result in the sfc_dx, sfc_dy, bed_x, and bed_y inputs described below. To download the BedMachine data, visit nsidc.org/data and search for MEaSUREs BedMachine Antarctica. Download the netcdf filetype for the entire catchment. Our study used BedMachine Version 3.

	Input  |  Data Type  |  Description
	------------- | -------------  |  -------------
	f.mat  |  Data structure  | Flexure point locations from Li and others (2022). We have added Polar Sterographic coordinates ('px' and 'py) and a boolean field, 'icerise', which describes whether we have identified the flexure point and slope break points lie on an ice rise (1) or on the ice sheet (0).
	ib_rise.mat  |  Data structure |  Select slope break point locations from Li and others (2022) which we have identified as residing within an ice rise. 
	ib_sheet.mat  |  Data structure  | Select slope break point locations from Li and others (2022) which we have identified as residing within the ice sheet.
	sfc_dx.mat  |  Double (matrix) | The partial derivative of the surface elevations in the x direction provided by BedMachine.
	sfc_dy.mat  |  Double (matrix) | The partial derivative of the surface elevations in the y direction provided by BedMachine.
  	bed_x.mat  |  Double (matrix) | The Polar Stereographic x-coordinates aligning with the data in the sfc_dx and sfc_dy matrices.
  	bed_y.mat  |  Double (matrix) | The Polar Stereographic y-coordinates aligning with the data in the sfc_dx and sfc_dy matrices.

- Outputs: The algorithm returns a data structure **out** that shares findings for each flexure point in the dataset.

	Field  |  Data Type  |  Description
	------------- | -------------  |  -------------
	fx	|  Double	|	The Polar Stereographic x-coordinate of the flexure point.
	fy	|  Double	|	The Polar Stereographic y-coordinate of the flexure point.
	near_ibx	|  Double	|	The Polar Stereographic x-coordinate of the nearest neighbor slope break point to the flexure point.
	near_iby	|  Double	|	The Polar Stereographic y-coordinate of the nearest neighbor slope break point to the flexure point.
	near_ib_dist	|  Double	|	The Eucledian distance between the nearest neighbor slope break point and the flexure point in meters.
	ibx	|  Double	|	The Polar Stereographic x-coordinate of the along-flow interpolated slope break. If no point is found, this field will be NAN.
	iby	|  Double	|	The Polar Stereographic y-coordinate of the along-flow interpolated slope break. If no point is found, this field will be NAN.
	ib_dist	|  Double	|	The Eucledian distance between the along-flow slope break point and the flexure point in meters. If no along-flow slope break is found, this field is NAN.
	gradients_flag	|  String	|	Quality-check which describes the difference between the surface gradient at the flexure point and the slope break point. If the difference between the two unit vectors is less than 90 degrees, this field is 'ok'. If the difference is greater than 90 degrees, this field is 'abnormal'. If no along-flow slope break is found or the algorithm is unable to resolve either surface gradient, this field is NAN.
	dir_flag	|  String	|	Describes whether the along-flow slope break point is 'upstream' or 'downstream' of the flexure point. If no along-flow direction can be found with the BedMachine data, this field is 'no sfc gradient at f'. If an along-flow direction is found without an along-flow slope break, this field is 'no ib found'. 
	dir_vec		|  Double (2x1 vector)	|	If an along-flow slope break point is found, this field holds the unit vector describing the along-flow direction from the flexure point. If no along-flow slope break is found, this field is NAN.
	icerise	|  Boolean	|	Describes whether the flexure point and slope break points lie on an ice rise (1) or on the ice sheet (0).
