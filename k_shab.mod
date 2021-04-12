: Shab potassium channel


: Set units
UNITS {
   (S)     = (siemens)
   (mV) = (millivolt)
   (mA) = (milliamp)
}

: Declare Shab potassium channel
NEURON {
   SUFFIX k_shab
   USEION k READ ek WRITE ik
   RANGE gmax, ik
}

: Set maximal Shab potassium conductance per Matlab model
PARAMETER {
    gmax = 0.86e-3 (S/cm2)
	v_h_m = -29.69 (mV)
	K_m = 10.49 (/mV)
	amp_m = 30.72 (/s)
	v_max_m = -63.69 (mV)
	sigma_m = 28.54 (/mV)
}

: Declare variables for Shab potassium channel
ASSIGNED {
   ik   (mA/cm2)
   ek   (mA/cm2)
   v   (mV)
}

: Declare activation state parameter for Shab potassium channel
STATE { m }

: Calculate current for Shab potassium channel
BREAKPOINT {
   SOLVE states METHOD cnexp
   ik = gmax * m^4 * (v - ek)
}

: Initialize activation
INITIAL { 
	m = 1.0 / (1 +  v_exp(v, v_h_m, K_m))
}

: Calculate change in activation per Matlab code
DERIVATIVE states {
   UNITSOFF
   m' = (1.0 / (1 +  v_exp(v, v_h_m, K_m)) - m) / (amp_m * v_exp(v,v_max_m,sigma_m))
   UNITSON
}

FUNCTION v_exp(v1 (mV), v2 (mV), scale (/mV)) {
	UNITSOFF
	v_exp = exp(-(v1-v2)/scale)
	UNITSON
}