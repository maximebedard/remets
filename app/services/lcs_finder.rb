class LcsFinder
  def initialize(content_1, content_2)
    @content_1 = content_1
    @content_2 = content_2
    @m = content_1.size
    @n = content_2.size

    build_matrix
    calculate_matrix
  end

  def longest_subsequence
    backtrack(m, n)
  end

  def all_longest_subsequences
    backtrack_all(m, n)
  end

  def lcs_length
    matrix[m][n]
  end

  def diff
    build_diff(m, n)
  end

  private

  attr_reader :matrix,
    :content_1,
    :content_2,
    :m,
    :n

  def backtrack(i, j)
    case
    when i == 0 || j == 0
      ""
    when content_1[i - 1] == content_2[i - 1]
      backtrack(i - 1, j - 1) + content_1[i - 1]
    when matrix[i][j - 1] > matrix[i - 1][j]
      backtrack(i, j - 1)
    else
      backtrack(i - 1, j)
    end
  end

  def backtrack_all(i, j)
    case
    when i == 0 || j == 0
      Set.new([""])
    when content_1[i - 1] == content_2[j - 1]
      Set.new(backtrack_all(i - 1, j - 1).map { |z| z + content_1[i - 1] })
    else
      r = Set.new
      r.merge(backtrack_all(i, j - 1)) if matrix[i][j - 1] >= matrix[i - 1][j]
      r.merge(backtrack_all(i - 1, j)) if matrix[i - 1][j] >= matrix[i][j - 1]
      r
    end
  end

  def build_diff(i, j)
    case
    when i > 0 && j > 0 && content_1[i - 1] == content_2[j - 1]
      build_diff(i - 1, j - 1) + " " + content_1[i - 1]
    when j > 0 && (i.zero? || matrix[i][j - 1] >= matrix[i - 1][j])
      build_diff(i, j - 1) + "+ " + content_2[j - 1]
    when i > 0 && (j.zero? || matrix[i][j - 1] < matrix[i - 1][j])
      build_diff(i - 1, j) + "- " + content_1[i - 1]
    else
      ""
    end
  end

  def build_matrix
    @matrix = Array.new(m + 1) { Array.new(n + 1) { 0 } }
  end

  def calculate_matrix
    (1..m).each do |i|
      (1..n).each do |j|
        matrix[i][j] =
          if content_1[i - 1] == content_2[j - 1]
            matrix[i - 1][j - 1] + 1
          else
            [matrix[i][j - 1], matrix[i - 1][j]].max
          end
      end
    end
  end
end
