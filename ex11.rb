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
    raise ::StandardError, "matrices must contain the same dimensions" unless (row_size == m.row_size && column_size == m.column_size)
  end
end

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
