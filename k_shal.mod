: Shab potassium channel


: Set units
UNITS {
   (S)     = (siemens)
   (mV) = (millivolt)
   (mA) = (milliamp)
}

: Declare Shab potassium channel
NEURON {
   SUFFIX k_shal
   USEION k READ ek WRITE ik
   RANGE gmax, ik
}

: Set maximal Shab potassium conductance per Matlab model
PARAMETER {
    gmax = 1.25e-3 (S/cm2)
	v_h_m = -48.63 (mV)
	K_m = 7.65 (/mV)
	amp_m = 0.05 (/s)
	v_max_m = -74.86 (mV)
	sigma_m = 61.54 (/mV)
	
	v_h_h = -43.05 (mV)
	K_h = 1.73 (/mV)
	amp_h = 44.52 (/s)
	v_max_h = -66.24 (mV)
	sigma_h = 180.11 (/mV)
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