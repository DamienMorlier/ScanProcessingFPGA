fi = fopen("./sine_lut.bin");
bin = fread(fi);

new_bin = zeros(2^16, 1);

for i=1:(2^16-9)
    row = 0;
    for j=1:8
        n = new_bin(i + j);
        row = row + bitsll(n, 2*i);
    end
    new_bin(i) = row;
end

plot(new_bin);
