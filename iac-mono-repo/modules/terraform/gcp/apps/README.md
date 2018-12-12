"Apps" will be made up of a number of "Services". Each app should have three terraform files; 

- input.tf (for variable input) 
- a config .tf (file named by the parent directory for gluing of services and application specific configurations) 
- output.tf for any variables that will be accessed by other applications or services