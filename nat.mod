: Transient sodium channel

: Set units
UNITS {
   (S)     = (siemens)
   (mV) = (millivolt)
   (mA) = (milliamp)
}

: Declare transient sodium channel
NEURON {
   SUFFIX nat
   USEION na READ ena WRITE ina
   RANGE gmax, ina
}

: Set default parameters
PARAMETER {
   gmax = 300e-3 (S/cm2)
}

ASSIGNED {
   ina (mA/cm2)
   ena (mV)
   v (mV)
}

STATE { m h }

: Calculate current for transient sodium channel
BREAKPOINT {
   SOLVE states METHOD cnexp
   ina = gmax * m^3 * h * (v - ena)
}

: Initialize activation and inactivation to steady state
INITIAL { 
m = (1.0 / (1.0 + exp( (v + 29.13) / (-8.922)  ) ))
h = (1.0 / (1.0 + exp( (v + 47) / 5)))
}

: Calculate change in activation / inactivation 
DERIVATIVE states {
   UNITSOFF
   m' = ((1.0 / (1.0 + exp( (v + 29.13) / (-8.922)  ) )) - m) / taum(v)

   h' = ((1.0 / (1.0 + exp( (v + 47) / 5))) - h) / tauh(v)
   UNITSON
}

: Function for activation time constant
FUNCTION taum(Vm (mV)) (/ms) {
   UNITSOFF
   taum = 0.13 + 3.43 / (1 + exp( (Vm + 45.35) /   5.98))
   UNITSON
}

: Function for inactivation time constant
FUNCTION tauh(Vm (mV)) (/ms) {
   UNITSOFF
   tauh = 0.36 + exp( (Vm + 20.65) / (-10.47) )
   UNITSON
}
