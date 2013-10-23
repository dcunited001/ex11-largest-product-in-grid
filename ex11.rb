require 'rubygems'
require 'bundler'
Bundler.require

require 'matrix'

# monkey patching...
#   not sure why standard matrix library has: determinants, eigenvals, etc. etc.
#   but no elementwise multiplication.  bit.ly/1aGqw3H
class Matrix
  def mult(mat)
    assert_same_dimensions(mat)
    Matrix.build(row_size, column_size) do |r,c|
      self[r,c] * mat[r,c]
    end
  end

  private
  
  def assert_same_dimensions(m)
    raise "matrices must contain the same dimensions" unless (row_size == m.row_size && column_size == m.column_size)
  end
end

input = Matrix[[8, 2, 22, 97, 38, 15, 0, 40, 0, 75, 4, 5, 7, 78, 52, 12, 50, 77, 91, 8],
               [49, 49, 99, 40, 17, 81, 18, 57, 60, 87, 17, 40, 98, 43, 69, 48, 4, 56, 62, 0],
               [81, 49, 31, 73, 55, 79, 14, 29, 93, 71, 40, 67, 53, 88, 30, 3, 49, 13, 36, 65],
               [52, 70, 95, 23, 4, 60, 11, 42, 69, 24, 68, 56, 1, 32, 56, 71, 37, 2, 36, 91],
               [22, 31, 16, 71, 51, 67, 63, 89, 41, 92, 36, 54, 22, 40, 40, 28, 66, 33, 13, 80],
               [24, 47, 32, 60, 99, 3, 45, 2, 44, 75, 33, 53, 78, 36, 84, 20, 35, 17, 12, 50],
               [32, 98, 81, 28, 64, 23, 67, 10, 26, 38, 40, 67, 59, 54, 70, 66, 18, 38, 64, 70],
               [67, 26, 20, 68, 2, 62, 12, 20, 95, 63, 94, 39, 63, 8, 40, 91, 66, 49, 94, 21],
               [24, 55, 58, 5, 66, 73, 99, 26, 97, 17, 78, 78, 96, 83, 14, 88, 34, 89, 63, 72],
               [21, 36, 23, 9, 75, 0, 76, 44, 20, 45, 35, 14, 0, 61, 33, 97, 34, 31, 33, 95],
               [78, 17, 53, 28, 22, 75, 31, 67, 15, 94, 3, 80, 4, 62, 16, 14, 9, 53, 56, 92],
               [16, 39, 5, 42, 96, 35, 31, 47, 55, 58, 88, 24, 0, 17, 54, 24, 36, 29, 85, 57],
               [86, 56, 0, 48, 35, 71, 89, 7, 5, 44, 44, 37, 44, 60, 21, 58, 51, 54, 17, 58],
               [19, 80, 81, 68, 5, 94, 47, 69, 28, 73, 92, 13, 86, 52, 17, 77, 4, 89, 55, 40],
               [4, 52, 8, 83, 97, 35, 99, 16, 7, 97, 57, 32, 16, 26, 26, 79, 33, 27, 98, 66],
               [88, 36, 68, 87, 57, 62, 20, 72, 3, 46, 33, 67, 46, 55, 12, 32, 63, 93, 53, 69],
               [4, 42, 16, 73, 38, 25, 39, 11, 24, 94, 72, 18, 8, 46, 29, 32, 40, 62, 76, 36],
               [20, 69, 36, 41, 72, 30, 23, 88, 34, 62, 99, 69, 82, 67, 59, 85, 74, 4, 36, 16],
               [20, 73, 35, 29, 78, 31, 90, 1, 74, 31, 49, 71, 48, 86, 81, 16, 23, 57, 5, 54],
               [1, 70, 54, 71, 83, 51, 54, 69, 16, 92, 33, 48, 61, 43, 52, 1, 89, 19, 67, 48]]

def get_row_col_count(mat)
  [mat.row_size, mat.column_size]
end

def map_horiz(mat, n)
  r,c = get_row_col_count(mat)
  (0..n-1).map do |i|
    mat.minor (0..r-1), (i..(c + (i-n)))
  end
end

def map_vert(mat, n)
  r,c = get_row_col_count(mat)
  (0..n-1).map do |i| 
    mat.minor (i..(r + (i-n))), (0..c-1)
  end
end

def map_diags(mat, n)
  r,c = get_row_col_count(mat)
  down = (0..n-1).map do |i|
    mat.minor (i..(r + (i-n))), (i..(c + (i-n)))
  end

  up = (0..n-1).map do |i|
    #puts ([i,((r-1) + (i-n)),(n-i-1), (c-1-i)].to_s)
    mat.minor (i..(r + (i-n))), ((n-i-1)..(c-1-i))
  end

  [up, down]
end

def puts_mat_sizes(mat)
  puts mat.count
  puts mat.map { |m| get_row_col_count(m).to_s }
end

def find_max(prod = {})
  prod.values.
    map(&:to_a).
    map(&:flatten).
    map(&:max).
    max
end

nproduct = 4
horiz = map_horiz(input, nproduct)
vert = map_vert(input, nproduct)
diag_up,diag_down = map_diags(input, nproduct)

puts_mat_sizes(horiz)
puts_mat_sizes(vert)
puts_mat_sizes(diag_up)
puts_mat_sizes(diag_down)

# mult_test = Matrix[[1,2,3,4]].mult(Matrix[[4,3,2,1]])
# puts mult_test.to_s

product = {
  horiz: horiz.reduce(:mult),
  vert: vert.reduce(:mult),
  diag_up: diag_up.reduce(:mult),
  diag_down: diag_down.reduce(:mult)
}

puts find_max(product)
