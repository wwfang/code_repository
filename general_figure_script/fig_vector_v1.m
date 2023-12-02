function hq=fig_vector(x,y,u,v,scale,varargin)
%  x,y : the horizontal coordinate;longitude and latitude
% (u,v) : the vetor along x-direction and y-direction, respectively.
%         the dimension of (u,v) must be in consistent with (x,y)
%  scale : <1 means zoom out >1 means zoom in
%  fig_vector(...,name,value)
%          name : color : the color of arrow
%                 Speed : 'on' the filled contourf figure about wind speed. 
%                          'off' means no contourf figure
if size(x)~=size(y) | size(x) ~= size(u) | size(x) ~= size(v) | size(y) ~= size(u) | size(y) ~= size(v) ...
        | size(u) ~= size(v)
    error('Please Check the dimension of x , y, u and v');
end
args=varargin;
nargs=length(varargin);
if nargs >= 1
    if mod(nargs,2)~=0
        Error('Error: \nMiss a value or variable name!');
    end
    name_args=args(1:2:end);
    value_args=args(2:2:end);
    if find(strcmp(name_args,'color')==1)
        ccolor=value_args{strcmp(name_args,'color')};
    end
    if find(strcmp(name_args,'Speed')==1)
%         ccolor=value_args{strcmp(name_args,'Speed')};
       Spe=sqrt(u.^2 + v.^2);
    end
end
ccolor='k';
%画图前的设置：投影方式;;
m_proj('Equidistant','lon',[min(x(:)) max(x(:))],'lat',[min(y(:)) max(y(:))]);%设置投影的方式以及范围；

uu=u*scale;vv=v*scale;
hq=m_quiver(x,y,uu,vv,0);
m_gshhs_h('patch',[.5 .5 .5]);   %直接调用m_gshhs_h
m_grid('linestyle','none','tickdir','in','fontname','Times New Roman','fontsize',12);
hq.Color=ccolor;
if exist('Spe')
   hold on 
   m_contourf(x,y,Spe,'linestyle','none','levelstep',0.5);
   hold off
end

end