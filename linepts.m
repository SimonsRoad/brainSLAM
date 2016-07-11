function result = linepts(a, b)
%gets coordinates for points on a line

if ~(round(a(1)-b(1))==0)
    m = (a(2) - b(2)) / (a(1) - b(1));
    n = b(2) - b(1) * m;
    
    x = min(a(1), b(1)) : max(a(1), b(1));
    y = m * x + n;
    
else
    x = zeros(abs(b(2)),1);
    if b(2) < 0; y = b(2) : 0;
    else y = 0 : b(2);
    end
end

for i = 1 : length(x)
    result(i,:) = round([x(i), y(i)]);
end

end
