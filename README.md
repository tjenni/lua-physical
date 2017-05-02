# lua-physical

This is a pure Lua library which provides functions and object for doing computation with physical quantities.

In general, a physical quantity consists of a numerical value called magnitude and a unit. There are restrictions to the allowed mathematical operations with physical quantities. For example the quantity time cannot be added to the quantity mass. Furthermore, new quantities can be obtained by multiplication or division from other base quantities. The density is such an example. It can be calculated by dividing the mass of a body by its volume.


## Usage

The library can be loaded with the command `require("physical")`. Like probably no other Lua library, lua-physical pollutes the global namespace with objects that represent physical units. This is in order to simplify the entry of physical quantities. By convention, each unit starts with an underscore in order to distinguish them from other variables. A basic example is the following:

```
> require("physical")
> a = 1.4 * _m
> b = 2 * _m
> A = (a*b):to(_m^2)
> print(A)
2.8 * _m^2
```

In the above example, two length a and b are defined and then multiplied. The result is an area. The unit of this area is `_m*_m` and has to be explicitly converted to `_m^2` be the `:to()` command. The nexst example is slightly more complicated.

```
> require("physical")
> m1 = 22 * _kg
> m2 = 5.972e24 * _kg
> r = 6371 * _km
> F_G = (_Gc * m1 * m2 / r^2):to(_N)
> print(F_G)
2.16032(10)e2 * _N
```

The goal of the above example is to calculate the gravitational force on a body with mass `22 kg` sitting on the surface of the earth. As one can see, the result is given with an uncertainty in parentheses. This is because the gravitational constant is not exactly known. Lua-physical can deal with uncertainties. One can give an uncertainty explicitly by instantiating `physical.Number()`.

```
> physical = require("physical")
> a = physical.Number(2,0.1) * _m
> A = (a^2):to(_m^2)
> V = (a^3):to(_m^3)
> print(a)
2.00(10) * _m
> print(A)
4.0(4) * _m^2
> print(V)
8.0(12) * _m^3
```

The uncertainty gets propagated by the Gaussian rule for completely uncorrelated uncertainties, i.e. they are added in quadrature. In the above example it is assumed, that the three sides of the cube were measured independently from each other and that the uncertainties of these measurements are not correlated. If one prefers another way of printing uncertainties, there are a few formatting options.
```
> physical = require("physical")
> l = physical.Number(20.453,0.002) * _m

> physical.Number.format = physical.Number.SCIENTIFIC

> physical.Number.seperateUncertainty = true
> print(l)
(2.0453 +/- 0.0002)e1 * _m

> physical.Number.seperateUncertainty = false
> print(l)
2.0453(2)e1 * _m

> physical.Number.format = physical.Number.DECIMAL

> physical.Number.seperateUncertainty = true
> print(l)
(20.453 +/- 0.002) * _m

> physical.Number.seperateUncertainty = false
20.453(2) * _m
```

One can define, if the uncertainty should be printed in the plus-minus notation or in the parentheses notation. 


## List of Units and Prefixes

### Base Units
The SI defines seven base units. For dimensionless quantities the unit `_1` can be used.

| Symbol | Name     | Dimension           |
| -------|----------|---------------------|
| `_1`   | Number   | Dimensionless       |
| `_m`   | Meter    | Length              |
| `_kg`  | Kilogram | Mass                |
| `_s`   | Second   | Time                |
| `_A`   | Ampere   | Electric Current    |
| `_K`   | Kelvin   | Temperature         |
| `_mol` | Mole     | Amount of Substance |
| `_cd`  | Candela  | Luminous Intensity  |

Source: http://physics.nist.gov/cuu/Units/units.html


### SI-Prefixes
Most of the SI Units can have prefixes, i.e. `_km, _hL, _ms, _uJ`.

