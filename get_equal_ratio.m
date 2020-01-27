function ratio = get_equal_ratio(matrix1, matrix2)
N = size(matrix1);
ratio = sum(sum(sum(matrix1 == matrix2)))/(N(1)*N(2)*N(3));
end