inputfilename='img_example_lr.png';
outputfilename='test_matlab.png';

image=imread(inputfilename);
new=imresize(image,2,'bicubic');
imwrite(new,outputfilename);