| Symbol | Name  | Factor |   | Symbol | Name  | Factor |
| -------|-------|--------|---| -------|-------|--------|
| `Y`    | Yotta | 10^24  |   | `y`    | Yocto | 10^-24 |
| `Z`    | Zetta | 10^21  |   | `z`    | Zepto | 10^-21 |
| `E`    | Exa   | 10^18  |   | `a`    | Atto  | 10^-18 |
| `P`    | Peta  | 10^15  |   | `f`    | Femto | 10^-15 |
| `T`    | Tera  | 10^12  |   | `p`    | Pico  | 10^-12 |
| `G`    | Giga  | 10^9   |   | `n`    | Nano  | 10^-9  |
| `M`    | Mega  | 10^6   |   | `u`    | Micro | 10^-6  |
| `k`    | Kilo  | 10^3   |   | `m`    | Milli | 10^-3  |
| `h`    | Hecto | 10^2   |   | `c`    | Centi | 10^-2  |
| `da`   | Deca  | 10^1   |   | `d`    | Deci  | 10^-1  | 

Source: http://physics.nist.gov/cuu/Units/prefixes.html


### Derived SI Units
| Symbol  | Name           | Definition      | Dimension                   |
| --------|----------------|-----------------|-----------------------------|
| `_rad`  | Radian         | `_1`            | Plane Angle (Dimensionless) |
| `_sr`   | Steradian      | `_rad^2`        | Solid Angle (Dimensionless) |
| `_Hz`   | Hertz          | `1/_s`          | Frequency                   |
| `_N`    | Newton         | `_kg*_m/_s^2`   | Force                       |
| `_Pa`   | Pascal         | `_N/_m^2`       | Pressure                    |
| `_J`    | Joule          | `_N*_m`         | Energy                      |
| `_W`    | Watt           | `_J/_s`         | Power                       |
| `_C`    | Coulomb        | `_A*_s`         | Electric Charge             |
| `_V`    | Volt           | `_J/_C`         | Electric Potential          |
| `_F`    | Farad          | `_C/_V`         | Electric Capacitance        |
| `_Ohm`  | Ohm            | `_V/_A`         | Electric Resistance         |
| `_S`    | Siemens        | `_A/_V`         | Electric Conductance        |
| `_Wb`   | Weber          | `_V*_s`         | Magnetic Flux               |
| `_T`    | Tesla          | `_Wb/_m^2`      | Magnetic Flux Density       |
| `_H`    | Henry          | `_Wb/_A`        | Inductance                  |
| `_lm`   | Lumen          | `_cd*_sr`       | Luminous Flux               |
| `_lx`   | Lux            | `_lm/_m^2`      | Illuminance                 |
| `_Bq`   | Becquerel      | `1/_s`          | Radioactivity               |
| `_Gy`   | Gray           | `_J/_kg`        | Absorbed Dose               |
| `_Sv`   | Sievert        | `_J/_kg`        | Equivalent Dose             |
| `_kat`  | katal          | `_mol/_s`       | Catalytic Activity          |
| `_degC` | Degree Celsius | `x/_K - 273.15` | Temperature                 |

Source: http://physics.nist.gov/cuu/Units/units.html

### Mathematical Constants

| Symbol  | Name         | Definition                                            |
| --------|--------------|-------------------------------------------------------|
| `Pi`    | Pi           | `3.1415926535897932384626433832795028841971693993751` |
| `e`     | Euler Number | `2.7182818284590452353602874713526624977572470936999` |

## Physical Constants

