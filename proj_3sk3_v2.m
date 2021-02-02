image=imread('img_example_lr.png');
[x_res, y_res, z_res] = size(image); %Get Resolution of image

%Load B C going from 1 3 5 7 top down in B, right left in C
%allocate F and A

C=zeros(4,4,'double');
for y_b=1:4
    for x_b=1:4
        C(x_b,y_b)=(2*y_b-1)^(4-x_b);
    end
end

B=transpose(C);
F=zeros(4,4,'double');
A=zeros(4,4,3,'double');


%create new image array
new_image= zeros(round(x_res*2),round(y_res*2),z_res, 'uint8');

%create working array

current_img=zeros(4*2,4*2,3,'uint8');
current_old=zeros(4,4,3,'uint8');

%%begin loop
 % _u starts at zero, and counts units to the max. not an index.
 
for x_u=0:x_res-4
    for y_u=0:y_res-4


        %load working array
        
        x_w=1; %index counters
        y_w=1;
        z_w=1;
        
        for x_c =1:4
            y_w=1;
            for y_c=1:4
                z_w=1;
                for z_c=1:3
                    current_old(x_c,y_c,z_c)=image(x_c+(1*x_u),y_c+(1*y_u),z_c);
                    current_img(x_w,y_w,z_w)=image(x_c+(1*x_u),y_c+(1*y_u),z_c); %Copies current working unit data to current working array
                    z_w=z_w+1;
                end
                y_w=y_w+2;
            end
            x_w=x_w+2;
        end
        %48 op
        
        
        %Load F
        
        F=double(current_old);
        
        %calculate for A
        
        % A1=inv(B)*F(:,:,1)*inv(C)
        A(:,:,1)=(B\F(:,:,1))/C;
        A(:,:,2)=(B\F(:,:,2))/C;
        A(:,:,3)=(B\F(:,:,3))/C;
        
        %load working matrix with interpolated values
        
        for i=1:4*2
            for j=1:4*2
                for k=1:3
                current_img(i,j,k)=gannon_intp(i,j,A,k);
                end
            end
        end
        %192 op
        
        %load working matrix into new image
        
        for i=1:4*2
            for j=1:4*2
                for k=1:3
                new_image(round(i+((2)*x_u)),round(j+((2)*y_u)),k)=current_img(i,j,k);
                end
            end
        end
    end
    %192 op
    
    
end
        


imwrite(new_image,'pepper_interpolated.png')

function[val]=gannon_intp(x,y,A,z)
    val=[x^3 x^2 x 1]*A(:,:,z)*transpose([y^3 y^2 y 1]);
end


