goodimagename='img_example_hr.png';
myimage='pepper_interpolated.png';
matlabimage='test_matlab.png';



good=imread(goodimagename);

bad_m=imread(matlabimage);
bad_g=imread(myimage);


err_m=immse(bad_m,good)
err_g=immse(bad_g,good)


success_ratio=err_m/err_g