| Symbol    | Name                             | Definition                          |
| ----------|----------------------------------|-------------------------------------|
| `_c`      | Speed of Light                   | `299792458 * _m/_s`                 |
| `_Gc`     | Gravitational Constant           | `6.67408(31)e-11 * _m^3/(_kg*_s^2)` |
| `_h_P`    | Planck Constant                  | `6.626070040(81)e-34 * _J*_s`       |       
| `_h_Pbar` | Reduced Planck Constant          | `_hP/(2*Pi)`                        |
| `_e`      | Elementary Charge                | `1.6021766208(98)e-19 * _C`         |
| `_u_0`    | Vacuum Permeability              | `4e-7*Pi * _N*_A^2`                 |
| `_e_0`    | Vacuum Permitivity               | `1/(_u0*_c^2)`                      |
| `_u`      | Atomic Mass Unit                 | `1.66053904(2)e-27 * _kg`           |
| `_m_e`    | Electron Rest Mass               | `9.10938356(11)e-31 * _kg`          |
| `_m_p`    | Proton Mass                      | `1.672621898(21)e-27 * _kg`         |
| `_m_n`    | Neutron Mass                     | `1.674927471(21)e-27 * _kg`         |
| `_u_B`    | Bohr Magneton                    | `_e*_hPbar/(2*_m_e)`                |
| `_u_N`    | Nuclear Magneton                 | `_e*_hPbar/(2*_m_p)`                |
| `_alpha`  | Finestructure Constant           | `_u0*_e^2*_c/(2*_hP)`               |
| `_Ry`     | Rydberg Constant                 | `_alpha^2*_m_e*_c/(2*_hP)`          |
| `_N_A`    | Avogadro Constant                | `6.022140857(74)e23 /_mol`          |
| `_R`      | Molar Gas Constant               | `8.3144598(48) * _J/(_K*_mol)`      |
| `_sigma`  | Stefan-Boltzmann Constant        | `Pi^2*_k_B^4/(60*_h_Pbar^3*_c^2)`   |
| `_g_0`    | Standard Acceleration of Gravity | `9.80665 * _m/_s^2`                 |
| `_r_sun`  | Nominal Solar Radius             | `695700 * _km`                      |

Source: http://physics.nist.gov/cuu/Constants/

### Non-SI Units accepted for use with the SI

| Symbol       | Name                            | Definition          | Dimension                   |
| -------------|---------------------------------|---------------------|-----------------------------|
| `_deg`       | Degree                          | `(Pi/180) * _rad`   | Plane Angle (Dimensionless) |
| `_arcmin`    | Arc Minute                      | `_deg/60`           | Plane Angle (Dimensionless) |
| `_arcsec`    | Arc Second                      | `_arcmin/60`        | Plane Angle (Dimensionless) |
| `_au`        | Astronomical Unit               | `149597870700 * _m` | Length                      |
| `_ly`        | Lightyear                       | `_c*_a`             | Length                      |
| `_pc`        | Parsec                          | `(648000/Pi)*_au`   | Length                      |
| `__angstrom` | Angstrom                        | `1e-10 * _m`        | Length                      |
| `_barn`      | Barn                            | `1e-28 * _m^2`      | Area                        |
| `_L`         | Liter                           | `0.001 * _m^3`      | Volume                      |
| `_t`         | Tonne                           | `1000 * _kg`        | Mass                        |
| `_min`       | Minute                          | `60 * _s`           | Time                        |
| `_h`         | Hour                            | `60 * _min`         | Time                        |
| `_d`         | Day                             | `24 * _h`           | Time                        |
| `_wk`        | Week                            | `7 * _d`            | Time                        |
| `_a`         | Julian Year                     | `365.25 * _d`       | Time                        |
| `_bar`       | Bar                             | `100000 * _Pa`      | Pressure                    |
| `_atm`       | Standard Atmosphere             | `101325 * _Pa`      | Pressure                    |
| `_at`        | Technical Atmosphere            | `_g0 * _kg/_m^2`    | Pressure                    |
| `_mmHg`      | Millimeter of Mercury           | `133.322387415*_Pa` | Pressure                    |
| `_cal`       | Thermochemical Calorie          | `4.184 * _J`        | Energy                      |
| `_cal_IT`    | International Calorie           | `4.1868 * _J`       | Energy                      |
| `_g_TNT`     | Gram of TNT                     | `1e3 * _cal`        | Energy                      |
| `_t_TNT`     | Ton of TNT                      | `1e9 * _cal`        | Energy                      |
| `_eV`        | Electron-Volt                   | `_e * _V`           | Energy                      |
| `_Wh`        | Watt-Hour                       | `_W*_h`             | Energy                      |
| `_VA`        | Volt-Ampere                     | `_V*_A`             | Power                       |
| `_PS`        | Metric Horsepower               | `75*_g0*_kg*_m/_s`  | Power                       |
| `_Ah`        | Ampere-Hour                     | `_A*_h`             | Electric Charge             |

