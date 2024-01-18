# Surface-Expression-Of-Low-Basal-Friction
This repository shares the code associated with the drafted publication titled "Surface Expression of Low Basal Friction Under Antarctic Grounding Lines" which will be submitted for review to the Journal of Glaciology. We share code and data used for the modeling and the along-flow distance algorithm discussed in the paper.

*work in progress*


## Model Code
### Friction Ramp Modeling
The model_code/friction_ramp subfolder holds files pertinent to the baseline friction ramp modeling discussed in the "Hypothesis from Modeling" section of the paper.
#### Scripts
- **ssa_wshelf_fine_fxn.m**: Runs the flowline model described in the paper with a fine resolution grid upstream of the grounding line. Allows for the implementation of both a basal friction ramp and basal melt ramp at the same "intrusion distance" L.
  	- Inputs:
  
	Inputs  |  Data Type  |  Description
	------------- | -------------  |  -------------
	L  |  Double  | The length (m) of the friction ramp and/or basal melt ramp.
	frxn_ramp  |  Boolean |  Whether a friction ramp is simulated.
	bmbi  |  Double  | The highest ("initial") rate of basal melt (km/yr) prescribed on the basal melt ramp. When set to 0, no basal melt ramp is applied.
	shelf_only  |  Boolean  | Whether basal melt is applied to the ice shelf only or upstream of the grounding line.

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

- **friction_ramp_simulation.m**: Uses **ssa_wshelf_fine_fxn.m** to run the friction ramp simulations shared in the paper,
- **friction_ramp_figure.m**:	


#### Data Structures
The following structures are the outputs obtained by running the friction_ramp_simulation.m script as written.


### Basal Melt Modeling
The model_code/friction_ramp subfolder holds files pertinent to the basal melt ramp modeling discussed in the "Hypothesis from Modeling" section of the paper.

### Topography Ridge Modeling
The model_code/friction_ramp subfolder holds files pertinent to the bed topography ridges modeling discussed in the "Hypothesis from Modeling" section of the paper.

## Algorithm Code
The along-flow distance algorithm aims to find a nearest neighbor slope break point and nearest along-flow slope break point from a linear interpolation between the nearby slope break points. 

- Inputs:

- Outputs:

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
gradients_flag	|  String	|	Quality-check which describes the difference 
dir_flag	|  String	|	Describes whether the along-flow slope break point is 'upstream' or 'downstream' of the flexure point. If an along-flow slope break is found, this field is 'no ib found'.
dir_vec		|  Double (vector)	|	...
icerise	|  Boolean	|	Describes whether the flexure point and slope break points lie on an icerise (1) or on the ice sheet (0).
