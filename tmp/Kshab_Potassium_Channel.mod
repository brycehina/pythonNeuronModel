: Shab potassium channel


: Set units
UNITS {
   (S)     = (siemens)
   (mV) = (millivolt)
   (mA) = (milliamp)
}

: Declare Shab potassium channel
NEURON {
   SUFFIX Kshab_Potassium_Channel
   USEION k READ ek WRITE ik
   RANGE gmax, ik
}

: Set maximal Shab potassium conductance per Matlab model
PARAMETER {
   gmax = 10e-3 (S/cm2)
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
INITIAL { m = (1.0 / (1.0 + exp( (v + 42.1) / (-23.1) ))) }

: Calculate change in activation per Matlab code
DERIVATIVE states {
   UNITSOFF
   m' = ((1.0 / (1.0 + exp( (v + 42.1) / (-23.1) ))) - m) / taum(v)
   UNITSON
}

: Function for activation time constant per Matlab code
FUNCTION taum(Vm (mV)) (/ms) {
   UNITSOFF
   taum = exp(0.38 * (Vm + 42.1) / (-23.1)) / (0.2 * (1 + exp(-1 * (Vm + 42.1) / (-23.1))))
   UNITSON
}