Source: http://physics.nist.gov/cuu/Units/outside.html

### Other Metric Units

| Symbol  | Name              | Definition         | Dimension                   |
| --------|-------------------|--------------------|-----------------------------|
| `_tsp`  | Metric Teaspoon   | `0.005 * _L`       | Volume                      |
| `_Tbsp` | Metric Tablespoon | `3 * _tsp`         | Volume                      |
| `_gon`  | Gradian           | `Pi/200*_rad`      | Plane Angle (Dimensionless) |
| `_tr`   | Turn              | `2*Pi*_rad`        | Plane Angle (Dimensionless) |
| `_sp`   | Spat              | `4*Pi*_sr`         | Solid Angle (Dimensionless) |
| `_kp`   | Kilopond          | `_g0*_kg`          | Force                       |
| `_Ci`   | Curie             | `3.7e10 * _Bq`     | Radioactivity               |
| `_rd`   | Rad               | `0.01 * _Gy`       | Absorbed Dose               |
| `_rem`  | Rem               | `0.01 * _Sv`       | Equivalent Dose             |
| `_Ro`   | Roentgen          | `2.58e-4 * _C/_kg` | Ionic Dose                  |

Source: http://physics.nist.gov/cuu/Units/outside.html

## Imperial Units

| Symbol    | Name                  | Definition                 | Dimension   |
| ----------|-----------------------|----------------------------|-------------|
| `_in`     | Inch                  | `0.0254 * _m`              | Length      |
| `_th`     | Thou                  | `0.001 * _in`              | Length      |
| `_pc`     | Pica                  | `_in/6`                    | Length      |
| `_pt`     | Point                 | `_in/72`                   | Length      |
| `_hh`     | Hand                  | `4 * _in`                  | Length      |
| `_ft`     | Foot                  | `12 * _in`                 | Length      |
| `_yd`     | Yard                  | `3 * _ft`                  | Length      |
| `_rd`     | Rod                   | `5.5 * _yd`                | Length      |
| `_ch`     | Chain                 | `4 * _rd`                  | Length      |
| `_fur`    | Furlong               | `10 * _ch`                 | Length      |
| `_mi`     | Mile                  | `8 * _fur`                 | Length      |
| `_lea`    | League                | `3 * _mi`                  | Length      |
| `_nmi`    | Nautical Mile         | `1852 * _m`                | Length      |
| `_nlea`   | Nautical League       | `3 * _nmi`                 | Length      |
| `_cb`     | Cable                 | `_nmi/10`                  | Length      |
| `_ftm`    | Fathom                | `6 * _ft`                  | Length      |
| `_ac`     | Acre                  | `43560 * _ft^2`            | Area        |
| `_gal`    | Gallon                | `4.54609 * _L`             | Volume      |
| `_qt`     | Quart                 | `_gal/4`                   | Volume      |
| `_pint`   | Pint                  | `_qt/2`                    | Volume      |
| `_cup`    | Cup                   | `_pint/2`                  | Volume      |
| `_gi`     | Gill                  | `_pint/4`                  | Volume      |
| `_fl_oz`  | Fluid Ounce           | `_gi/5`                    | Volume      |
| `_fl_dr`  | Fluid Dram            | `_fl_oz/8`                 | Volume      |
| `_gr`     | Grain                 | `64.79891 * _mg`           | Mass        |
| `_lb`     | Pound                 | `7000 * _gr`               | Mass        |
| `_oz`     | Ounce                 | `_lb/16`                   | Mass        |
| `_dr`     | Dram                  | `_oz/256`                  | Mass        |
| `_st`     | Stone                 | `14 * _lb`                 | Mass        |
| `_qtr`    | Quarter               | `2*_st`                    | Mass        |
| `_cwt`    | Hundredweight         | `4*_qtr`                   | Mass        |
| `_ton`    | Long Ton              | `20*_cwt`                  | Mass        |
| `_lb_t`   | Troy Pound            | `5760*_gr`                 | Mass        |
| `_oz_t`   | Troy Ounce            | `_lb_t/12`                 | Mass        |
| `_pwt`    | Pennyweight           | `24 * _gr`                 | Mass        |
| `_fir`    | Firkin                | `56*_lb`                   | Mass        |
| `_ftn`    | Fortnight             | `14*_d`                    | Time        |
| `_degF`   | Degree Fahrenheit     | `(x/_K + 459.67)*(5/9)`    | Temperature |
| `_degR`   | Degree Rankine        | `(x/_K)*(5/9)`             | Temperature |
| `_kn`     | Knot                  | `_nmi/_h`                  | Velocity    |
| `_lbf`    | Pound Force           | `_lb*_g0`                  | Force       |
| `_pdl`    | Poundal               | `_lb*_ft/_s^2`             | Force       |
| `_slug`   | Slug                  | `_lbf*_s^2/_ft`            | Mass        |
| `_psi`    | Pound per Square Inch | `_lbf/_in^2`               | Pressure    |
| `_BTU_it` | British Thermal Unit  | `1055.05585262 * _J`       | Energy      |
| `_BTU_th` | British Thermal Unit  | `(1897.83047608/1.8) * _J` | Energy      |
| `_hp`     | Horsepower            | `33000*_ft*_lbf/_min`      | Power       |

