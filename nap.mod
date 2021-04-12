: Persistent sodium channel

: Set units
UNITS {
   (S)     = (siemens)
   (mV) = (millivolt)
   (mA) = (milliamp)
}

NEURON {
   SUFFIX nap
   USEION na READ ena WRITE ina
   RANGE gmax, ina
}

: Set default parameters
PARAMETER {
   gmax = 0.11e-3 (S/cm2)
}

ASSIGNED {
   ina  (mA/cm2)
   ena  (mA/cm2)
   v  (mV)
}

STATE { m }

: Calculate activation and current
BREAKPOINT {
   SOLVE states METHOD cnexp
   ina = gmax * m * (v - ena)
}

: Initialize activation to steady state
INITIAL { m = (1.0 / (1.0 + exp( (v + 48.77) / (-3.68) ))) }

: Calculate change in activation
DERIVATIVE states {
   UNITSOFF
   m' = (1.0 / (1.0 + exp( (v + 48.77) / (-3.68) ))) - m
   UNITSON
}
