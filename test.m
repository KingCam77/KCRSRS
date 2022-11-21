function y = test(x)

if x > 1
  f = @(x) 2*x
elseif x < 1
  f = @(x) 5*x
end
y=f(x)
end