Source: https://en.wikipedia.org/wiki/Imperial_units

### US Customary and Survey Units

| Symbol      | Name              | Definition       | Dimension |
| ------------|-------------------|------------------|-----------|
| `_in_US`    | US Survey Inch    | `_m/39.37`       | Length    |
| `_hh_US`    | US Survey Hand    | `4 * _in_US`     | Length    |
| `_ft_US`    | US Survey Foot    | `3 * _hh_US`     | Length    |
| `_li_US`    | US Survey Link    | `0.66 * _ft_US`  | Length    |
| `_yd_US`    | US Survey Yard    | `3 * _ft_US`     | Length    |
| `_rod_US`   | US Survey Rod     | `5.5 * _yd_US`   | Length    |
| `_ch_US`    | US Survey Chain   | `4 * _rd_US`     | Length    |
| `_fur_US`   | US Survey Furlong | `10 * _ch_US`    | Length    |
| `_mi_US`    | US Survey Mile    | `8 * _fur_US`    | Length    |
| `_lea_US`   | US Survey League  | `3 * _mi_US`     | Length    |
| `_ftm_US`   | US Survey Fathom  | `72 * _in_US`    | Length    |
| `_cbl_US`   | US Survey Cable   | `120 * _ftm_US`  | Length    |
| `_ac_US`    | US Survey Acre    | `_ch * _fur_US`  | Area      |
| `_gal_US`   | US Gallon         | `231 * _in^3`    | Volume    |
| `_qt_US`    | US Quart          | `_gal_US/4`      | Volume    |
| `_pint_US`  | US Pint           | `_qt_US/2`       | Volume    |
| `_cup_US`   | US Cup            | `_pint_US/2`     | Volume    |
| `_gi_US`    | US Gill           | `_pint_US/4`     | Volume    |
| `_fl_oz_US` | US Fluid Ounce    | `_gi_US/4`       | Volume    |
| `_Tbsp_US`  | US Tablespoon     | `_fl_oz_US/2`    | Volume    |
| `_tsp_US`   | US Teaspoon       | `_Tbsp_US/3`     | Volume    |
| `_fl_dr_US` | US Fluid Dram     | `_fl_oz_US/8`    | Volume    |
| `_qtr_US`   | US Quarter        | `25 * _lb`       | Mass      |
| `_cwt_US`   | US Hundredweight  | `4 * _qtr_US` | Mass      |
| `_ton_US`   | Short Ton         | `20*_cwt_US`  | Mass      |

Source: https://en.wikipedia.org/wiki/United_States_customary_units










