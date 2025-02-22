function bn = Setbn_3D(Bernoulli_n_values, n_mob, Un)
global Cn num_elements n_topBC n_leftBC_x n_rightBC_x n_leftBC_y n_rightBC_y n_bottomBC N;

% bn = zeros(num_elements,1);

%extract variables from struct (for brevity in eqns)
Bn_posX = Bernoulli_n_values.Bn_posX;
Bn_negX = Bernoulli_n_values.Bn_negX;
Bn_posY = Bernoulli_n_values.Bn_posY;
Bn_negY = Bernoulli_n_values.Bn_negY;
Bn_posZ = Bernoulli_n_values.Bn_posZ;
Bn_negZ = Bernoulli_n_values.Bn_negZ;

%calculate main part here
bn = Cn*Un;

%add on BC's
index = 0;
for k = 1:N
    if (k == 1)  %--------------------------------------------------------------------
        for j = 1:N
            if(j == 1)  %different for 1st subblock
                for i = 1:N
                    index = index +1;
                    if (i == 1)  %1st element has 2 BC's
                        bn(index,1) = bn(index,1) + n_mob(i+1,j+1,k+1)*n_leftBC_x(1,1)*Bn_negX(i+1,j+1,k+1) + n_mob(i+1,j+1,k+1)*n_leftBC_y(1,1)*Bn_negY(i+1,j+1,k+1) + n_mob(i+1,j+1,k+1)*n_bottomBC*Bn_negZ(i+1,j+1,k+1);  %+1 b/c netcharge and n_mob include endpoints but i,j index only the interior
                    elseif (i==N)
                        bn(index,1) = bn(index,1) + n_mob(N+1+1, 1+1, 1+1)*n_rightBC_x(1,1)*Bn_posX(i+1+1,j+1,k+1) + n_mob(N+1, 0+1, 1+1)*n_leftBC_y(N,1)*Bn_negY(i+1,j+1,k+1) + n_mob(N+1, 1+1, 0+1)*n_bottomBC*Bn_negZ(i+1,j+1,k+1);
                    else  %middle elements in 1st subblock
                        bn(index,1) = bn(index,1) + n_mob(i+1, 0+1, 1+1)*n_leftBC_y(i, 1)*Bn_negY(i+1,j+1,k+1) + n_mob(i+1, 1+1, 0+1)*n_bottomBC*Bn_negZ(i+1,j+1,k+1);
                    end
                end
            elseif(j == N)  %different for last subblock within k=1 subblock group
                for i = 1:N
                    index = index +1;
                    if (i==1)  %1st element has 2 BC's
                        bn(index,1) = bn(index,1) + n_mob(0+1,N+1, 1+1)*n_leftBC_x(N,1)*Bn_negX(i+1,j+1,k+1) + n_mob(1+1, N+1+1, 1+1)*n_rightBC_y(1,1)*Bn_posY(i+1,j+1+1,k+1) + n_mob(1+1, N+1, 0+1)*n_bottomBC*Bn_negZ(i+1,j+1,k+1);
                    elseif (i==N)
                        bn(index,1) = bn(index,1) + n_mob(N+1+1,N+1, 1+1)*n_rightBC_x(N,1)*Bn_posX(i+1+1,j+1,k+1) + n_mob(N+1, N+1+1, 1+1)*n_rightBC_y(N,1)*Bn_posY(i+1,j+1+1,k+1) + n_mob(N+1,N+1, 0+1)*n_bottomBC*Bn_negZ(i+1,j+1,k+1);
                    else %inner rows of Nth subblock
                        bn(index,1) = bn(index,1) + n_mob(i+1,N+1+1, 1+1)*n_rightBC_y(i,1)*Bn_posY(i+1,j+1+1,k+1) + n_mob(i+1, N+1, 0+1)*n_bottomBC*Bn_negZ(i+1,j+1,k+1);
                    end
                end
            else  %interior subblocks of 1st (k = 1) subblock group   
                for i = 1:N
                    index = index +1;
                    if (i==1)
                        bn(index,1) = bn(index,1) + n_mob(0+1, j+1, 1+1)*n_leftBC_x(j,1)*Bn_negX(i+1,j+1,k+1) + n_mob(1+1, j+1, 0+1)*n_bottomBC*Bn_negZ(i+1,j+1,k+1);
                    elseif (i==N)
                        bn(index,1) = bn(index,1) + n_mob(N+1+1, j+1, 1+1)*n_rightBC_x(j,1)*Bn_posX(i+1+1,j+1,k+1) + n_mob(N+1, j+1, 0+1)*n_bottomBC*Bn_negZ(i+1,j+1,k+1);
                    else
                        bn(index,1) = bn(index,1) + n_mob(i+1, j+1, 0+1)*n_bottomBC*Bn_negZ(i+1,j+1,k+1);
                    end
                end
            end
        end
    elseif (k == N)  %last subblock group  
        for j = 1:N
            if(j == 1)  %different for 1st subblock
                for i = 1:N
                    index = index +1;
                    if (i == 1)  %1st element has 2 BC's
                        bn(index,1) = bn(index,1) + n_mob(0+1, 1+1, N+1)*n_leftBC_x(1,N)*Bn_negX(i+1,j+1,k+1) + n_mob(1+1, 0+1, N+1)*n_leftBC_y(1,N)*Bn_negY(i+1,j+1,k+1) + n_mob(1+1, 1+1, N+1+1)*n_topBC*Bn_posZ(i+1,j+1,k+1+1);  %+1 b/c netcharge and n_mob include endpoints but i,j index only the interior
                    elseif (i==N)
                        bn(index,1) = bn(index,1) + n_mob(N+1+1, 1+1, N+1)*n_rightBC_x(1,N)*Bn_posX(i+1+1,j+1,k+1) + n_mob(N+1, 0+1, N+1)*n_leftBC_y(N,N)*Bn_negY(i+1,j+1,k+1) + n_mob(N+1, 1+1, N+1+1)*n_topBC*Bn_posZ(i+1,j+1,k+1+1);
                    else  %middle elements in 1st subblock
                        bn(index,1) = bn(index,1) + n_mob(i+1, 0+1, N+1)*n_leftBC_y(i, N)*Bn_negY(i+1,j+1,k+1) + n_mob(i+1, 1+1, N+1+1)*n_topBC*Bn_posZ(i+1,j+1,k+1+1);
                    end
                end
            elseif(j == N)  %different for last subblock within k=N subblock group 
                for i = 1:N
                    index = index +1;
                    if (i==1)  %1st element has 2 BC's
                        bn(index,1) = bn(index,1) + n_mob(0+1,N+1, N+1)*n_leftBC_x(N,N)*Bn_negX(i+1,j+1,k+1) + n_mob(1+1, N+1+1, N+1)*n_rightBC_y(1,N)*Bn_posY(i+1,j+1+1,k+1) + n_mob(1+1, N+1, N+1+1)*n_topBC*Bn_posZ(i+1,j+1,k+1+1);
                    elseif (i==N)
                        bn(index,1) = bn(index,1) + n_mob(N+1+1,N+1, N+1)*n_rightBC_x(N,N)*Bn_posX(i+1+1,j+1,k+1) + n_mob(N+1, N+1+1, N+1)*n_rightBC_y(N,N)*Bn_posY(i+1,j+1+1,k+1) + n_mob(N+1,N+1, N+1+1)*n_topBC*Bn_posZ(i+1,j+1,k+1+1);
                    else %inner rows of Nth subblock
                        bn(index,1) = bn(index,1) + n_mob(i+1,N+1+1, N+1)*n_rightBC_y(i,N)*Bn_posY(i+1,j+1+1,k+1) + n_mob(i+1, N+1, N+1+1)*n_topBC*Bn_posZ(i+1,j+1,k+1+1);
                    end
                end
            else  %interior subblocks of last (k = N) subblock group
                for i = 1:N
                    index = index +1;
                    if (i==1)
                        bn(index,1) = bn(index,1) + n_mob(0+1, j+1, N+1)*n_leftBC_x(j,N)*Bn_negX(i+1,j+1,k+1) + n_mob(1+1, j+1, N+1+1)*n_topBC*Bn_posZ(i+1,j+1,k+1+1);
                    elseif (i==N)
                        bn(index,1) = bn(index,1) + n_mob(N+1+1, j+1, N+1)*n_rightBC_x(j,N)*Bn_posX(i+1+1,j+1,k+1) + n_mob(N+1, j+1, N+1+1)*n_topBC*Bn_posZ(i+1,j+1,k+1+1);
                    else
                        bn(index,1) = bn(index,1) + n_mob(i+1, j+1, N+1+1)*n_topBC*Bn_posZ(i+1,j+1,k+1+1);
                    end
                end
            end
        end
    else   %interior subblock groups (k=2:N-1)
        for j = 1:N
            if(j == 1)  %different for 1st subblock 
                for i = 1:N
                    index = index +1;
                    if (i == 1)  %1st element has 2 BC's
                        bn(index,1) = bn(index,1) + n_mob(0+1, 1+1, k+1)*n_leftBC_x(1,k)*Bn_negX(i+1,j+1,k+1)  + n_mob(1+1, 0+1, k+1)*n_leftBC_y(1,k)*Bn_negY(i+1,j+1,k+1);  %+1 b/c netcharge and n_mob include endpoints but i,j index only the interior
                    elseif (i==N)
                        bn(index,1) = bn(index,1) + n_mob(N+1+1, 1+1, k+1)*n_rightBC_x(1,k)*Bn_posX(i+1+1,j+1,k+1) + n_mob(N+1, 0+1, k+1)*n_leftBC_y(N,k)*Bn_negY(i+1,j+1,k+1);
                    else  %middle elements in 1st subblock
                        bn(index,1) = bn(index,1) + n_mob(i+1, 0+1, k+1)*n_leftBC_y(i, k)*Bn_negY(i+1,j+1,k+1);
                    end
                end
            elseif(j == N)  %different for last subblock
                for i = 1:N
                    index = index +1;
                    if (i==1)  %1st element has 2 BC's
                        bn(index,1) = bn(index,1) + n_mob(0+1,N+1, k+1)*n_leftBC_x(N,k)*Bn_negX(i+1,j+1,k+1) + n_mob(1+1, N+1+1, k+1)*n_rightBC_y(1,k)*Bn_posY(i+1,j+1+1,k+1);
                    elseif (i==N)
                        bn(index,1) = bn(index,1) + n_mob(N+1+1,N+1, k+1)*n_rightBC_x(N,k)*Bn_posX(i+1+1,j+1,k+1) + n_mob(N+1, N+1+1, k+1)*n_rightBC_y(N,k)*Bn_posY(i+1,j+1+1,k+1);
                    else %inner rows of Nth subblock
                        bn(index,1) = bn(index,1) + n_mob(i+1,N+1+1, k+1)*n_rightBC_y(i,k)*Bn_posY(i+1,j+1+1,k+1);
                    end
                end
            else  %interior subblocks
                for i = 1:N
                    index = index +1;
                    if (i==1)
                        bn(index,1) = bn(index,1) + n_mob(0+1, j+1, k+1)*n_leftBC_x(j,k)*Bn_negX(i+1,j+1,k+1);
                    elseif (i==N)
                        bn(index,1) = bn(index,1) + n_mob(N+1+1, j+1, k+1)*n_rightBC_x(j,k)*Bn_posX(i+1+1,j+1,k+1);
                    end
                end
            end
        end
    end
end
