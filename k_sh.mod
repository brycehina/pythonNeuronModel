: Shab potassium channel


: Set units
UNITS {
   (S)     = (siemens)
   (mV) = (millivolt)
   (mA) = (milliamp)
}

: Declare Shab potassium channel
NEURON {
   SUFFIX k_sh
   USEION k READ ek WRITE ik
   RANGE gmax, ik
}

: Set maximal Shab potassium conductance per Matlab model
PARAMETER {
    gmax = 2.35e-3 (S/cm2)
	v_h_m = -34.18 (mV)
	K_m = 9.75 (/mV)
	amp_m = 1.79 (/s)
	v_max_m = -4.07 (mV)
	sigma_m = 73.88 (/mV)
	
	v_h_h = -93.19 (mV)
	K_h = 54.49 (/mV)
	amp_h = 22.49 (/s)
	v_max_h = 35.81 (mV)
	sigma_h = 52.04 (/mV)
}

: Declare variables for Shab potassium channel
ASSIGNED {
   ik   (mA/cm2)
   ek   (mA/cm2)
   v   (mV)
}

: Declare activation state parameter for Shab potassium channel
STATE { m h }

: Calculate current for Shab potassium channel
BREAKPOINT {
   SOLVE states METHOD cnexp
   ik = gmax * h * m^4 * (v - ek)
}

: Initialize activation
INITIAL { 
	m = 1.0 / (1 +  v_exp(v, v_h_m, K_m))
	h = 1.0 / (1 +  v_exp(v, v_h_h, K_h))
}

: Calculate change in activation per Matlab code
DERIVATIVE states {
   UNITSOFF
   m' = (1.0 / (1 +  v_exp(v, v_h_m, K_m)) - m) / (amp_m * v_exp(v,v_max_m,sigma_m))
   h' = (1.0 / (1 +  v_exp(v, v_h_h, K_h)) - h) / (amp_h * v_exp(v,v_max_h,sigma_h))
   UNITSON
}

FUNCTION v_exp(v1 (mV), v2 (mV), scale (/mV)) {
	UNITSOFF
	v_exp = exp(-(v1-v2)/scale)
	UNITSON
}