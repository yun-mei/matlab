
T=input('Enter the value for the temperature T in Fahrenheit:'); % 90 
R=input('Enter the value for the relative humidity:'); %.90

HI= -42.379 + (2.04901523*T) +(9.91857586*R) - (6.83783E-3 * T^(2))...
    - (5.481717E-2 * R^(2)) + ( 1.22874E-3 *T^(2)*R) + (8.5282E-4 * T*R^(2))...
-(1.99E-6 *T^(2)*R^(2));

disp(['The Heat Index temperature is:' num2str(round(HI))])
