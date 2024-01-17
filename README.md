# Surface-Expression-Of-Low-Basal-Friction
This repository shares the code associated with the drafted publication titled "Surface Expression of Low Basal Friction Under Antarctic Grounding Lines" which will be submitted for review to the Journal of Glaciology. We share code and data used for the modeling and the along-flow distance algorithm discussed in the paper.

*work in progress*


## Model Code
### Friction Ramp Modeling
The model_code/friction_ramp subfolder holds files pertinent to the baseline friction ramp modeling discussed in the "Hypothesis from Modeling" section of the paper.
#### Scripts
- **ssa_wshelf_fine_fxn.m**: Runs the flowline model described in the paper with a fine resolution grid upstream of the grounding line. Allows for the implementation of both a basal friction ramp and basal melt ramp at the same "intrusion distance" L.

	Inputs  |  Data Type  |  Description
	------------- | -------------  |  -------------
	L  |  Double  | The length (m) of the friction ramp and/or basal melt ramp.
	frxn_ramp  |  Boolean |  Whether a friction ramp is simulated.
	bmbi  |  Double  | The highest ("initial") rate of basal melt (km/yr) prescribed on the basal melt ramp. When set to 0, no basal melt ramp is applied.
	shelf_only  |  Boolean  | Whether basal melt is applied to the ice shelf only or upstream of the grounding line.
	
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
	b0	|  a	| a

- **friction_ramp_simulation.m**: Uses **ssa_wshelf_fine_fxn.m** to run the friction ramp simulations shared in the paper,
- **friction_ramp_figure.m**:	


#### Data Structures
The following structures are the outputs obtained by running the friction_ramp_simulation.m script as written.


### Basal Melt Modeling

### Topography Ridge Modeling

## Algorithm Code
