import gleam/result
import gleeunit
import glm_complex as complex

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn to_string_test() {
  let real_only = complex.Complex(3.14, 0.0)
  let imag_only = complex.Complex(0.0, 2.34)
  let both = complex.Complex(4.54, 2.34)
  let negative_imag = complex.Complex(4.6, -1.23)
  let zero = complex.Complex(0.0, 0.0)
  assert complex.to_string(real_only) == "3.14"
  assert complex.to_string(imag_only) == "2.34i"
  assert complex.to_string(both) == "(4.54+2.34i)"
  assert complex.to_string(negative_imag) == "(4.6-1.23i)"
  assert complex.to_string(zero) == "0i"
}

/// Test basic imaginary number multiplications
pub fn powers_of_i_test() {
  let i = complex.Complex(0.0, 1.0)
  assert complex.multiply(i, i) == complex.Complex(-1.0, 0.0)
  assert complex.multiply(complex.multiply(i, i), i)
    == complex.Complex(-0.0, -1.0)
  assert complex.multiply(complex.multiply(complex.multiply(i, i), i), i)
    == complex.Complex(1.0, -0.0)
}

/// Test division of complex numbers
pub fn divide_test() {
  // Ensure that division properly inverts multiplication
  let orig = complex.Complex(5.6, 4.2)
  let multiplier = complex.Complex(2.4, 6.8)
  let product = complex.multiply(orig, multiplier)
  let quot =
    complex.divide(product, multiplier)
    |> result.unwrap(complex.Complex(0.0, 0.0))
  assert quot == orig

  // Cover edge case of real divisors
  let real = complex.Complex(2.0, 0.0)
  let quot =
    complex.divide(orig, real)
    |> result.unwrap(complex.Complex(0.0, 0.0))
  assert quot == complex.Complex(2.8, 2.1)

  // Ensure divison by zero errors
  assert complex.divide(orig, complex.Complex(0.0, 0.0)) == Error(Nil)
}
